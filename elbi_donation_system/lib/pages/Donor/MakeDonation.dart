import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/components/FormTextField.dart';
import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/components/controllers.dart';
import 'package:elbi_donation_system/components/form_row_button.dart';
import 'package:elbi_donation_system/components/form_segmented_button.dart';
import 'package:elbi_donation_system/components/form_switch.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';

class MakeDonation extends StatefulWidget {
  @override
  _MakeDonationState createState() => _MakeDonationState();
}

class _MakeDonationState extends State<MakeDonation> {
  final TextEditingController _category = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();

  final SwitchController _isOrganization = SwitchController();
  //Proof of legitimacy
  bool? isApproved;
  final TextEditingController _description = TextEditingController();
  final SwitchController _isOpenforDonations = SwitchController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBanner(
          actions: [],
          gradient: ProjectColors().greenPrimaryGradient,
          color: ProjectColors().greenPrimary,
          title: "Donation",
          subtitle: "Make A",
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
                              label: "Category",
                              controller: _category,
                              inputType: TextInputType.name),
                          FormSegmentedButton(
                              label: "Delivery Method",
                              options: ["Pickup", "Drop-off"]),
                          FormTextField(
                              isNum: true,
                              isPassword: false,
                              label: "Weight",
                              controller: _username,
                              inputType: TextInputType.number),
                          FormRowButton(
                            label: "Add Photo`",
                            onTap: () {},
                            buttonLabel: "Open Camera",
                            icon: Icons.camera_alt_rounded,
                          ),
                          FormTextField(
                              isNum: false,
                              isPassword: false,
                              label: "Address",
                              controller: _address,
                              inputType: TextInputType.text),
                          FormRowButton(
                            label: "Choose date and time`",
                            onTap: () {},
                            buttonLabel: "Open Calendar",
                            icon: Icons.calendar_month,
                          ),
                          FormTextField(
                              isNum: false,
                              isPassword: false,
                              label: "Contact Number",
                              controller: _contactNumber,
                              inputType: TextInputType.phone),
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
                        label: "Make Donation",
                        gradient: ProjectColors().greenPrimaryGradient,
                        onTap: () {},
                        fillWidth: true,
                      )
                    ]),
              ),
            ),
          )),
    );
  }
}
