import 'dart:convert';

class LoginModel {
  final String? token;
  final String? error;

  LoginModel({
    this.token,
    this.error,
  });

  factory LoginModel.fromRawJson(String str) =>
      LoginModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        token: json["token"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "error": error,
      };
}
