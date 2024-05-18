// lib/pages/Donor/MakeDonation.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/components/FormTextField.dart';
import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/components/controllers.dart';
import 'package:elbi_donation_system/components/form_row_button.dart';
import 'package:elbi_donation_system/components/form_segmented_button.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:elbi_donation_system/permission_handler.dart';
import 'dart:io';

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
  bool? isApproved;
  final TextEditingController _description = TextEditingController();
  final SwitchController _isOpenforDonations = SwitchController();
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  String? _selectedImageName;
  DateTime? _selectedDateTime;

  Future<void> _openCamera() async {
    await requestPermissions(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _selectedImageName = pickedFile.name;
      });
    }
  }

  Future<void> _openGallery() async {
    await requestPermissions(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _selectedImageName = pickedFile.name;
      });
    }
  }

  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(pickedDate.year, pickedDate.month,
              pickedDate.day, pickedTime.hour, pickedTime.minute);
        });
      }
    }
  }

  String? _validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the weight';
    }

    // Regular expression for validating a positive decimal number
    final RegExp weightRegex = RegExp(r'^\d*\.?\d+$');
    if (!weightRegex.hasMatch(value)) {
      return 'Please enter a valid weight in kilograms';
    }

    // Additional validation if needed (e.g., maximum weight allowed)
    double? weight = double.tryParse(value);
    if (weight == null || weight <= 0) {
      return 'Weight must be a positive number';
    }

    return null;
  }

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
                      //Please change this to dropdown
                      FormTextField(
                        isNum: false,
                        isPassword: false,
                        label: "Category",
                        controller: _category,
                        inputType: TextInputType.name,
                      ),
                      FormSegmentedButton(
                        label: "Delivery Method",
                        options: ["Pickup", "Drop-off"],
                      ),
                      FormTextField(
                        isNum: true,
                        isPassword: false,
                        label: "Weight",
                        controller: _username,
                        inputType: TextInputType.number,
                        validator: _validateWeight,
                      ),
                      FormRowButton(
                        label: "Add Photo",
                        onTap: _openCamera,
                        buttonLabel: "Open Camera",
                        icon: Icons.camera_alt_rounded,
                      ),
                      FormRowButton(
                        label: "Choose from Gallery",
                        onTap: _openGallery,
                        buttonLabel: "Open Gallery",
                        icon: Icons.photo_library,
                      ),
                      if (_selectedImageName != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Selected Image: $_selectedImageName'),
                        ),
                      FormTextField(
                        isNum: false,
                        isPassword: false,
                        label: "Address",
                        controller: _address,
                        inputType: TextInputType.text,
                      ),
                      FormRowButton(
                        label: "Choose date and time",
                        onTap: _pickDateTime,
                        buttonLabel: "Open Calendar",
                        icon: Icons.calendar_month,
                      ),
                      if (_selectedDateTime != null)
                        Text(
                            "Selected DateTime: ${_selectedDateTime!.toLocal()}"),

                      // i think we can remove this since the contact number is already defined in the user model
                      FormTextField(
                        isNum: false,
                        isPassword: false,
                        label: "Contact Number",
                        controller: _contactNumber,
                        inputType: TextInputType.phone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  PrimaryButton(
                    label: "Make Donation",
                    gradient: ProjectColors().greenPrimaryGradient,
                    onTap: () {},
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
