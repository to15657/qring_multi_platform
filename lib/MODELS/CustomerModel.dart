import 'dart:convert';

class CustomerModel {
  String name;
  String welcomeMessage;
  String custoId;
  String tagId;

  CustomerModel({
    required this.name,
    required this.welcomeMessage,
    required this.custoId,
    required this.tagId,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      name: json['name'],
      welcomeMessage: json['welcomeMessage'],
      custoId: json['custoId'],
      tagId: json['tagId'],
    );
  }

  factory CustomerModel.fromJsonString(String jsonString) {
    try {
      Map<String, dynamic> json = jsonDecode(jsonString);
      return CustomerModel.fromJson(json);
    } catch (e) {
      // Exception occurred during the request
      throw Exception('Failed to receive message: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'welcomeMessage': welcomeMessage,
      'custoId': custoId,
      'tagId': tagId,
    };
  }

  // Convert the CustomerModel object to a JSON string
  String toJsonString() {
    Map<String, dynamic> jsonMap = {
      'name': name,
      'welcomeMessage': welcomeMessage,
      'custoId': custoId,
      'tagId': tagId,
    };

    return json.encode(jsonMap);
  }



  // Getter
  String? getCustoId() {
    return custoId;
  }

}
