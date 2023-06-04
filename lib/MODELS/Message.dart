class Message {
  final String sender;
  final String text;
  final DateTime time;
  final String messageType; // SEND or RECEIVED
  final String messageStatus; // SUCCESS, FAILED, PENDING

  Message({required this.sender,
    required this.text,
    required this.time,
    required this.messageType,
    required this.messageStatus});
}