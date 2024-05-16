import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/components/FormTextField.dart';
import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/components/controllers.dart';
import 'package:elbi_donation_system/components/form_row_button.dart';
import 'package:elbi_donation_system/components/form_switch.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
  final TextEditingController _description = TextEditingController();

  final SwitchController _isOrganization = SwitchController();
  final SwitchController _isOpenforDonations = SwitchController();

  final _formKey = GlobalKey<FormState>();

  void resetValues() {
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an address';
    }
    return null;
  }

  String? _validateContactNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a contact number';
    } else if (num.tryParse(value) == null) {
      return 'Contact number should be a number';
    }
    return null;
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
                        inputType: TextInputType.name,
                        validator: _validateName,
                      ),
                      FormTextField(
                        isNum: false,
                        isPassword: false,
                        label: "Username",
                        controller: _username,
                        inputType: TextInputType.text,
                        validator: _validateUsername,
                      ),
                      FormTextField(
                        isNum: false,
                        isPassword: true,
                        label: "Password",
                        controller: _password,
                        inputType: TextInputType.text,
                        validator: _validatePassword,
                      ),
                      FormTextField(
                        isNum: false,
                        isPassword: false,
                        label: "Address 1",
                        controller: _address1,
                        inputType: TextInputType.text,
                        validator: _validateAddress,
                      ),
                      FormTextField(
                        isNum: false,
                        isPassword: false,
                        label: "Address 2",
                        controller: _address2,
                        inputType: TextInputType.text,
                        validator: _validateAddress,
                      ),
                      FormTextField(
                        isNum: true,
                        isPassword: false,
                        label: "Contact Number",
                        controller: _contactNumber,
                        inputType: TextInputType.phone,
                        validator: _validateContactNumber,
                      ),
                      FormSwitch(
                        label: "Are you an organization?",
                        controller: _isOrganization,
                        onChanged: (bool value) {
                          setState(() {
                            _isOrganization.setValue(value);
                          });
                        },
                      ),
                      if (_isOrganization.isSwitchOn) ...[
                        FormTextField(
                          isNum: false,
                          isPassword: false,
                          label: "Description",
                          controller: _description,
                          inputType: TextInputType.text,
                        ),
                        FormRowButton(
                          icon: Icons.upload,
                          buttonLabel: "Upload File",
                          label: "Proof of Legitimacy",
                          onTap: () {},
                        ),
                        FormSwitch(
                          label: "Are you open for donations?",
                          controller: _isOpenforDonations,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 50),
                  PrimaryButton(
                    label: "Sign-up",
                    gradient: ProjectColors().bluePrimaryGradient,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        //call the provider for saving the user data
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
