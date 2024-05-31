import 'package:elbi_donation_system/components/MenuDropDown.dart';
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
import 'package:provider/provider.dart';
import 'package:elbi_donation_system/providers/FirebaseAuthUserProvider.dart';
import 'package:elbi_donation_system/models/donation.dart';
import 'package:elbi_donation_system/providers/FirebaseUserProvider.dart';
import 'package:intl/intl.dart';
import 'package:elbi_donation_system/components/error_modals.dart';

import 'dart:io';
import 'package:random_string/random_string.dart';

class MakeDonation extends StatefulWidget {
  @override
  _MakeDonationState createState() => _MakeDonationState();
}

class _MakeDonationState extends State<MakeDonation> {
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _address1 = TextEditingController();
  final TextEditingController _address2 = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();

  bool? isApproved;
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDateTime;
  String _deliveryMethod = "Pickup"; // Default to "Pickup"
  String _category = "";
  String? _orgId;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the contact number with the user's contact number from the auth provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider =
          Provider.of<FirebaseAuthUserProvider>(context, listen: false);
      _contactNumber.text = authProvider.currentUser?.contactNo ?? '';
    });
  }

  File? _selectedImage;
  String? _selectedImageName;

  Future<void> _openCamera() async {
    await requestPermissions(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final userProvider =
          Provider.of<FirebaseUserProvider>(context, listen: false);
      userProvider.addPickedFile(File(pickedFile.path));
    }
  }

  Future<void> _openGallery() async {
    await requestPermissions(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        final userProvider =
            Provider.of<FirebaseUserProvider>(context, listen: false);
        userProvider.addPickedFile(File(pickedFile.path));
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

    final RegExp weightRegex = RegExp(r'^\d*\.?\d+$');
    if (!weightRegex.hasMatch(value)) {
      return 'Please enter a valid weight in kilograms';
    }

    double? weight = double.tryParse(value);
    if (weight == null || weight <= 0) {
      return 'Weight must be a positive number';
    }

    return null;
  }

  String generateQRCodeData(String donationId) {
    return donationId;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address 1 cannot be empty';
    }
    return null;
  }

  Future<void> _submitDonation() async {
    if (_formKey.currentState!.validate()) {
      final authProvider =
          Provider.of<FirebaseAuthUserProvider>(context, listen: false);
      final userProvider =
          Provider.of<FirebaseUserProvider>(context, listen: false);
      final userDoc = await userProvider.getUserDocument(
          authProvider.currentUser!.userId); // Retrieve the user document

      if (_selectedDateTime == null) {
        CustomModal.showError(
          context: context,
          title: 'Error submitting',
          message: 'Date and Time of pick-up or delivery cannot be empty.',
        );
        return;
      }
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      // Get the document ID of the user
      final userId = userDoc.id;

      String id = randomAlpha(10);

      List<String> addresses = [_address1.text];
      if (_address2.text.isNotEmpty) {
        addresses.add(_address2.text);
      }

      Donation newDonation = Donation(
        donationId: id,
        donorId: userId,
        OrganizationId: _orgId!,
        category: _category,
        deliveryMethod: _deliveryMethod,
        isAddedToDrive: false,
        weight: double.parse(_weight.text),
        photos: userProvider.photos,
        dateTime: _selectedDateTime ?? DateTime.now(),
        addresses: _deliveryMethod == "Pickup" ? addresses : [],
        contactNumber: _contactNumber.text,
        status: "Pending",
        qrCode: "",
      );

      try {
        await userProvider.createDonation(newDonation);
      } catch (e) {
        CustomModal.showError(
          context: context,
          title: 'Submission Failed',
          message: 'Please try again.',
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }

      // Show the success dialog
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Donation Successful'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Thank you for your donation!'),
                // Display QR Code here
                // Example: Image.memory(base64Decode(newDonation.qrCode!)),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/donor_dashboard',
                    (Route<dynamic> route) => false,
                    arguments:
                        authProvider.currentUser, // Pass the argument here
                  );
                },
              ),
            ],
          );
        },
      );

      // Print the donation data to the console
      print("Donation ID: ${newDonation.donationId}");
      print("Donor ID: ${newDonation.donorId}");
      print("Category: ${newDonation.category}");
      print("Delivery Method: ${newDonation.deliveryMethod}");
      print("Weight: ${newDonation.weight}");
      print("Photos: ${newDonation.photos}");
      print("DateTime: ${newDonation.dateTime}");
      print("Address: ${newDonation.addresses}");
      print("Contact Number: ${newDonation.contactNumber}");
      print("Status: ${newDonation.status}");
      print("QR Code: ${newDonation.qrCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<FirebaseUserProvider>();
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final String organizationId = arguments['organizationId'];
    _orgId = organizationId;

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: MenuDropDown(
                              options: const ["Food","Clothes","Cash","Necesities", "Others" ], 
                              label: 'Category', 
                              onValueChanged: (value) {
                                setState(() {
                                  _deliveryMethod = value;
                                });
                              },
                            ) 
                          ),
                          FormSegmentedButton(
                            label: "Delivery Method",
                            options: ["Pickup", "Drop-off"],
                            onValueChanged: (value) {
                              setState(() {
                                _deliveryMethod = value;
                              });
                            },
                          ),
                        ],
                      ),
                      FormTextField(
                        isNum: true,
                        isPassword: false,
                        label: "Weight (kg)",
                        controller: _weight,
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
                      if (userProvider.selectedFiles.isNotEmpty)
                        Column(
                            children: userProvider.selectedFiles.map((file) {
                          int index = userProvider.selectedFiles.indexOf(file);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(file.path.split('/').last)),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  try {
                                    setState(() {
                                      userProvider.removeFilePhoto(index);
                                    });
                                  } catch (e) {
                                    print('Error removing file: $e');
                                  }
                                },
                              ),
                            ],
                          );
                        }).toList()),
                      if (_deliveryMethod == "Pickup")
                        Column(
                          children: [
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
                              label: "Address 2 (Optional)",
                              controller: _address2,
                              inputType: TextInputType.text,
                            ),
                          ],
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: FormRowButton(
                              label: "Pickup / Dropoff date",
                              onTap: _pickDateTime,
                              buttonLabel: "Open Calendar",
                              icon: Icons.calendar_month,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        _selectedDateTime != null
                            ? "Selected Date & Time: ${DateFormat.yMMMMd().add_jm().format(_selectedDateTime!.toLocal())}"
                            : "No date selected",
                      ),
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
                  _isLoading
                      ? PrimaryButton(
                          label: "Submitting Donation...",
                          gradient: ProjectColors().greenPrimaryGradient,
                          onTap: null,
                          fillWidth: true,
                        )
                      : PrimaryButton(
                          label: "Make Donation",
                          gradient: ProjectColors().greenPrimaryGradient,
                          onTap: _submitDonation,
                          fillWidth: true,
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
