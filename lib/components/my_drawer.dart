import 'package:flutter/material.dart';
import 'package:lostfound/pages/message.dart';
import 'package:lostfound/pages/report_lost.dart';
import 'package:lostfound/services/auth/auth_service.dart';
import 'package:lostfound/pages/homePage.dart';
import 'package:lostfound/pages/settingpage.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout() {
    //get auth service
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            // logo
            DrawerHeader(
              child: Center(
                child: Icon(
                  Icons.message,
                  color: Theme.of(context).colorScheme.primary,
                  size: 50,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                title: const Text("HOME"),
                leading: const Icon(Icons.home),
                onTap: () {
                  //pop the drawer
                  Navigator.pop(context);
                  // navigate to Home page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                title: const Text("Message"),
                leading: const Icon(Icons.chat),
                onTap: () {
                  //pop the drawer
                  Navigator.pop(context);
                  // navigate to Home page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => message(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                title: Text("Report Lost"),
                leading: Icon(Icons.change_circle_outlined),
                onTap: () {
                  //pop the drawer
                  Navigator.pop(context);
                  // navigate to Home page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportLost(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                title: const Text("Settings"),
                leading: const Icon(Icons.settings),
                onTap: () {
                  //pop the drawer
                  Navigator.pop(context);
                  //navigate to settings page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingPage()));
                },
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25.0),
            child: ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: () => logout(),
            ),
          ),
        ],
      ),
    );
  }
}
