import 'dart:convert';

class Registermodel {
  int? id;
  String? token;
  String? error;

  Registermodel({
    this.id,
    this.token,
    this.error,
  });

  factory Registermodel.fromRawJson(String str) =>
      Registermodel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Registermodel.fromJson(Map<String, dynamic> json) => Registermodel(
        id: json["id"],
        token: json["token"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "error": error,
      };
}
