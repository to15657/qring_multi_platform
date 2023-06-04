import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomHttpClient {
  static const String URL_BASE = "https://bipbipavertisseur.alwaysdata.net";
  static const String ENDPOINT_PREFIX = "/qring/quick_features.php?service=";

  Future<dynamic> sendMessage(String endpointParam, String tagId,
      String custoId, String userName, String message) async {
    String endpointPath = ENDPOINT_PREFIX + endpointParam;
    String urlRequest = URL_BASE +
        endpointPath +
        "&tag_id=$tagId" +
        "&customer_id=$custoId" +
        "&presentation=$userName" +
        "&message=$message";

    try {
      final response = await http.get(Uri.parse(urlRequest));
      if (response.statusCode == 200) {
        // Successful response
        return jsonDecode(response.body);
      } else {
        // Error response
        throw Exception(
            'HTTP request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Exception occurred during the request
      throw Exception('Failed to send message: $e');
    }
  }

  Future<dynamic> receiveMessage(
      String endpointParam,
      String _getParams,
      bool JSONRequest) async {
    String endpointPath = ENDPOINT_PREFIX + endpointParam;
    String urlRequest = URL_BASE + endpointPath + _getParams;

    print(urlRequest);

    String applicationMime = JSONRequest ? "application/json" : "application/txt";

    try {
      final response = await http.get(
        Uri.parse(urlRequest),
        headers: {'Content-Type': applicationMime }
      );

      if (response.statusCode == 200) {

        print(response.body);

        // Successful response
        // Check if the response body can be parsed as JSON
        if (JSONRequest) {
          // Handle the JSON data
          print("json response");
          return jsonDecode(response.body);
        } else {
          // Handle the response body as a string
          print("string response");
          return response.body;
        }
      } else {
        // Error response
        throw Exception(
            'HTTP request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Exception occurred during the request
      throw Exception('Failed to receive message: $e');
    }
  }
}
