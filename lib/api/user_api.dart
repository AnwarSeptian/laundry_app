import 'package:http/http.dart' as http;
import 'package:laundry_app/api/endpoint.dart';
import 'package:laundry_app/helper/shared_preference.dart';
import 'package:laundry_app/model/list_layanan_response.dart';
import 'package:laundry_app/model/profile_respons.dart';
import 'package:laundry_app/model/register_error_response.dart';
import 'package:laundry_app/model/register_response.dart';

class UserService {
  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String name,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.register),
      headers: {"Accept": "application/json"},
      body: {"name": name, "email": email, "password": password},
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(registerResponseFromJson(response.body).toJson());
      return registerResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return registerErrorResponseFromJson(response.body).toJson();
    } else {
      print("Failed to register user: ${response.statusCode}");
      throw Exception("Failed to register user: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );
    print(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      print(registerResponseFromJson(response.body).toJson());
      return registerResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 422 || response.statusCode == 401) {
      return registerErrorResponseFromJson(response.body).toJson();
    } else {
      print("Failed to register user: ${response.statusCode}");
      throw Exception("Failed to register user: ${response.statusCode}");
    }
  }

  Future<ProfileResponse> getProfile() async {
    String? token = await PreferenceHandler.getToken();
    final response = await http.get(
      Uri.parse(Endpoint.profile),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print(response.body);

    if (response.statusCode == 200) {
      print(profileResponseFromJson(response.body));
      return profileResponseFromJson(response.body);
    } else if (response.statusCode == 401) {
      return profileResponseFromJson(response.body);
    } else {
      print('${response.statusCode}');
      throw Exception("${response.statusCode}");
    }
  }
}
