import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/components/FormTextField.dart';
import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/components/controllers.dart';
import 'package:elbi_donation_system/components/form_row_button.dart';
import 'package:elbi_donation_system/components/form_switch.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:elbi_donation_system/components/error_modals.dart';
import 'package:elbi_donation_system/providers/FirebaseUserProvider.dart';
import 'package:elbi_donation_system/providers/FirebaseAuthUserProvider.dart';
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
  final TextEditingController _description = TextEditingController();
  final TextEditingController _email = TextEditingController();

  final SwitchController _isOrganization = SwitchController();
  final SwitchController _isOpenforDonations = SwitchController();

  final _formKey = GlobalKey<FormState>();

  void resetValues() {
    setState(() {
      _name.clear();
      _email.clear();
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
    final userProvider = context.watch<FirebaseUserProvider>();
    final userAuth = context.watch<FirebaseAuthUserProvider>();

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
                        validator: validateName,
                      ),
                      FormTextField(
                        isNum: false,
                        isPassword: false,
                        label: "E-mail",
                        controller: _email,
                        inputType: TextInputType.emailAddress,
                        validator: validateEmail,
                      ),
                      FormTextField(
                        isNum: false,
                        isPassword: false,
                        label: "Username",
                        controller: _username,
                        inputType: TextInputType.text,
                        validator: validateUsername,
                      ),
                      FormTextField(
                        isNum: false,
                        isPassword: true,
                        label: "Password",
                        controller: _password,
                        inputType: TextInputType.text,
                        validator: validatePassword,
                      ),
                      FormTextField(
                        isNum: false,
                        isPassword: false,
                        label: "Address 1 (Home Address)",
                        controller: _address1,
                        inputType: TextInputType.text,
                        validator: validateAddress,
                      ),
                      FormTextField(
                        isNum: false,
                        isPassword: false,
                        label: "Address 2 (Work Address)",
                        controller: _address2,
                        inputType: TextInputType.text,
                        validator: validateAddress,
                      ),
                      FormTextField(
                        isNum: true,
                        isPassword: false,
                        label: "Contact Number",
                        controller: _contactNumber,
                        inputType: TextInputType.phone,
                        validator: validateContactNumber,
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
                          label: "Description / Bio",
                          controller: _description,
                          inputType: TextInputType.text,
                        ),
                        FormRowButton(
                          icon: Icons.upload,
                          buttonLabel: "Upload File",
                          label: "Proof of Legitimacy",
                          onTap: () async {
                            await userProvider.pickFile();
                          },
                        ),
                        if (userProvider.selectedFiles.isNotEmpty)
                          Column(
                            children: userProvider.selectedFiles.map((file) {
                              int index =
                                  userProvider.selectedFiles.indexOf(file);
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(file.path.split('/').last)),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      userProvider.removeFilePhoto(index);
                                    },
                                  ),
                                ],
                              );
                            }).toList(),
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
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        //change the random alpha to be the document id of the user!
                        //String id = randomAlpha(10);
                        User userData = User(
                          userId: '',
                          name: _name.text,
                          email: _email.text,
                          username: _username.text,
                          password: _password.text,
                          addresses: [_address1.text, _address2.text],
                          contactNo: _contactNumber.text,
                          description: _description.text,
                          isOrganization: _isOrganization.isSwitchOn,
                          openForDonations: _isOpenforDonations.isSwitchOn,
                          isApproved: false,
                          proofOfLegitimacyBase64:
                              userProvider.proofOfLegitimacyBase64,
                        );
                        //For debugging purposes
                        print('User ID: ${userData.userId}');
                        print('Email: ${userData.email}');
                        print('Name: ${userData.name}');
                        print('Username: ${userData.username}');
                        print('Password: ${userData.password}');
                        print('Addresses: ${userData.addresses}');
                        print('Contact Number: ${userData.contactNo}');
                        print('Description: ${userData.description}');
                        print('Is Organization: ${userData.isOrganization}');
                        print(
                            'Open for Donations: ${userData.openForDonations}');
                        print('Is Approved: ${userData.isApproved}');
                        print(
                            'Proof of Legitimacy (Base64): ${userData.proofOfLegitimacyBase64}');
                        //call the provider for saving the user data
                        String email = _email.text;
                        String password = _password.text;
                        try {
                          await userAuth.register(email, password, userData);

                          Navigator.pushReplacementNamed(
                              context, '/user_signin');
                        } catch (error) {
                          CustomModal.showError(
                            context: context,
                            title: 'Sign-up Failed',
                            message:
                                'Error Signing-up. Please check your internet connection.',
                          );
                        }
                      } else {
                        CustomModal.showError(
                          context: context,
                          title: 'Sign-up Failed',
                          message:
                              'Please corrects the errors in the form field',
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
