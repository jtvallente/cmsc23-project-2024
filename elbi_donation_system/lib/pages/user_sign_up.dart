import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/components/FormTextField.dart';
import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';

class UserSignUpPage extends StatefulWidget {
  @override
  _UserSignUpPageState createState() => _UserSignUpPageState();
}

class _UserSignUpPageState extends State<UserSignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  bool? isOrganization;
  //Proof of legitimacy
  bool? isApproved;
  final TextEditingController _descriptionController = TextEditingController();
  bool? isOpenForDonations;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBanner(
          gradient: ProjectColors().bluePrimaryGradient,
          color: ProjectColors().bluePrimary,
          title: "Sign-up",
          subtitle: "User",
          widget: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          FormTextField(
                              isNum: false,
                              isPassword: false,
                              label: "Name",
                              controller: _usernameController,
                              inputType: TextInputType.name),
                          FormTextField(
                              isNum: false,
                              isPassword: false,
                              label: "Username",
                              controller: _usernameController,
                              inputType: TextInputType.text),
                          FormTextField(
                              isNum: false,
                              isPassword: true,
                              label: "Password",
                              controller: _passwordController,
                              inputType: TextInputType.text),
                          FormTextField(
                              isNum: false,
                              isPassword: false,
                              label: "Contact Number",
                              controller: _usernameController,
                              inputType: TextInputType.phone),
                        ],
                      ),
                      const SizedBox(height: 50),
                      PrimaryButton(
                          label: "Sign-up",
                          gradient: ProjectColors().bluePrimaryGradient,
                          onTap: () {})
                    ]),
              ),
            ),
          )),
    );
  }
}
