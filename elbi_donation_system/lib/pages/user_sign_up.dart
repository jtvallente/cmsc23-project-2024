import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/components/FormTextField.dart';
import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/components/controllers.dart';
import 'package:elbi_donation_system/components/form_row_button.dart';
import 'package:elbi_donation_system/components/form_switch.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:elbi_donation_system/components/input_checker.dart';

class UserSignUpPage extends StatefulWidget {
  @override
  _UserSignUpPageState createState() => _UserSignUpPageState();
}

class _UserSignUpPageState extends State<UserSignUpPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _address1 = TextEditingController();
  final TextEditingController _address2 = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();

  final SwitchController _isOrganization = SwitchController();
  //Proof of legitimacy
  bool? isApproved;
  final TextEditingController _description = TextEditingController();
  final SwitchController _isOpenforDonations = SwitchController();

  final _formKey = GlobalKey<FormState>();

  resetValues() {
    setState(() {
      _name.clear();
      _username.clear();
      _password.clear();
      _address1.clear();
      _address2.clear();
      _contactNumber.clear();
      _isOrganization.setValue(false);
      _description.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => resetValues());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBanner(
          actions: [],
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
                              controller: _name,
                              inputType: TextInputType.name),
                          FormTextField(
                              isNum: false,
                              isPassword: false,
                              label: "Username",
                              controller: _username,
                              inputType: TextInputType.text),
                          FormTextField(
                              isNum: false,
                              isPassword: true,
                              label: "Password",
                              controller: _password,
                              inputType: TextInputType.text),
                          FormTextField(
                              isNum: false,
                              isPassword: false,
                              label: "Address 1",
                              controller: _address1,
                              inputType: TextInputType.text),
                          FormTextField(
                              isNum: false,
                              isPassword: false,
                              label: "Address 2",
                              controller: _address2,
                              inputType: TextInputType.text),
                          FormTextField(
                              isNum: true,
                              isPassword: false,
                              label: "Contact Number",
                              controller: _contactNumber,
                              inputType: TextInputType.phone),
                          FormSwitch(
                              label: "Are you an organization?",
                              controller: _isOrganization),
                          FormTextField(
                              isNum: false,
                              isPassword: false,
                              label: "Description",
                              controller: _description,
                              inputType: TextInputType.text),
                          FormRowButton(
                              icon: Icons.upload,
                              buttonLabel: "Upload File",
                              label: "Proof of Legitimacy",
                              onTap: () {}),
                          FormSwitch(
                              label: "Are you open for donations?",
                              controller: _isOpenforDonations),
                          // _isOrganization.isSwitchOn
                          //     ?
                          // Column(children: [
                          //   FormTextField(
                          //       isNum: false,
                          //       label: "Description",
                          //       controller: _description,
                          //       isPassword: false,
                          //       inputType: TextInputType.text),
                          //   FormFileUpload(onTap: () {})
                          // ])
                          // : Container()
                        ],
                      ),
                      const SizedBox(height: 50),
                      PrimaryButton(
                        label: "Sign-up",
                        gradient: ProjectColors().bluePrimaryGradient,
                        onTap: () {
                          // Validate the form
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushReplacementNamed(
                                context, '/donor_dashboard');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Please correct the errors in the form')),
                            );
                          }
                        },
                        fillWidth: true,
                      ),
                    ]),
              ),
            ),
          )),
    );
  }
}
