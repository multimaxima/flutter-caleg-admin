// To parse this JSON data, do
//
//     final kabModel = kabModelFromJson(jsonString);

import 'dart:convert';

KabModel kabModelFromJson(String str) => KabModel.fromJson(json.decode(str));

String kabModelToJson(KabModel data) => json.encode(data.toJson());

class KabModel {
  KabModel({
    this.id,
    this.kode,
    this.noProp,
    this.noKab,
    this.nama,
    this.polygon,
  });

  int? id;
  String? kode;
  String? noProp;
  String? noKab;
  String? nama;
  String? polygon;

  factory KabModel.fromJson(Map<String, dynamic> json) => KabModel(
        id: json["id"],
        kode: json["kode"],
        noProp: json["no_prop"],
        noKab: json["no_kab"],
        nama: json["nama"],
        polygon: json["polygon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode": kode,
        "no_prop": noProp,
        "no_kab": noKab,
        "nama": nama,
        "polygon": polygon,
      };
}
