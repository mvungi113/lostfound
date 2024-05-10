import 'package:flutter/material.dart';
import 'package:lostfound/components/my_button.dart';
import 'package:lostfound/components/my_textfield.dart';
import 'package:lostfound/services/auth/auth_service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key, required this.onTap});

  final void Function()? onTap;
  // email controller
  final TextEditingController _emailController = TextEditingController();

  // password controller
  final TextEditingController _passwordController = TextEditingController();
  void login(BuildContext context) async {
//auth service
    final authService = AuthService();
//try login
    try {
      await authService.signInWithEmailPassword(
          _emailController.text, _passwordController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),

                // logo
                Image.asset('assets/images/logo.png'),
                const SizedBox(
                  height: 50,
                ),
                // welcome back message
                Text(
                  "Welcome back, you've been missed!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),

                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emailController,
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: _passwordController,
                ),
                const SizedBox(
                  height: 20,
                ),
                MyButton(
                  text: "Login",
                  onTap: () => login(context),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Not a member ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        'Register Now',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
