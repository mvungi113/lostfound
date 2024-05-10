import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:lostfound/components/my_btn_nav.dart';
import 'package:lostfound/components/my_drawer.dart';
import 'package:lostfound/pages/chatpage.dart';

class HomePage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading posts'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No posts available'));
          }

          final allPosts = snapshot.data!.docs;
          final recentPosts =
              allPosts.take(5).toList(); // First 5 for horizontal scroll
          final otherPosts =
              allPosts.skip(5).toList(); // Remaining for vertical grid

          return Column(
            children: [
              // Horizontal list for recent posts
              Container(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentPosts.length,
                  itemBuilder: (context, index) {
                    final post = recentPosts[index];
                    final data = post.data() as Map<String, dynamic>;
                    final userEmail = data['userEmail'];
                    final userId = data['userId'];

                    return Container(
                      height: 350,
                      width: 250,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(right: 5, left: 5, top: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Column(
                        // mainAxisignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 200,
                            child: data['imageUrl'] != null
                                ? Image.network(
                                    data['imageUrl'],
                                    width: double.infinity,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image),
                          ),
                          Expanded(
                            child: Text(
                              data['description'] ?? 'No description',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      receiverEmail: userEmail,
                                      receiverID: userId,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.message_rounded,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Vertical grid for the other posts
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // Two items per row
                    crossAxisSpacing: 8.0, // Space between items horizontally
                    mainAxisSpacing: 8.0, // Space between items vertically
                  ),
                  itemCount: otherPosts.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final post = otherPosts[index];
                    final data = post.data() as Map<String, dynamic>;
                    final userEmail = data['userEmail'];
                    final userId = data['userId'];

                    return Container(
                      margin: const EdgeInsets.only(left: 10, right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).colorScheme.secondary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Column(
                        // mainAxisignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 250,
                            child: data['imageUrl'] != null
                                ? Image.network(
                                    data['imageUrl'],
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image, size: 100),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Text(
                              data['description'] ?? 'No description',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      receiverEmail: userEmail,
                                      receiverID: userId,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.message_rounded,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
