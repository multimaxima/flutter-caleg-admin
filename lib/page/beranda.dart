import 'dart:convert';

import 'package:caleg_admin/page/caleg.dart';
import 'package:caleg_admin/page/partai.dart';
import 'package:caleg_admin/page/scan.dart';
import 'package:caleg_admin/page/suara.dart';
import 'package:caleg_admin/page/user.dart';
import 'package:caleg_admin/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  int? idAkses;
  String key = getKey();

  getAkses() async {
    var result = await http
        .get(Uri.parse("${ApiStatus.baseUrl}/api/beranda-info?key=$key"));

    if (result.statusCode == 200) {
      var data = await json.decode(result.body)['user'];

      if (mounted) {
        setState(() {
          idAkses = data['id_akses'];

          hapusLoader();
        });
      }
    } else {
      hapusLoader();
      errorPesan("Terjadi kegagalan koneksi, silahkan ulangi kembali.");
    }
  }

  @override
  void initState() {
    super.initState();
    getAkses();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const ScanPage());
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.black54,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Scan\nKTP',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const PartaiPage());
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.verified_user,
                        size: 50,
                        color: Colors.black54,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Daftar\nPartai',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const CalegPage());
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.people_alt,
                        size: 50,
                        color: Colors.black54,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Daftar\nCaleg',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const UserPage());
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.supervised_user_circle,
                        size: 50,
                        color: Colors.black54,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Daftar\nUser',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const SuaraPage());
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.list_alt,
                        size: 50,
                        color: Colors.black54,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Daftar\nSuara',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: const [
                      Icon(
                        Icons.location_history_rounded,
                        size: 50,
                        color: Colors.black54,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Sebaran\nRelawan',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: const [
                      Icon(
                        Icons.map,
                        size: 50,
                        color: Colors.black54,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Sebaran\nSuara',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 200,
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: IntrinsicColumnWidth(flex: 100),
                1: FixedColumnWidth(10),
                2: IntrinsicColumnWidth(flex: 100),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.top,
              children: const <TableRow>[
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Text(
                        "TOTAL RELAWAN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Text(
                        ":",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Text(
                        "10",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Text(
                        "NAMA CALEG",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Text(
                        ":",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Text(
                        "10",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Text(
                        "HAK AKSES",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Text(
                        ":",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Text(
                        "10",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'AKUN TERBARU',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'DATA TERBARU',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/noimage.jpg',
                      width: 70,
                    ),
                    const Text(
                      "Nama",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "HP",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Alamat",
                      style: TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
