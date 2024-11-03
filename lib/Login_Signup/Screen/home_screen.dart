import 'package:flutter/material.dart';
import 'package:watchwiz/Login_Signup/Screen/login.dart';
import 'package:watchwiz/Login_Signup/Services/authentication.dart';
import 'package:watchwiz/Login_Signup/Widget/button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text(
        "Bienvenido a WatchWiz",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      MyButton(
          onTab: () async {
            await AuthServices().signOut();
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          text: "Cerrar Sesión")
    ])));
  }
}
