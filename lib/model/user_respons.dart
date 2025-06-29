// To parse this JSON data, do
//
//     final registerResponse = registerResponseFromJson(jsonString);

import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) =>
    RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) =>
    json.encode(data.toJson());

class RegisterResponse {
  String? message;
  UserRespons? data;

  RegisterResponse({this.message, this.data});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        message: json["message"],
        data: json["data"] == null ? null : UserRespons.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class UserRespons {
  String? token;
  User? user;

  UserRespons({this.token, this.user});

  factory UserRespons.fromJson(Map<String, dynamic> json) => UserRespons(
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {"token": token, "user": user?.toJson()};
}

class User {
  String? name;
  String? email;
  String? updatedAt;
  String? createdAt;
  int? id;

  User({this.name, this.email, this.updatedAt, this.createdAt, this.id});

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    updatedAt: json["updated_at"],
    createdAt: json["created_at"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "updated_at": updatedAt,
    "created_at": createdAt,
    "id": id,
  };
}
// To parse this JSON data, do
//
//     final registerErrorResponse = registerErrorResponseFromJson(jsonString);

RegisterErrorResponse registerErrorResponseFromJson(String str) =>
    RegisterErrorResponse.fromJson(json.decode(str));

String registerErrorResponseToJson(RegisterErrorResponse data) =>
    json.encode(data.toJson());

class RegisterErrorResponse {
  String? message;
  Errors? errors;

  RegisterErrorResponse({this.message, this.errors});

  factory RegisterErrorResponse.fromJson(Map<String, dynamic> json) =>
      RegisterErrorResponse(
        message: json["message"],
        errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "errors": errors?.toJson(),
  };
}

class Errors {
  List<String>? name;
  List<String>? email;
  List<String>? password;

  Errors({this.name, this.email, this.password});

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
    name:
        json["name"] == null
            ? []
            : List<String>.from(json["name"]!.map((x) => x)),
    email:
        json["email"] == null
            ? []
            : List<String>.from(json["email"]!.map((x) => x)),
    password:
        json["password"] == null
            ? []
            : List<String>.from(json["password"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? [] : List<dynamic>.from(name!.map((x) => x)),
    "email": email == null ? [] : List<dynamic>.from(email!.map((x) => x)),
    "password":
        password == null ? [] : List<dynamic>.from(password!.map((x) => x)),
  };
}
// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

class ProfileResponse {
  String message;
  Data data;

  ProfileResponse({required this.message, required this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  int id;
  String name;
  String email;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

ListUser ListUserFromJson(String str) => ListUser.fromJson(json.decode(str));

String ListUserToJson(ListUser data) => json.encode(data.toJson());

class ListUser {
  String message;
  List<Data> data;

  ListUser({required this.message, required this.data});

  factory ListUser.fromJson(Map<String, dynamic> json) => ListUser(
    message: json["message"],
    data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
