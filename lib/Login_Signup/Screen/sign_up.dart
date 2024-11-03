import 'package:flutter/material.dart';
import 'package:watchwiz/Login_Signup/Screen/home_screen.dart';
import 'package:watchwiz/Login_Signup/Screen/login.dart';
import 'package:watchwiz/Login_Signup/Services/authentication.dart';
import 'package:watchwiz/Login_Signup/Widget/button.dart';
import 'package:watchwiz/Login_Signup/Widget/snack_bar.dart';
import 'package:watchwiz/Login_Signup/Widget/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void signUpUser() async {
    String res = await AuthServices().signUpUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text);

    if (res == "sucess") {
      setState(() {
        isLoading = true;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
              child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height / 2.7,
                  child: Image.asset("/assets/images/Logo.png"),
                ),
                TextFieldInpute(
                  textEditingController: nameController,
                  hintText: "Ingresa tu nombre",
                  icon: Icons.person,
                ),
                TextFieldInpute(
                  textEditingController: emailController,
                  hintText: "Ingresa tu correo electrónico",
                  icon: Icons.email,
                ),
                TextFieldInpute(
                  textEditingController: passwordController,
                  hintText: "Ingresa tu contraseña",
                  isPass: true,
                  icon: Icons.lock,
                ),
                MyButton(onTab: signUpUser, text: "Registrate"),
                SizedBox(height: height / 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Ya tienes cuenta?",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Inicia Sesión ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
        ));
  }
}
