import 'package:flutter/material.dart';

class RecoverPasswordScreen extends StatelessWidget {
  static String routeName = "/recover_password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: const Center(child: Text("recover"),),
    );
  }
}