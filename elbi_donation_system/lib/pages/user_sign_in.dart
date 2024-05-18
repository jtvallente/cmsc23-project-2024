import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/components/FormTextField.dart';
import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elbi_donation_system/providers/FirebaseAuthUserProvider.dart';

class UserSignInPage extends StatefulWidget {
  @override
  _UserSignInPageState createState() => _UserSignInPageState();
}

class _UserSignInPageState extends State<UserSignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBanner(
        isRoot: true,
        actions: [],
        gradient: ProjectColors().greenPrimaryGradient,
        color: ProjectColors().greenPrimary,
        title: "Sign-in",
        subtitle: "User",
        widget: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  270 -
                  (MediaQuery.of(context).viewInsets.bottom == 0
                      ? 0
                      : MediaQuery.of(context).viewInsets.bottom -
                          MediaQuery.of(context).size.height / 3.5),
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
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/user_signup'),
                          child: Text(
                            style:
                                TextStyle(color: ProjectColors().greenPrimary),
                            "No account yet? Sign-up here.",
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/admin_signin'),
                          child: Text(
                            style:
                                TextStyle(color: ProjectColors().greenPrimary),
                            "Or if you're an admin, Sign-in here.",
                          ),
                        ),
                        const SizedBox(height: 10),
                        PrimaryButton(
                          label: "Sign-in",
                          gradient: ProjectColors().greenPrimaryGradient,
                          onTap: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              String email = _emailController.text;
                              String password = _passwordController.text;

                              try {
                                bool success = await context
                                    .read<FirebaseAuthUserProvider>()
                                    .login(email, password);

                                if (success) {
                                  Navigator.pushReplacementNamed(
                                      context, '/donor_dashboard');
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
