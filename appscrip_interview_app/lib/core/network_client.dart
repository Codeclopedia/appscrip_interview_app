import 'package:http/http.dart' as http;
import 'package:appscrip_interview_app/models/loginmodel.dart';

import '../models/registermodel.dart';

class NetworkClient {
  static const String baseUrlAuth = "https://reqres.in/api";
  static const String baseUrlTodo =
      "https://jsonplaceholder.typicode.com/todos";

  Future<String> login({
    required String email,
    required String password,
    required Function(String error) onError, // Callback for handling errors
  }) async {
    try {
      final url = Uri.parse("$baseUrlAuth/login");
      final response = await http.post(url, body: {
        "email": email,
        "password": password,
      });

      final loginData = LoginModel.fromRawJson(response.body);

      if (response.statusCode == 200) {
        return loginData.token!;
      } else {
        onError(loginData.error ?? "Login failed"); // Call the error callback
        throw Exception(loginData.error ?? "Login failed");
      }
    } catch (e) {
      onError("An error occurred: ${e.toString()}"); // Call the error callback
      throw Exception("An error occurred: ${e.toString()}");
    }
  }

  Future<String> register({
    required String email,
    required String password,
    required Function(String error) onError, // Callback for handling errors
  }) async {
    try {
      final url = Uri.parse("$baseUrlAuth/register");
      final response = await http.post(url, body: {
        "email": email,
        "password": password,
      });

      final loginData = Registermodel.fromRawJson(response.body);

      if (response.statusCode == 200) {
        return loginData.token!;
      } else {
        onError(loginData.error ?? "Login failed"); // Call the error callback
        throw Exception(loginData.error ?? "Login failed");
      }
    } catch (e) {
      onError("An error occurred: ${e.toString()}"); // Call the error callback
      throw Exception("An error occurred: ${e.toString()}");
    }
  }
}
