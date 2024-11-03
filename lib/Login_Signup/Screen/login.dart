import 'package:flutter/material.dart';
import 'package:watchwiz/Login_Signup/Screen/home_screen.dart';
import 'package:watchwiz/Login_Signup/Screen/sign_up.dart';
import 'package:watchwiz/Login_Signup/Services/authentication.dart';
import 'package:watchwiz/Login_Signup/Widget/button.dart';
import 'package:watchwiz/Login_Signup/Widget/snack_bar.dart';
import 'package:watchwiz/Login_Signup/Widget/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUsers() async {
    String res = await AuthServices().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: height / 2.7,
                child: Image.asset("/assets/images/Logo copy.png"),
              ),
              TextFieldInpute(
                textEditingController: emailController,
                hintText: "Ingresa tu correo electrónico",
                icon: Icons.email,
              ),
              TextFieldInpute(
                isPass: true,
                textEditingController: passwordController,
                hintText: "Ingresa tu contraseña",
                icon: Icons.lock,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Olvidaste tu contraseña?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              MyButton(onTab: loginUsers, text: "Inicia Sesión"),
              SizedBox(height: height / 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No tienes cuenta?",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Registrate",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
