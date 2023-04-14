import 'dart:convert';

import 'package:caleg_admin/model/caleg.dart';
import 'package:caleg_admin/page/caleg_detil.dart';
import 'package:caleg_admin/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CalegPage extends StatefulWidget {
  const CalegPage({super.key});

  @override
  State<CalegPage> createState() => _CalegPageState();
}

class _CalegPageState extends State<CalegPage> {
  List<CalegModel> calegList = [];
  String key = getKey();
  int idAkses = 0;

  final _cari = TextEditingController();

  Future getData() async {
    loadingData();

    calegList = [];

    var result =
        await http.get(Uri.parse("${ApiStatus.baseUrl}/api/caleg?key=$key"));

    if (result.statusCode == 200) {
      hapusLoader();
      setState(() {
        idAkses = json.decode(result.body)['idAkses'];
      });

      List caleg = json.decode(result.body)['data'];

      for (var element in caleg) {
        setState(() {
          calegList.add(CalegModel.fromJson(element));
        });
      }

      return calegList;
    } else {
      hapusLoader();
      errorPesan("Gagal mendapatkan data caleg");
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DAFTAR CALEG",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: GestureDetector(
              onTap: () async {
                Get.dialog(
                  AlertDialog(
                    content: TextFormField(
                      controller: _cari,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        labelText: "CARI DATA",
                        labelStyle: TextStyle(fontSize: 14),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      validator: (value) {
                        if (value == "") {
                          return 'Nama Partai wajib diisi';
                        }
                        return null;
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "CARI",
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text(
                          "BATAL",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(
                Icons.search,
                size: 24.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: Colors.black,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: calegList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Get.to(
                () => CalegDetilPage(calegList[index].id!),
              );
            },
            contentPadding: const EdgeInsets.all(5),
            leading: calegList[index].foto != null
                ? SizedBox(
                    width: 50,
                    child: Image.memory(
                      base64.decode(
                          calegList[index].foto.toString().split(',').last),
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Text('Loading foto...');
                      },
                    ),
                  )
                : SizedBox(
                    width: 50,
                    child: Image.asset(
                      'assets/images/noimage.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${calegList[index].nama}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "0${calegList[index].hp?.substring(2)}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: IntrinsicColumnWidth(flex: 50),
                    1: FixedColumnWidth(20),
                    2: IntrinsicColumnWidth(flex: 100),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  children: <TableRow>[
                    if (calegList[index].tingkat != null)
                      TableRow(
                        children: [
                          const TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text("Tingkat",
                                  style: TextStyle(fontSize: 12))),
                          const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text("=", style: TextStyle(fontSize: 12)),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text(
                                "${calegList[index].tingkat?.toUpperCase()}",
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    if (calegList[index].propinsiWilayah != null)
                      TableRow(
                        children: [
                          const TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text("Propinsi",
                                  style: TextStyle(fontSize: 12))),
                          const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text("=", style: TextStyle(fontSize: 12)),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text("${calegList[index].propinsiWilayah}",
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    if (calegList[index].kotaWilayah != null)
                      TableRow(
                        children: [
                          const TableCell(
                              verticalAlignment: TableCellVerticalAlignment.top,
                              child: Text("Kab/Kota",
                                  style: TextStyle(fontSize: 12))),
                          const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text("=", style: TextStyle(fontSize: 12)),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text("${calegList[index].kotaWilayah}",
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    TableRow(
                      children: [
                        const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text("Relawan",
                                style: TextStyle(fontSize: 12))),
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text("=", style: TextStyle(fontSize: 12)),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text("${calegList[index].relawan} Orang",
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child:
                                Text("Suara", style: TextStyle(fontSize: 12))),
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text("=", style: TextStyle(fontSize: 12)),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text("${calegList[index].suara} Orang",
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text("Petugas",
                                style: TextStyle(fontSize: 12))),
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text("=", style: TextStyle(fontSize: 12)),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text(
                              calegList[index]
                                  .distributor
                                  .toString()
                                  .toUpperCase(),
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Text("Aktif Sejak",
                                style: TextStyle(fontSize: 12))),
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text("=", style: TextStyle(fontSize: 12)),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text(
                              "${calegList[index].createdAt?.toUpperCase()}",
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                    calegList[index].bayar == 0
                        ? TableRow(
                            children: [
                              const TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.top,
                                  child: Text("Demo s/d",
                                      style: TextStyle(fontSize: 12))),
                              const TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.top,
                                child:
                                    Text("=", style: TextStyle(fontSize: 12)),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.top,
                                child: Text(
                                    "${calegList[index].demoAt?.toUpperCase()}",
                                    style: const TextStyle(fontSize: 12)),
                              ),
                            ],
                          )
                        : TableRow(
                            children: [
                              const TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.top,
                                  child: Text("Berlaku s/d",
                                      style: TextStyle(fontSize: 12))),
                              const TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.top,
                                child:
                                    Text("=", style: TextStyle(fontSize: 12)),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.top,
                                child: Text(
                                    "${calegList[index].endAt?.toUpperCase()}",
                                    style: const TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                    TableRow(
                      children: [
                        const TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child:
                                Text("Status", style: TextStyle(fontSize: 12))),
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Text("=", style: TextStyle(fontSize: 12)),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: calegList[index].status == 0
                              ? const Text(
                                  "DIBLOKIR",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              : const Text(
                                  "AKTIF",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (idAkses == 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      calegList[index].status == 0
                          ? TextButton(
                              child: const Text(
                                'BUKA BLOKIR',
                                style: TextStyle(color: Colors.green),
                              ),
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    content: Text(
                                        "Buka blokir ${calegList[index].nama} ?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          var response = await http.get(Uri.parse(
                                              "${ApiStatus.baseUrl}/api/caleg-buka-blokir?key=$key&id=${calegList[index].id}"));

                                          if (response.statusCode == 200) {
                                            pesanData('Blokir berhasil dibuka');
                                            setState(() {
                                              Get.back();
                                              getData();
                                            });
                                          } else {
                                            errorData();
                                            Get.back();
                                          }
                                        },
                                        child: const Text(
                                          "YA",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text("BATAL"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : TextButton(
                              child: const Text(
                                'BLOKIR',
                                style: TextStyle(color: Colors.green),
                              ),
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    content: Text(
                                        "Blokir ${calegList[index].nama} ?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          var response = await http.get(Uri.parse(
                                              "${ApiStatus.baseUrl}/api/caleg-blokir?key=$key&id=${calegList[index].id}"));

                                          if (response.statusCode == 200) {
                                            pesanData('Data berhasil diblokir');
                                            setState(() {
                                              Get.back();
                                              getData();
                                            });
                                          } else {
                                            errorData();
                                            Get.back();
                                          }
                                        },
                                        child: const Text(
                                          "YA",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text("BATAL"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                      TextButton(
                        child: const Text(
                          'HAPUS',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        onPressed: () {
                          Get.dialog(
                            AlertDialog(
                              content: Text("Hapus ${calegList[index].nama} ?"),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    var response = await http.delete(Uri.parse(
                                        "${ApiStatus.baseUrl}/api/caleg?key=$key"));

                                    if (response.statusCode == 200) {
                                      pesanData('Data berhasil dihapus');
                                      Get.back();
                                      getData();
                                    } else {
                                      errorData();
                                      Get.back();
                                    }
                                  },
                                  child: const Text(
                                    "YA",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text("BATAL"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
