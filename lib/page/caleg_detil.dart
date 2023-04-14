import 'dart:convert';

import 'package:caleg_admin/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CalegDetilPage extends StatefulWidget {
  final int id;
  const CalegDetilPage(this.id, {super.key});

  @override
  State<CalegDetilPage> createState() => _CalegDetilPageState();
}

class _CalegDetilPageState extends State<CalegDetilPage> {
  late int id;
  int? idCaleg;
  String alamat = "";
  String ttl = "";
  Map<String, dynamic> data = {};
  String key = getKey();

  getData() async {
    loadingData();

    var result = await http.get(
        Uri.parse("${ApiStatus.baseUrl}/api/caleg-detil?key=$key&id=$idCaleg"));

    if (result.statusCode == 200) {
      hapusLoader();
      setState(() {
        data = json.decode(result.body);
        if (data['alamat'] != null) alamat = data['alamat'] + ', ';
        if (data['dusun'] != null) alamat = '${alamat + data['dusun']}, ';
        if (data['rt'] != null) alamat = '$alamat RT. ${data['rt']} ';
        if (data['rw'] != null) alamat = '$alamat RW. ${data['rw']} ';
        if (data['desa'] != null) alamat = '${alamat + data['desa']}, ';
        if (data['kecamatan'] != null) {
          alamat = '${alamat + data['kecamatan']}, ';
        }
        if (data['kota'] != null) alamat = '${alamat + data['kota']}, ';
        if (data['propinsi'] != null) alamat = alamat + data['propinsi'];

        if (data['temp_lahir'] != null) ttl = data['temp_lahir'] + ', ';
        if (data['tgl_lahir'] != null) ttl = ttl + data['tgl_lahir'];
      });
    } else {
      hapusLoader();
      errorPesan("Gagal mendapatkan detil data caleg");
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    idCaleg = widget.id;

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DETIL CALEG",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          data['foto'] != null
              ? Image.memory(
                  base64.decode(data['foto'].split(',').last),
                  width: 150,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Text('Loading foto...');
                  },
                )
              : Image.asset(
                  'assets/images/noimage.jpg',
                  width: 150,
                  height: 200,
                  fit: BoxFit.contain,
                ),
          const SizedBox(height: 10),
          const Text("UID :"),
          Text("${data['uid']}"),
          const SizedBox(height: 10),
          const Text("Nama :"),
          Text(data['nama'] ?? ""),
          const SizedBox(height: 10),
          const Text("Alamat :"),
          Text(alamat),
          const SizedBox(height: 10),
          const Text("Tempat Tanggal Lahir :"),
          Text(ttl),
          const SizedBox(height: 10),
          const Text("Jenis Kelamin :"),
          data['kelamin'] == 1
              ? const Text("LAKI-LAKI")
              : const Text("PEREMPUAN"),
          const SizedBox(height: 10),
          const Text("Koordinat Rumah :"),
          Text("Lat : ${data['lat'] ?? ""} Lng : ${data['lng'] ?? ""}"),
          const SizedBox(height: 10),
          const Text("Nomor Handphone :"),
          Text("0${data['hp'].toString().substring(2)}"),
          const SizedBox(height: 10),
          const Text("Nomor Induk Kependudukan :"),
          Text("${data['nik'] ?? ""}"),
        ],
      ),
    );
  }
}
