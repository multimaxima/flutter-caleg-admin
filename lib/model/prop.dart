// To parse this JSON data, do
//
//     final propModel = propModelFromJson(jsonString);

import 'dart:convert';

PropModel propModelFromJson(String str) => PropModel.fromJson(json.decode(str));

String propModelToJson(PropModel data) => json.encode(data.toJson());

class PropModel {
  PropModel({
    this.id,
    this.kode,
    this.noProp,
    this.nama,
    this.polygon,
  });

  int? id;
  String? kode;
  String? noProp;
  String? nama;
  String? polygon;

  factory PropModel.fromJson(Map<String, dynamic> json) => PropModel(
        id: json["id"],
        kode: json["kode"],
        noProp: json["no_prop"],
        nama: json["nama"],
        polygon: json["polygon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode": kode,
        "no_prop": noProp,
        "nama": nama,
        "polygon": polygon,
      };
}
