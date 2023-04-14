// To parse this JSON data, do
//
//     final kelModel = kelModelFromJson(jsonString);

import 'dart:convert';

KelModel kelModelFromJson(String str) => KelModel.fromJson(json.decode(str));

String kelModelToJson(KelModel data) => json.encode(data.toJson());

class KelModel {
  KelModel({
    this.id,
    this.kode,
    this.noProp,
    this.noKab,
    this.noKec,
    this.noKel,
    this.nama,
    this.polygon,
  });

  int? id;
  String? kode;
  String? noProp;
  String? noKab;
  String? noKec;
  String? noKel;
  String? nama;
  String? polygon;

  factory KelModel.fromJson(Map<String, dynamic> json) => KelModel(
        id: json["id"],
        kode: json["kode"],
        noProp: json["no_prop"],
        noKab: json["no_kab"],
        noKec: json["no_kec"],
        noKel: json["no_kel"],
        nama: json["nama"],
        polygon: json["polygon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode": kode,
        "no_prop": noProp,
        "no_kab": noKab,
        "no_kec": noKec,
        "no_kel": noKel,
        "nama": nama,
        "polygon": polygon,
      };
}
