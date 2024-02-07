import 'package:chat2/components/auth_form.dart';
import 'package:chat2/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoading = false;

  void handdleSubmit(AuthFormData formData) {
    // setState(() {isLoading = true;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          Center(child: AuthForm(onSubmit: handdleSubmit,)),
          if(isLoading)
          Container(
            color: const Color.fromARGB(78, 0, 0, 0),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        ],
      )
    );
  }
}