import 'package:flutter/material.dart';

class Appbar extends StatelessWidget {
  const Appbar({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}
