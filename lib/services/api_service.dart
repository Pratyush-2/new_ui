import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import '../models/goal.dart';
import '../models/food.dart';
import '../models/log.dart';
import '../models/profile.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl) {
    developer.log('ApiService initialized with baseUrl: $baseUrl');
  }

  // Helper to handle HTTP responses
  dynamic _handleResponse(http.Response response) {
    developer.log('API Response: ${response.statusCode} from ${response.request?.url}');
    developer.log('Response body: ${response.body}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      developer.log('API Error: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load data: ${response.statusCode} ${response.body}');
    }
  }
  
  // Helper to handle HTTP errors
  Future<T> _safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } catch (e) {
      developer.log('API Call Error: $e');
      rethrow;
    }
  }

  // Food Endpoints
  Future<List<Food>> getFoods() async {
    final uri = Uri.parse('$baseUrl/foods/');
    final response = await http.get(uri);
    final data = _handleResponse(response) as List<dynamic>;
    return data.map((f) => Food.fromJson(f as Map<String, dynamic>)).toList();
  }

  Future<Map<String, dynamic>> addFood(Map<String, dynamic> foodData) async {
    return createFood(foodData);
  }

  Future<Map<String, dynamic>> createFood(Map<String, dynamic> foodData) async {
    return _safeApiCall(() async {
      developer.log('Creating food with URL: $baseUrl/foods/');
      final uri = Uri.parse('$baseUrl/foods/');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(foodData),
      );
      return _handleResponse(response);
    });
  }

  Future<Map<String, dynamic>> getTotals(String date) async {
    final uri = Uri.parse('$baseUrl/totals/$date');
    final response = await http.get(uri);
    return _handleResponse(response);
  }

  // Daily Logs Endpoints
  Future<List<DailyLogModel>> getLogs(String logDate) async {
    final uri = Uri.parse('$baseUrl/logs/?date=$logDate');
    final response = await http.get(uri);
    final data = _handleResponse(response) as List<dynamic>;
    return data.map((e) => DailyLogModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Map<String, dynamic>> addLog(Map<String, dynamic> logData) async {
    final uri = Uri.parse('$baseUrl/logs/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(logData),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createDailyLog(Map<String, dynamic> logData) async {
    final uri = Uri.parse('$baseUrl/logs/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(logData),
    );
    return _handleResponse(response);
  }

  Future<List<DailyLogModel>> getDailyLogsByDate(String logDate) async {
    final uri = Uri.parse('$baseUrl/logs/?date=$logDate');
    final response = await http.get(uri);
    final data = _handleResponse(response) as List<dynamic>;
    return data.map((e) => DailyLogModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Goals Endpoints
  Future<List<Goal>> getGoals(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/goals/$userId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((goal) => Goal.fromJson(goal)).toList();
    } else {
      throw Exception("Failed to load goals");
    }
  }

  

  Future<Map<String, dynamic>> setUserGoal(Map<String, dynamic> goalData) async {
    final uri = Uri.parse('$baseUrl/goals/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(goalData),
    );
    return _handleResponse(response);
  }

  Future<List<Goal>> getAllGoals() async {
    final uri = Uri.parse('$baseUrl/goals/all/');
    final response = await http.get(uri);
    final data = _handleResponse(response) as List<dynamic>;
    return data.map((g) => Goal.fromJson(g as Map<String, dynamic>)).toList();
  }

  // TODO: Implement this method
  Future<Map<String, dynamic>> updateGoals(Goal goal) async {
    print('Updating goals: ${goal.toJson()}');
    // This is a placeholder. You need to implement the actual API call.
    // For example:
    // final response = await http.put(
    //   Uri.parse('$baseUrl/goals/${goal.id}'), // Assuming you have a goal ID and a PUT endpoint
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode(goal.toJson()),
    // );
    // return _handleResponse(response);
    return Future.value({});
  }

  // User Profiles Endpoints
  Future<List<UserProfileModel>> getProfiles() async {
    return getAllProfiles();
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    return createProfile(profileData);
  }

  Future<Map<String, dynamic>> createProfile(Map<String, dynamic> profileData) async {
    final uri = Uri.parse('$baseUrl/profiles/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profileData),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getProfileById(int profileId) async {
    final uri = Uri.parse('$baseUrl/profiles/$profileId');
    final response = await http.get(uri);
    return _handleResponse(response);
  }

  Future<List<UserProfileModel>> getAllProfiles() async {
    final uri = Uri.parse('$baseUrl/profiles/');
    final response = await http.get(uri);
    final data = _handleResponse(response) as List<dynamic>;
    return data.map((e) => UserProfileModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // (optional) identifyFoodFromImage can be added later if needed
}
