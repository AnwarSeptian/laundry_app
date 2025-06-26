import 'package:http/http.dart' as http;
import 'package:laundry_app/api/endpoint.dart';
import 'package:laundry_app/helper/shared_preference.dart';
import 'package:laundry_app/model/list_layanan_response.dart';
import 'package:laundry_app/model/register_error_response.dart';

class TampilanApi {
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
}
