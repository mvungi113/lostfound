import 'package:flutter/material.dart';
import 'package:lostfound/theme/theme_provide.dart';
import 'package:provider/provider.dart';

class chat_bubble extends StatelessWidget {
  const chat_bubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });
  final String message;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    //light vs dark mode for correct bubble colrs
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? (isDarkMode
                ? const Color.fromRGBO(200, 230, 201, 1)
                : Colors.green[300])
            : (isDarkMode ? Colors.blue[200] : Colors.blue[300]),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Text(
        message,
        style: TextStyle(
          color: isDarkMode ? Colors.grey.shade800 : Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}
