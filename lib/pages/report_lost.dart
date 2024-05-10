import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lostfound/pages/homePage.dart';
import 'package:lostfound/components/my_drawer.dart';

class ReportLost extends StatefulWidget {
  const ReportLost({super.key});

  @override
  State<ReportLost> createState() => _ReportLostState();
}

class _ReportLostState extends State<ReportLost> {
  final _descriptionController = TextEditingController();
  XFile? _image;
  LocationData? _location;
  final _auth = FirebaseAuth.instance;

  bool _isLoading = false; // New loading state variable

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  Future<void> _getLocation() async {
    Location location = Location();
    try {
      _location = await location.getLocation();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _createPost() async {
    final currentUser = _auth.currentUser;

    if (_image == null || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Container(
            child: Text("Please provide both an image and a description"),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final storageRef = FirebaseStorage.instance.ref();
    final postImageRef = storageRef.child('post_images/${_image!.name}');

    await postImageRef.putFile(File(_image!.path)); // Upload file

    final imageUrl = await postImageRef.getDownloadURL(); // Get download URL

    await FirebaseFirestore.instance.collection('posts').add({
      'description': _descriptionController.text,
      'imageUrl': imageUrl,
      'location': {
        'latitude': _location?.latitude,
        'longitude': _location?.longitude,
      },
      'timestamp': FieldValue.serverTimestamp(),
      'userEmail': currentUser?.email, // Add current user email
      'userId': currentUser?.uid, // Add current user ID
    });

    setState(() {
      _isLoading = false; // Hide loading indicator
    });

    // Show SnackBar on successful submission
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.green,
          content: Text("Lost item reported successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Lost'),
        centerTitle: true,
      ),
      body: Stack(
        // Use Stack to overlay the loading indicator
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildActionButton("Pick Image", _pickImage),
                const SizedBox(height: 20),
                _buildActionButton("Get Location", _getLocation),
                const SizedBox(height: 20),
                _buildDescriptionField(),
                const SizedBox(height: 20),
                _buildActionButton("Create Post", _createPost),
              ],
            ),
          ),
          if (_isLoading) // Show loading indicator when loading
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.background,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _descriptionController,
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        maxLines: null,
        decoration: InputDecoration(
          hintText: "Description",
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      ),
    );
  }
}
