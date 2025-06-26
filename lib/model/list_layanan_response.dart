// To parse this JSON data, do
//
//     final listLayananResponses = listLayananResponsesFromJson(jsonString);

import 'dart:convert';

ListLayananResponses listLayananResponsesFromJson(String str) =>
    ListLayananResponses.fromJson(json.decode(str));

String listLayananResponsesToJson(ListLayananResponses data) =>
    json.encode(data.toJson());

class ListLayananResponses {
  String message;
  List<User> data;

  ListLayananResponses({required this.message, required this.data});

  factory ListLayananResponses.fromJson(Map<String, dynamic> json) =>
      ListLayananResponses(
        message: json["message"],
        data: List<User>.from(json["data"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class User {
  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
