import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:laundry_app/model/layanan_response.dart';
import 'package:laundry_app/model/order_response.dart';
import 'package:laundry_app/utils/endpoint.dart';
import 'package:laundry_app/utils/shared_preference.dart';

class OrderApi {
  Future<List<DataOrder>> getOrder() async {
    String? token = await PreferenceHandler.getToken();
    final response = await http.get(
      Uri.parse(Endpoint.orders),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print("Response body : ${response.body}");
    if (response.statusCode == 200) {
      return listOrderFromJson(response.body).data;
    } else {
      throw Exception("Gagal : ${response.statusCode}");
    }
  }

  Future<AddOrderResponse> addOrder({
    required String layanan,
    required int serviceTypeId,
  }) async {
    String? token = await PreferenceHandler.getToken();
    final response = await http.post(
      Uri.parse(Endpoint.orders),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"layanan": layanan, "service_type_id": serviceTypeId}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return AddOrderResponse.fromJson(jsonDecode(response.body));
    } else {
      final error = ErrorResponse.fromJson(jsonDecode(response.body));
      throw Exception("Gagal : ${error.message}");
    }
  }

  Future<DetailOrder> deleteOrder(int id) async {
    String? token = await PreferenceHandler.getToken();

    final response = await http.delete(
      Uri.parse("${Endpoint.orders}/$id"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print("Response delete  : ${response.body}");
    if (response.statusCode == 200) {
      return detailOrderFromJson(response.body);
    } else {
      throw Exception("Gagal membatalkan pesanan");
    }
  }

  Future<DetailOrder> detailOrder(int id) async {
    String? token = await PreferenceHandler.getToken();
    final response = await http.get(
      Uri.parse("${Endpoint.orders}/$id"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print("Response detail ORDER: ${response.body}");

    if (response.statusCode == 200) {
      return detailOrderFromJson(response.body);
    } else {
      throw Exception("Gagal menampilkan detail");
    }
  }

  Future<StatusOrder> ubahStatus({
    required String status,
    required int id,
  }) async {
    String? token = await PreferenceHandler.getToken();
    final response = await http.post(
      Uri.parse("${Endpoint.orders}/$id/status"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print("Ganti status order ${response.body}");

    if (response.statusCode == 200) {
      return statusOrderFromJson(response.body);
    } else {
      throw Exception("Gagal mengupdate order");
    }
  }
}
