import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/components/FormTextField.dart';
import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elbi_donation_system/providers/FirebaseAuthAdminProvider.dart';

class AdminSignInPage extends StatefulWidget {
  @override
  _AdminSignInPageState createState() => _AdminSignInPageState();
}

class _AdminSignInPageState extends State<AdminSignInPage> {
  final TextEditingController _emailController = TextEditingController();
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
                          label: "Email",
                          controller: _emailController,
                          inputType: TextInputType.emailAddress,
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
                          gradient: ProjectColors().greenPrimaryGradient,
                          onTap: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              String email = _emailController.text;
                              String password = _passwordController.text;

                              try {
                                bool success = await context
                                    .read<FirebaseAuthAdminProvider>()
                                    .login(email, password);

                                if (success) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/admin_dashboard',
                                    arguments: context
                                        .read<FirebaseAuthAdminProvider>()
                                        .currentAdmin,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Sign-in failed. Please check your credentials.'),
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Sign-in failed. Please check your credentials.'),
                                  ),
                                );
                              }
                            }
                          },
                          fillWidth: true,
                        )
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
