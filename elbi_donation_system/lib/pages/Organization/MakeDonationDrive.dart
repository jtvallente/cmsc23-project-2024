import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elbi_donation_system/components/FormBanner.dart';
import 'package:elbi_donation_system/components/FormTextField.dart';
import 'package:elbi_donation_system/components/PrimaryButton.dart';
import 'package:elbi_donation_system/components/form_row_button.dart';
import 'package:elbi_donation_system/components/form_segmented_button.dart';
import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:elbi_donation_system/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:elbi_donation_system/providers/FirebaseAuthUserProvider.dart';
import 'package:elbi_donation_system/models/donation.dart';
import 'package:elbi_donation_system/models/donationdrive.dart';
import 'package:elbi_donation_system/models/users.dart';
import 'package:elbi_donation_system/providers/FirebaseUserProvider.dart';
import 'dart:io';
import 'package:random_string/random_string.dart';

class MakeDonationDrive extends StatefulWidget {
  @override
  _MakeDonationDriveState createState() => _MakeDonationDriveState();
}

class _MakeDonationDriveState extends State<MakeDonationDrive> {
  final TextEditingController _description = TextEditingController();
  final TextEditingController _name = TextEditingController();

  bool? isApproved;
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDateTime;
  String _driveStatus = "Ongoing"; // Default to "Ongoing"

  String? _orgId;

  @override
  void initState() {
    super.initState();
    // Initialize the contact number with the user's contact number from the auth provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider =
          Provider.of<FirebaseAuthUserProvider>(context, listen: false);
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

  String? _validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field can\'t be empty';
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

      // Get the document ID of the user
      final userId = userDoc.id;

      String id = randomAlpha(10);

      DonationDrive newDonationDrive = DonationDrive(
        donationDriveId: id,
        name: _name.text,
        organizationId: _orgId!,
        description: _description.text,
        photos: userProvider.photos,
        dateTime: _selectedDateTime ?? DateTime.now(),
        donations: [],
        status: "Ongoing",
      );

      // Show the success dialog
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Donation Drive Creation Successful'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Thank you!'),
                // Display QR Code here
                // Example: Image.memory(base64Decode(newDonation.qrCode!)),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      // Call the provider's createDonation method
      await userProvider.createDonationDrive(newDonationDrive);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<FirebaseUserProvider>();
    final User user = ModalRoute.of(context)!.settings.arguments as User;
    final String organizationId = user.userId;
    _orgId = organizationId;

    return Scaffold(
      body: FormBanner(
        actions: [],
        gradient: ProjectColors().greenPrimaryGradient,
        color: ProjectColors().greenPrimary,
        title: "Donation Drive",
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
                        label: "Name",
                        controller: _name,
                        inputType: TextInputType.name,
                        validator: _validateText,
                      ),
                      FormTextField(
                        isNum: false,
                        isPassword: false,
                        label: "Description / Bio",
                        controller: _description,
                        inputType: TextInputType.text,
                        validator: _validateText,
                      ),
                      FormSegmentedButton(
                        label: "Status",
                        options: ["Ongoing", "Completed"],
                        onValueChanged: (value) {
                          setState(() {
                            _driveStatus = value;
                          });
                        },
                      ),
                      FormRowButton(
                        label: "Add photos",
                        onTap: _openGallery,
                        buttonLabel: "Open Gallery",
                        icon: Icons.photo_library,
                      ),
                      //need to empty the selected files first
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

                      FormRowButton(
                        label: "Prospected Date and Time",
                        onTap: _pickDateTime,
                        buttonLabel: "Open Calendar",
                        icon: Icons.calendar_month,
                      ),
                      if (_selectedDateTime != null)
                        Text(
                            "Selected DateTime: ${_selectedDateTime!.toLocal()}"),
                    ],
                  ),
                  const SizedBox(height: 50),
                  PrimaryButton(
                    label: "Make Donation Drive",
                    gradient: ProjectColors().greenPrimaryGradient,
                    onTap: _submitDonation,
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
