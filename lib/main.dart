import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lostfound/firebase_options.dart';
import 'package:lostfound/services/auth/auth_gate.dart';
import 'package:lostfound/theme/theme_provide.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themedata,
    );
  }
}