import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/user.dart';
import '../pages/homepage.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: "email"),
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: validateEmail,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: "password"),
                controller: _passwordController,
                validator: validatePassword,
                obscureText: true,
              ),
            ),
            ElevatedButton(onPressed: auth, child: Text("Autenticate"))
          ],
        ));
  }

  void auth() async {
    final client = PocketBase("http://pelerin-solutions.ru:10011");
    try {
      UserAuth response = await client.users
          .authViaEmail(_emailController.text, _passwordController.text);
      await User.set(
          newEmail: _emailController.text,
          newPassword: _passwordController.text,
          id: response.user!.id,
          token: response.token);
      if (formKey.currentState!.validate())
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("wrong user data")));
      log("🍑", error: e);
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "cannot be empty";
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "cannot be empty";
    if (!value.contains("@")) return "not an email";
  }
}
