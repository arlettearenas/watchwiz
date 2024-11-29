import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:watchwiz/Screen/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBlrxxwn2VbO6K67Xx-pxIyvz8TpxziydQ",
          appId: "1:163947119435:android:cd8e141bb422fc31811ece",
          messagingSenderId: "163947119435",
          storageBucket: "watchwiz-721eb.appspot.com",
          projectId: "watchwiz-721eb"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}
