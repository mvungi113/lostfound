import 'package:flutter/material.dart';
import 'package:lostfound/components/my_drawer.dart';
import 'package:lostfound/components/user_tile.dart';
import 'package:lostfound/pages/chatpage.dart';
import 'package:lostfound/services/auth/auth_service.dart';
import 'package:lostfound/services/chat/chat_service.dart';

class message extends StatelessWidget {
  message({super.key});
  //chat and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message"),
        centerTitle: true,
      ),
      body: _buildUserList(),
    );
  }

  // build a list of user for the current logged in users
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text("Error");
        }
        //loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }

        //return list
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  //build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
// display all users except current user
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}