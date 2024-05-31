import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:elbi_donation_system/models/donation.dart'; // Import the Donation model
import 'dart:convert'; // Import to decode base64 images
import 'package:qr_flutter/qr_flutter.dart'; // Import the QR Flutter package
import 'package:provider/provider.dart'; // Import provider
import 'package:elbi_donation_system/providers/FirebaseUserProvider.dart'; // Import the provider

class DonorDonationDetails extends StatefulWidget {
  @override
  _DonorDonationDetailsState createState() => _DonorDonationDetailsState();
}

class _DonorDonationDetailsState extends State<DonorDonationDetails> {
  @override
  Widget build(BuildContext context) {
    final Donation donation =
        ModalRoute.of(context)!.settings.arguments as Donation;

    if (donation.qrCode == "" && donation.deliveryMethod == "Drop-off") {
      _generateAndSaveQRCode(donation);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              'Donation ID: ${donation.donationId}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Donor ID: ${donation.donorId}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Organization ID: ${donation.OrganizationId}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Category: ${donation.category}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Delivery Method: ${donation.deliveryMethod}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Weight: ${donation.weight} kg',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Contact Number: ${donation.contactNumber}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${donation.status}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${donation.dateTime.toLocal()}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            if (donation.addresses != null &&
                donation.addresses!.isNotEmpty) ...[
              Text(
                'Addresses:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...donation.addresses!.map((address) => Text('- $address')),
            ],
            SizedBox(height: 8),
            if (donation.photos != null && donation.photos!.isNotEmpty) ...[
              Text(
                'Photos:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: donation.photos!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.memory(
                        base64Decode(donation.photos![index]),
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: 8),
            if (donation.qrCode != "" &&
                donation.deliveryMethod == "Drop-off") ...[
              Text(
                'QR Code:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Image.memory(
                base64Decode(donation.qrCode!),
                height: 500,
                width: 200,
                fit: BoxFit.cover,
              ),
            ],
            SizedBox(height: 16),
            if (donation.status == "Pending") ...[
              ElevatedButton(
                onPressed: () => _cancelDonation(donation),
                child: Text('Cancel Donation'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _generateAndSaveQRCode(Donation donation) async {
    final qrValidationResult = QrValidator.validate(
      data: donation.donationId,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final qrCode = qrValidationResult.qrCode;
      final painter = QrPainter.withQr(
        qr: qrCode!,
        color: Color(0xFF000000),
        emptyColor: Color(0xFFFFFFFF),
        gapless: true,
      );

      final picData = await painter.toImageData(200);
      if (picData != null) {
        final imgBytes = picData.buffer.asUint8List();
        final base64Image = base64Encode(imgBytes);
        setState(() {
          donation.qrCode = base64Image;
        });
        // Save the updated donation with the QR code to your backend or database
        final provider =
            Provider.of<FirebaseUserProvider>(context, listen: false);
        await provider.updateDonation(donation);
      }
    }
  }

  void _cancelDonation(Donation donation) {
    setState(() {
      donation.status = "Cancelled";
    });
    final provider = Provider.of<FirebaseUserProvider>(context, listen: false);
    provider.updateDonation(donation);
  }
}
