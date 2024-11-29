// To parse this JSON data, do final engineModel = engineModelFromJson(jsonString);

import 'dart:convert';

EngineModel engineModelFromJson(String str) =>
    EngineModel.fromJson(json.decode(str));

String engineModelToJson(EngineModel data) => json.encode(data.toJson());

class EngineModel {
  String? id;
  String? userId;
  String? name;
  String? imageUrl;
  String? subname;
  String? categoryId;
  String? categoryName;
  bool? isGenerator;
  bool? isCompressor;
  bool? isDefault;

  EngineModel({
    this.id,
    this.userId,
    this.name,
    this.imageUrl,
    this.subname,
    this.categoryId,
    this.categoryName,
    this.isGenerator,
    this.isCompressor,
    this.isDefault,
  });

  factory EngineModel.fromJson(Map<String, dynamic> json) => EngineModel(
        id: json["_id"],
        userId: json[" user"],
        name: json["name"],
        imageUrl: json["url"],
        subname: json["subname"],
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        isGenerator: json["is_generator"],
        isCompressor: json["is_compressor"],
        isDefault: json["is_default"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": userId,
        "name": name,
        "subname": subname,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "is_generator": isGenerator,
        "is_compressor": isCompressor,
        "is_default": isDefault,
      };
}
