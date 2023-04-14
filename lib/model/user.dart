// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.nama,
    this.foto,
    this.hp,
    this.uid,
    this.akses,
    this.idAkses,
    this.tingkat,
  });

  int? id;
  String? nama;
  String? foto;
  String? hp;
  String? uid;
  String? akses;
  int? idAkses;
  String? tingkat;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        nama: json["nama"],
        foto: json["foto"],
        hp: json["hp"],
        uid: json["uid"],
        akses: json["akses"],
        idAkses: json["id_akses"],
        tingkat: json["tingkat"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "foto": foto,
        "hp": hp,
        "uid": uid,
        "akses": akses,
        "id_akses": idAkses,
        "tingkat": tingkat,
      };
}
