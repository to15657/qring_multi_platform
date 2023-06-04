import 'Message.dart';

class Chat {
  List<Message> messages = [];


  void addMessage(Message message) {
    messages.add(message);
    _saveChatToPreferences();
  }

  void clear() {
    messages.clear();
  }

  void _saveChatToPreferences() {
    // Implement the logic to save the chat to local preferences
    // You can use shared_preferences package or any other storage mechanism
    // Example code:
    // ...
  }
}