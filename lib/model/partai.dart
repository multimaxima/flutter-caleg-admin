// To parse this JSON data, do
//
//     final partaiListModel = partaiListModelFromJson(jsonString);

import 'dart:convert';

PartaiListModel partaiListModelFromJson(String str) =>
    PartaiListModel.fromJson(json.decode(str));

String partaiListModelToJson(PartaiListModel data) =>
    json.encode(data.toJson());

class PartaiListModel {
  PartaiListModel({
    this.id,
    this.partai,
    this.kode,
    this.urut,
    this.logo,
  });

  int? id;
  String? partai;
  String? kode;
  int? urut;
  String? logo;

  factory PartaiListModel.fromJson(Map<String, dynamic> json) =>
      PartaiListModel(
        id: json["id"],
        partai: json["partai"],
        kode: json["kode"],
        urut: json["urut"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "partai": partai,
        "kode": kode,
        "urut": urut,
        "logo": logo,
      };
}
