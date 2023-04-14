// To parse this JSON data, do
//
//     final aksesModel = aksesModelFromJson(jsonString);

import 'dart:convert';

AksesModel aksesModelFromJson(String str) =>
    AksesModel.fromJson(json.decode(str));

String aksesModelToJson(AksesModel data) => json.encode(data.toJson());

class AksesModel {
  AksesModel({
    this.id,
    this.akses,
  });

  int? id;
  String? akses;

  factory AksesModel.fromJson(Map<String, dynamic> json) => AksesModel(
        id: json["id"],
        akses: json["akses"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "akses": akses,
      };
}
