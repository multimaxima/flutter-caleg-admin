// To parse this JSON data, do
//
//     final calegModel = calegModelFromJson(jsonString);

import 'dart:convert';

CalegModel calegModelFromJson(String str) =>
    CalegModel.fromJson(json.decode(str));

String calegModelToJson(CalegModel data) => json.encode(data.toJson());

class CalegModel {
  CalegModel({
    this.id,
    this.nama,
    this.foto,
    this.hp,
    this.uid,
    this.tingkat,
    this.propinsiWilayah,
    this.kotaWilayah,
    this.status,
    this.createdAt,
    this.demoAt,
    this.endAt,
    this.distributor,
    this.relawan,
    this.suara,
    this.bayar,
  });

  int? id;
  String? nama;
  String? foto;
  String? hp;
  String? uid;
  String? tingkat;
  String? propinsiWilayah;
  String? kotaWilayah;
  int? status;
  String? createdAt;
  String? demoAt;
  String? endAt;
  String? distributor;
  int? relawan;
  int? suara;
  int? bayar;

  factory CalegModel.fromJson(Map<String, dynamic> json) => CalegModel(
        id: json["id"],
        nama: json["nama"],
        foto: json["foto"],
        hp: json["hp"],
        uid: json["uid"],
        tingkat: json["tingkat"],
        propinsiWilayah: json["propinsi_wilayah"],
        kotaWilayah: json["kota_wilayah"],
        status: json["status"],
        createdAt: json["created_at"],
        demoAt: json["demo_at"],
        endAt: json["end_at"],
        distributor: json["distributor"],
        relawan: json["relawan"],
        suara: json["suara"],
        bayar: json["bayar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "foto": foto,
        "hp": hp,
        "uid": uid,
        "tingkat": tingkat,
        "propinsi_wilayah": propinsiWilayah,
        "kota_wilayah": kotaWilayah,
        "status": status,
        "created_at": createdAt,
        "demo_at": demoAt,
        "end_at": endAt,
        "distributor": distributor,
        "relawan": relawan,
        "suara": suara,
        "bayar": bayar,
      };
}
