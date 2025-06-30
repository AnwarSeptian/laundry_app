import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:laundry_app/model/layanan_response.dart';
import 'package:laundry_app/utils/endpoint.dart';
import 'package:laundry_app/utils/shared_preference.dart';

class LayananApi {
  static Future<ListLayananResponses> getLayanan() async {
    String? token = await PreferenceHandler.getToken();
    final response = await http.get(
      Uri.parse(Endpoint.layanan),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print("Respons :${response.body}");
    if (response.statusCode == 200) {
      print(listLayananResponsesFromJson(response.body).toJson());
      return listLayananResponsesFromJson(response.body);
    } else if (response.statusCode == 422) {
      return listLayananResponsesFromJson(response.body);
    } else {
      print("Failed to register user: ${response.statusCode}");
      throw Exception("Failed to register user: ${response.statusCode}");
    }
  }

  static Future<AddLayananResponse> addLayanan({required String name}) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      Uri.parse(Endpoint.layanan),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode({"name": name}),
    );
    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return AddLayananResponse.fromJson(responseData);
    } else if (response.statusCode == 401) {
      final error = ErrorResponse.fromJson(responseData);
      throw Exception("${error.message}: ${error.errors['name']?.join(', ')}");
    } else {
      throw Exception("Failed to add layanan. Status: ${response.statusCode}");
    }
  }

  Future<HapusLayanan> deleteLayanan(int id) async {
    String? token = await PreferenceHandler.getToken();

    final response = await http.delete(
      Uri.parse("${Endpoint.layanan}/$id"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print("Response delete : ${response.body}");
    if (response.statusCode == 200) {
      return hapusLayananFromJson(response.body);
    } else {
      print("Gagal hapus pesanan : ${response.body}");
      throw Exception("Gagal Hapus layanan");
    }
  }
}
