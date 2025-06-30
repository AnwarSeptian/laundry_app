// To parse this JSON DataOrder, do
//
//     final addOrderErrorResponse = addOrderErrorResponseFromJson(jsonString);

import 'dart:convert';

OrderErrorResponse orderErrorResponseFromJson(String str) =>
    OrderErrorResponse.fromJson(json.decode(str));

String orderErrorResponseToJson(OrderErrorResponse data) =>
    json.encode(data.toJson());

class OrderErrorResponse {
  String message;

  OrderErrorResponse({required this.message});

  factory OrderErrorResponse.fromJson(Map<String, dynamic> json) =>
      OrderErrorResponse(message: json["message"]);

  Map<String, dynamic> toJson() => {"message": message};
}
// To parse this JSON data, do
//
//     final addOrderResponse = addOrderResponseFromJson(jsonString);

AddOrderResponse addOrderResponseFromJson(String str) =>
    AddOrderResponse.fromJson(json.decode(str));

String addOrderResponseToJson(AddOrderResponse data) =>
    json.encode(data.toJson());

class AddOrderResponse {
  String message;
  AddOrderData data;

  AddOrderResponse({required this.message, required this.data});

  factory AddOrderResponse.fromJson(Map<String, dynamic> json) =>
      AddOrderResponse(
        message: json["message"],
        data: AddOrderData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class AddOrderData {
  int customerId;
  String layanan;
  int serviceTypeId;
  String status;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  ServiceType serviceType;

  AddOrderData({
    required this.customerId,
    required this.layanan,
    required this.serviceTypeId,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.serviceType,
  });

  factory AddOrderData.fromJson(Map<String, dynamic> json) => AddOrderData(
    customerId: json["customer_id"],
    layanan: json["layanan"],
    serviceTypeId: json["service_type_id"],
    status: json["status"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    serviceType: ServiceType.fromJson(json["service_type"]),
  );

  Map<String, dynamic> toJson() => {
    "customer_id": customerId,
    "layanan": layanan,
    "service_type_id": serviceTypeId,
    "status": status,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
    "service_type": serviceType.toJson(),
  };
}

class ServiceType {
  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  ServiceType({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) => ServiceType(
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

ListOrder listOrderFromJson(String str) => ListOrder.fromJson(json.decode(str));

String listOrderToJson(ListOrder data) => json.encode(data.toJson());

class ListOrder {
  String message;
  List<DataOrder> data;

  ListOrder({required this.message, required this.data});

  factory ListOrder.fromJson(Map<String, dynamic> json) => ListOrder(
    message: json["message"],
    data: List<DataOrder>.from(json["data"].map((x) => DataOrder.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DataOrder {
  int id;
  String customerId;
  String layanan;
  String serviceTypeId;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  ServiceType serviceType;

  DataOrder({
    required this.id,
    required this.customerId,
    required this.layanan,
    required this.serviceTypeId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceType,
  });

  factory DataOrder.fromJson(Map<String, dynamic> json) => DataOrder(
    id: json["id"],
    customerId: json["customer_id"],
    layanan: json["layanan"],
    serviceTypeId: json["service_type_id"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    serviceType:
        json["service_type"] != null
            ? ServiceType.fromJson(json["service_type"])
            : ServiceType(
              id: 0,
              name: "Tidak diketahui",
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_id": customerId,
    "layanan": layanan,
    "service_type_id": serviceTypeId,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "service_type": serviceType.toJson(),
  };
}
// To parse this JSON data, do
//
//     final detailOrder = detailOrderFromJson(jsonString);

DetailOrder detailOrderFromJson(String str) =>
    DetailOrder.fromJson(json.decode(str));

String detailOrderToJson(DetailOrder data) => json.encode(data.toJson());

class DetailOrder {
  String message;
  DataOrder data;

  DetailOrder({required this.message, required this.data});

  factory DetailOrder.fromJson(Map<String, dynamic> json) => DetailOrder(
    message: json["message"],
    data: DataOrder.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}
// To parse this JSON data, do
//
//     final statusOrder = statusOrderFromJson(jsonString);

StatusOrder statusOrderFromJson(String str) =>
    StatusOrder.fromJson(json.decode(str));

String statusOrderToJson(StatusOrder data) => json.encode(data.toJson());

class StatusOrder {
  String message;
  DataOrder data;

  StatusOrder({required this.message, required this.data});

  factory StatusOrder.fromJson(Map<String, dynamic> json) => StatusOrder(
    message: json["message"],
    data: DataOrder.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}
