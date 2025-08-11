import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  ApiService(this.baseUrl);

  Future<Map<String, dynamic>> identifyFoodFromImage(String imagePath) async {
    // TODO: implement multipart upload to your FastAPI AI endpoint
    final uri = Uri.parse('\$baseUrl/identify');
    final resp = await http.get(uri);
    return jsonDecode(resp.body);
  }
}