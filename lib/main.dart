import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:watchwiz/Login_Signup/Screen/home_screen.dart';
import 'package:watchwiz/Login_Signup/Screen/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBlrxxwn2VbO6K67Xx-pxIyvz8TpxziydQ",
          appId: "1:163947119435:android:cd8e141bb422fc31811ece",
          messagingSenderId: "163947119435",
          projectId: "watchwiz-721eb"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          }),
    );
  }
}
