import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/components/FormTextField.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBanner(
          title: "Sign-in",
          subtitle: "User",
          widget: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SizedBox(
              height: 1500,
              child: Column(children: [
                FormTextField(
                    isNum: false,
                    isPassword: false,
                    label: "Username",
                    controller: _emailController,
                    inputType: TextInputType.emailAddress),
                FormTextField(
                    isNum: false,
                    isPassword: true,
                    label: "Password",
                    controller: _passwordController,
                    inputType: TextInputType.text)
              ]),
            ),
          ))),
    );
  }
}
