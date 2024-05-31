import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/components/FormTextField.dart';
import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elbi_donation_system/components/error_modals.dart';
import 'package:elbi_donation_system/components/input_checker.dart';
import 'package:elbi_donation_system/providers/FirebaseAuthAdminProvider.dart';

class AdminSignInPage extends StatefulWidget {
  @override
  _AdminSignInPageState createState() => _AdminSignInPageState();
}

class _AdminSignInPageState extends State<AdminSignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBanner(
        actions: [],
        gradient: ProjectColors().purplePrimaryGradient,
        color: ProjectColors().purplePrimary,
        title: "Sign-in",
        subtitle: "Admin",
        widget: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  270 -
                  (MediaQuery.of(context).viewInsets.bottom == 0
                      ? 0
                      : MediaQuery.of(context).viewInsets.bottom -
                          MediaQuery.of(context).size.height / 4),
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
                          label: "Email or Username",
                          controller: _usernameController,
                          inputType: TextInputType.text,
                        ),
                        FormTextField(
                          isNum: false,
                          isPassword: true,
                          label: "Password",
                          controller: _passwordController,
                          inputType: TextInputType.text,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryButton(
                          label: "Sign-in",
                          gradient: ProjectColors().purplePrimaryGradient,
                          onTap: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              String username = _usernameController.text;
                              String password = _passwordController.text;

                              try {
                                bool success = await context
                                    .read<FirebaseAuthAdminProvider>()
                                    .login(username, password);

                                if (success) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/admin_dashboard',
                                    arguments: context
                                        .read<FirebaseAuthAdminProvider>()
                                        .currentAdmin,
                                  );
                                } else {
                                  CustomModal.showError(
                                    context: context,
                                    title: 'Sign-in Failed',
                                    message:
                                        'Please check your credentials or try Google Sign-in instead.',
                                  );
                                }
                              } catch (e) {
                                CustomModal.showError(
                                  context: context,
                                  title: 'Sign-in Failed',
                                  message:
                                      'Please check your credentials or try Google Sign-in instead.',
                                );
                              }
                            }
                          },
                          fillWidth: true,
                        ),
                        SizedBox(height: 16.0),
                        PrimaryButton(
                          label: "Continue with Google",
                          gradient: ProjectColors().purplePrimaryGradient,
                          onTap: () async {
                            try {
                              bool success = await context
                                  .read<FirebaseAuthAdminProvider>()
                                  .signInWithGoogle();

                              if (success) {
                                Navigator.pushReplacementNamed(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  '/admin_dashboard',
                                  arguments: context
                                      .read<FirebaseAuthAdminProvider>()
                                      .currentAdmin,
                                );
                              } else {
                                CustomModal.showError(
                                  context: context,
                                  title: 'Sign-in Failed',
                                  message:
                                      'Sign-in with Google failed. Please try again.',
                                );
                              }
                            } catch (e) {
                              CustomModal.showError(
                                context: context,
                                title: 'Sign-in Failed',
                                message:
                                    'Sign-in with Google failed. Please try again.',
                              );
                            }
                          },
                          fillWidth: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
