import 'package:appscrip_interview_app/models/usermodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final usersProvider = FutureProvider<List<Users>>((ref) async {
  final response = await http.get(Uri.parse('https://reqres.in/api/users'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body)['data'] as List;
    return data.map((user) => Users.fromJson(user)).toList();
  } else {
    throw Exception('Failed to load users');
  }
});
