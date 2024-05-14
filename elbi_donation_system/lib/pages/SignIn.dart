import 'package:elbi_donation_system/components/FormBanner.dart';
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
      body: FormBanner(title: "Sign-in", subtitle: "USER", widget: Container(height: 400)),
    );
  }
}
