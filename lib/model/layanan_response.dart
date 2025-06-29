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
  List<DataLayanan> data;

  ListLayananResponses({required this.message, required this.data});

  factory ListLayananResponses.fromJson(Map<String, dynamic> json) =>
      ListLayananResponses(
        message: json["message"],
        data: List<DataLayanan>.from(
          json["data"].map((x) => DataLayanan.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DataLayanan {
  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  DataLayanan({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataLayanan.fromJson(Map<String, dynamic> json) => DataLayanan(
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

// To parse this JSON data, do
//
//     final hapusLayanan = hapusLayananFromJson(jsonString);

HapusLayanan hapusLayananFromJson(String str) =>
    HapusLayanan.fromJson(json.decode(str));

String hapusLayananToJson(HapusLayanan data) => json.encode(data.toJson());

class HapusLayanan {
  String message;
  dynamic data;

  HapusLayanan({required this.message, required this.data});

  factory HapusLayanan.fromJson(Map<String, dynamic> json) =>
      HapusLayanan(message: json["message"], data: json["data"]);

  Map<String, dynamic> toJson() => {"message": message, "data": data};
}
// To parse this JSON data, do
//

class AddLayananResponse {
  final String message;
  final AddLayanan data;

  AddLayananResponse({required this.message, required this.data});

  factory AddLayananResponse.fromJson(Map<String, dynamic> json) {
    return AddLayananResponse(
      message: json["message"],
      data: AddLayanan.fromJson(json["data"]),
    );
  }
}

class AddLayanan {
  final String name;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  AddLayanan({
    required this.name,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory AddLayanan.fromJson(Map<String, dynamic> json) {
    return AddLayanan(
      name: json["name"],
      updatedAt: DateTime.parse(json["updated_at"]),
      createdAt: DateTime.parse(json["created_at"]),
      id: json["id"],
    );
  }
}

class ErrorResponse {
  final String message;
  final Map<String, dynamic> errors;

  ErrorResponse({required this.message, required this.errors});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(message: json["message"], errors: json["errors"]);
  }
}
