// To parse this JSON data, do
//
//     final modelOrders = modelOrdersFromJson(jsonString);

import 'dart:convert';

ModelOrders modelOrdersFromJson(String str) => ModelOrders.fromJson(json.decode(str));

String modelOrdersToJson(ModelOrders data) => json.encode(data.toJson());

class ModelOrders {
  ModelOrders({
    this.status,
    this.code,
    this.message,
    this.totalData,
    this.data,
  });

  bool status;
  int code;
  String message;
  int totalData;
  List<DataOrders> data;

  factory ModelOrders.fromJson(Map<String, dynamic> json) => ModelOrders(
    status: json["status"],
    code: json["code"],
    message: json["message"],
    totalData: json["total_data"],
    data: List<DataOrders>.from(json["data"].map((x) => DataOrders.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "total_data": totalData,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DataOrders {
  DataOrders({
    this.idOrder,
    this.latlongPelanggan,
    this.latlongPejasa,
    this.jasaName,
    this.jasaHarga,
    this.jasaImages,
    this.vendorId,
    this.jasaId,
    this.orderBy,
    this.pickUpBy,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.jasaTimes,
    this.orderAt,
  });

  String idOrder;
  String latlongPelanggan;
  String latlongPejasa;
  String jasaName;
  int jasaHarga;
  String jasaImages;
  String vendorId;
  String jasaId;
  String orderBy;
  String pickUpBy;
  DateTime createdAt;
  DateTime updatedAt;
  String status;
  DateTime jasaTimes;
  String orderAt;

  factory DataOrders.fromJson(Map<String, dynamic> json) => DataOrders(
    idOrder: json["id_order"],
    latlongPelanggan: json["latlongPelanggan"] == null ? null : json["latlongPelanggan"],
    latlongPejasa: json["latlongPejasa"] == null ? null : json["latlongPejasa"],
    jasaName: json["jasaName"] == null ? null : json["jasaName"],
    jasaHarga: json["jasaHarga"] == null ? null : json["jasaHarga"],
    jasaImages: json["jasaImages"] == null ? null : json["jasaImages"],
    vendorId: json["vendorId"] == null ? null : json["vendorId"],
    jasaId: json["jasaId"] == null ? null : json["jasaId"],
    orderBy: json["orderBy"] == null ? null : json["orderBy"],
    pickUpBy: json["pickUpBy"] == null ? null : json["pickUpBy"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    status: json["status"] == null ? null : json["status"],
    jasaTimes: json["jasaTimes"] == null ? null : DateTime.parse(json["jasaTimes"]),
    orderAt: json["orderAt"] == null ? null : json["orderAt"],
  );

  Map<String, dynamic> toJson() => {
    "id_order": idOrder,
    "latlongPelanggan": latlongPelanggan == null ? null : latlongPelanggan,
    "latlongPejasa": latlongPejasa == null ? null : latlongPejasa,
    "jasaName": jasaName == null ? null : jasaName,
    "jasaHarga": jasaHarga == null ? null : jasaHarga,
    "jasaImages": jasaImages == null ? null : jasaImages,
    "vendorId": vendorId == null ? null : vendorId,
    "jasaId": jasaId == null ? null : jasaId,
    "orderBy": orderBy == null ? null : orderBy,
    "pickUpBy": pickUpBy == null ? null : pickUpBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "status": status == null ? null : status,
    "jasaTimes": jasaTimes == null ? null : jasaTimes.toIso8601String(),
    "orderAt": orderAt == null ? null : orderAt,
  };
}
