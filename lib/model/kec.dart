// To parse this JSON data, do
//
//     final kecModel = kecModelFromJson(jsonString);

import 'dart:convert';

KecModel kecModelFromJson(String str) => KecModel.fromJson(json.decode(str));

String kecModelToJson(KecModel data) => json.encode(data.toJson());

class KecModel {
  KecModel({
    this.id,
    this.kode,
    this.noProp,
    this.noKab,
    this.noKec,
    this.nama,
    this.polygon,
  });

  int? id;
  String? kode;
  String? noProp;
  String? noKab;
  String? noKec;
  String? nama;
  String? polygon;

  factory KecModel.fromJson(Map<String, dynamic> json) => KecModel(
        id: json["id"],
        kode: json["kode"],
        noProp: json["no_prop"],
        noKab: json["no_kab"],
        noKec: json["no_kec"],
        nama: json["nama"],
        polygon: json["polygon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode": kode,
        "no_prop": noProp,
        "no_kab": noKab,
        "no_kec": noKec,
        "nama": nama,
        "polygon": polygon,
      };
}
