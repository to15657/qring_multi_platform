import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HTTP/HTTPCustomClient.dart';
import '../MODELS/CustomerModel.dart';

class ConfigurationScreen extends StatefulWidget {
  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  TextEditingController _custoIdController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _welcomeMessageController = TextEditingController();

  void _updateConfiguration() async {
    String custoId = _custoIdController.text.trim();
    String name = _nameController.text.trim();
    String welcomeMessage = _welcomeMessageController.text.trim();

    if (custoId.length == 10 && name.isNotEmpty && welcomeMessage.isNotEmpty) {

      // All OK
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? oldQrCodeTopic = prefs.getString('custoId');

      if (oldQrCodeTopic != null) {
        await FirebaseMessaging.instance.unsubscribeFromTopic(oldQrCodeTopic);
      }

      await FirebaseMessaging.instance.subscribeToTopic(custoId);
      prefs.setString('custoId', custoId);

      String tagId = await getTagIdFromCustoId(custoId);

      CustomerModel customer = CustomerModel(
        name: name,
        welcomeMessage: welcomeMessage,
        custoId: custoId,
        tagId: tagId,
      );
      String customerJson = customer.toJsonString();
      prefs.setString('customer', customerJson);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Configuration updated successfully'),
        ),
      );

      Navigator.of(context).pop(); // Close the pop-up

    } else {

      String alertString = "";
      if (welcomeMessage.isEmpty) { alertString = "Le message d'accueil ne doit pas etre vide";}
      if (name.isEmpty) { alertString = "Le nom ne doit pas etre vide";}
      if (custoId.length != 10) { alertString = "Le code secret doit contenir 10 lettres!";}

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('La saisie est invalide'),
            content: Text('$alertString'),
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

  Future<String> getTagIdFromCustoId(String _custoId) async {
    // Compute the tagId from the custoId here
    // Replace this implementation with your logic

    CustomHttpClient httpClient = CustomHttpClient();
    dynamic receiveResult;
    try {
      receiveResult = await httpClient.receiveMessage("GET_TAG_ID", "&customer_id=$_custoId", false);
      // Process the receiveResult here
      print("getTagIdFromCustoId() -> $receiveResult");

    } catch (e) {
      // Handle any exceptions or errors while receiving a message
      print(e);
    }

    return receiveResult;
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
              controller: _custoIdController,
              decoration: InputDecoration(
                labelText: 'Enter Customer ID',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Enter Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _welcomeMessageController,
              decoration: InputDecoration(
                labelText: 'Enter Welcome Message',
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
