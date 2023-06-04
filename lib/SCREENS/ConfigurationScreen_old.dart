import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigurationScreen extends StatefulWidget {
  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  TextEditingController _qrCodeController = TextEditingController();

  void _updateConfiguration() async {
    String qrCode = _qrCodeController.text.trim();

    if (qrCode.length == 10) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? oldQrCodeTopic = prefs.getString('qrCodeTopic');

      if (oldQrCodeTopic != null) {
        await FirebaseMessaging.instance.unsubscribeFromTopic(oldQrCodeTopic);
      }

      await FirebaseMessaging.instance.subscribeToTopic(qrCode);
      prefs.setString('qrCodeTopic', qrCode);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Configuration updated successfully'),
        ),
      );

      Navigator.of(context).pop(); // Close the pop-up

    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid QR-Code'),
            content: Text('Please enter a valid QR-Code with 10 characters.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the alert dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _qrCodeController,
              decoration: InputDecoration(
                labelText: 'Enter QR-CODE',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateConfiguration,
              child: Text('Update Configuration'),
            ),
          ],
        ),
      ),
    );
  }
}
