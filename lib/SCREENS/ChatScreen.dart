import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:qring_multi_platform/MODELS/customerModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qring_multi_platform/MODELS/Chat.dart';
import 'package:qring_multi_platform/MODELS/Message.dart';
import 'package:qring_multi_platform/SCREENS/ConfigurationScreen.dart';
import 'package:qring_multi_platform/STYLES//AppTheme.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _buildWaitingForNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the shared preferences to load
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            // If there was an error loading shared preferences
            return Center(
              child: Text('Error loading preferences'),
            );
          }

          String? customerString = snapshot.data?.getString('customer');
          if (customerString != null) {
            // CustomerModel customer =
            //     CustomerModel.fromJson(customerString);
            // String? tagId = customer.getCustoId();
            // Use the tagId as needed
          }

          String subscribedTopic = customerString != null ? '($customerString)' : '-';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Attente de notification',
                  style: titleTextStyle,
                ),
                Text(
                  '(QR code: $subscribedTopic)',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        });
  }
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  TextEditingController _textEditingController = TextEditingController();
  List<Message> _messages = [];
  Chat _chat = Chat();
  bool _waitingForNotification = true;

  @override
  void initState() {
    super.initState();
    _fcm.requestPermission();
    _configureFirebaseMessaging();
    _restoreFCMConfiguration();
  }

  void _restoreFCMConfiguration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? qrCodeTopic = prefs.getString('qrCodeTopic');
    if (qrCodeTopic != null) {
      _fcm.subscribeToTopic(qrCodeTopic);
    }
  }

  void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String ringerName = message.data['name'] ?? 'Name empty';
      setState(() {
        if (_waitingForNotification) {
          _waitingForNotification = false;
        }
        Message messageReceived = Message(
          sender: 'RINGER',
          text: ringerName,
          time: DateTime.now(),
          messageType: "RECEIVED",
          // SEND or RECEIVED
          messageStatus: "SUCCESS",
        );
        _messages.add(messageReceived);
        _chat.addMessage(messageReceived);
      });
    });
  }

  void _sendMessage() {
    String messageText = _textEditingController.text.trim();
    if (messageText.isNotEmpty) {
      setState(() {
        Message message = Message(
          sender: 'RECIPIENT',
          text: messageText,
          time: DateTime.now(),
          messageType: "SEND",
          // SEND or RECEIVED
          messageStatus: "SUCCESS",
        );
        _messages.add(message);
        _chat.addMessage(message);
        _textEditingController.clear();
      });
    }
  }

  void _showConfigurationPanel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfigurationScreen()),
    );
  }

  Widget _buildChat() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (BuildContext context, int index) {
              Message message = _messages[index];
              return ListTile(
                title: Text(
                  message.sender,
                  style: chatSenderTextStyle,
                ),
                subtitle: Text(message.text),
                trailing: Text(
                  message.time.toString(),
                  style: chatTimeTextStyle,
                ),
              );
            },
          ),
        ),
        Divider(),
        ListTile(
          title: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              labelText: 'Type your message',
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QRING'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _showConfigurationPanel,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: _waitingForNotification
            ? _buildWaitingForNotification()
            : _buildChat(),
      ),
      floatingActionButton: Visibility(
        visible: !_waitingForNotification,
        child: Padding(
          padding: EdgeInsets.only(bottom: 60, right: 0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 35,
              height: 35,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _waitingForNotification = true;
                    _messages.clear();
                    _chat.clear();
                  });
                },
                child: Icon(Icons.close),
                backgroundColor: pink.withOpacity(0.5),
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
