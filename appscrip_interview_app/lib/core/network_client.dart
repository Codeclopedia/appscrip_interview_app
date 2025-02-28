import 'dart:convert';

import 'package:appscrip_interview_app/models/todomodel.dart';
import 'package:http/http.dart' as http;
import 'package:appscrip_interview_app/models/loginmodel.dart';

import '../models/registermodel.dart';

class NetworkClient {
  NetworkClient();
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

  Future<Registermodel> register({
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

      final registerData = Registermodel.fromRawJson(response.body);

      if (response.statusCode == 200) {
        return registerData;
      } else {
        onError(
            registerData.error ?? "Login failed"); // Call the error callback
        throw Exception(registerData.error ?? "Login failed");
      }
    } catch (e) {
      onError("An error occurred: ${e.toString()}"); // Call the error callback
      throw Exception("An error occurred: ${e.toString()}");
    }
  }

  // Fetch tasks with pagination
  Future<List<Todo>> getTasks(
      {int page = 1, int limit = 10, required Function onError}) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrlTodo?_page=$page&_limit=$limit"),
      );

      if (response.statusCode == 200) {
        final List<Todo> taskList = todoFromJson(response.body);
        return taskList;
      } else {
        throw Exception("Failed to load tasks: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(
          "An error occurred while fetching tasks: ${e.toString()}");
    }
  }

  // Create a new task
  Future<Todo> createTask(Todo task) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrlTodo),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Todo.fromJson(data);
      } else {
        throw Exception("Failed to create task: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(
          "An error occurred while creating the task: ${e.toString()}");
    }
  }

  // Update an existing task
  Future<Todo> updateTask(Todo task) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrlTodo/${task.id}"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Todo.fromJson(data);
      } else {
        throw Exception("Failed to update task: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(
          "An error occurred while updating the task: ${e.toString()}");
    }
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrlTodo/$id"));

      if (response.statusCode != 200) {
        throw Exception("Failed to delete task: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(
          "An error occurred while deleting the task: ${e.toString()}");
    }
  }
}
