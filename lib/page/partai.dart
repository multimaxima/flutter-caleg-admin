import 'dart:convert';

import 'package:caleg_admin/model/partai.dart';
import 'package:caleg_admin/page/beranda.dart';
import 'package:caleg_admin/page/partai_detil.dart';
import 'package:caleg_admin/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PartaiPage extends StatefulWidget {
  const PartaiPage({super.key});

  @override
  State<PartaiPage> createState() => _PartaiPageState();
}

class _PartaiPageState extends State<PartaiPage> {
  List<PartaiListModel> partaiList = [];
  String key = getKey();

  Future getData() async {
    loadingData();
    partaiList = [];

    var result =
        await http.get(Uri.parse("${ApiStatus.baseUrl}/api/partai?key=$key"));

    if (result.statusCode == 200) {
      hapusLoader();
      List partai = json.decode(result.body)['data'];

      for (var element in partai) {
        setState(() {
          partaiList.add(PartaiListModel.fromJson(element));
        });
      }

      return partaiList;
    } else {
      hapusLoader();
      errorPesan("Gagal mendapatkan data partai");
      Get.off(() => const BerandaPage());
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
          "DAFTAR PARTAI",
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
                final result = await Get.to(() => const PartaiDetilPage(0));

                setState(() {
                  if (result != null) {
                    getData();
                  }
                });
              },
              child: const Icon(
                Icons.add,
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
        itemCount: partaiList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              final result =
                  await Get.to(() => PartaiDetilPage(partaiList[index].id!));

              setState(() {
                if (result != null) {
                  getData();
                }
              });
            },
            contentPadding: const EdgeInsets.all(5),
            leading: SizedBox(
              width: 60,
              child: partaiList[index].logo != null
                  ? SizedBox(
                      width: 50,
                      child: Image.memory(
                        base64.decode(
                            partaiList[index].logo.toString().split(',').last),
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
                        'assets/images/noimg.png',
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${partaiList[index].partai?.toUpperCase()}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
                Text(
                    partaiList[index].kode == null
                        ? "Kode : "
                        : "Kode : ${partaiList[index].kode}",
                    style: const TextStyle(fontSize: 12)),
                Text(
                    partaiList[index].urut == null
                        ? "No. Urut : "
                        : "No. Urut : ${partaiList[index].urut}",
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                Get.dialog(AlertDialog(
                  content: Text("Hapus ${partaiList[index].partai} ?"),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        loadingData();

                        var response = await http.delete(Uri.parse(
                            "${ApiStatus.baseUrl}/api/partai?key=$key&id=${partaiList[index].id}"));

                        if (response.statusCode == 200) {
                          hapusLoader();
                          pesanData(json.decode(response.body)['message']);
                          Get.back();
                          getData();
                        } else {
                          hapusLoader();
                          errorPesan(json.decode(response.body)['message']);
                          return;
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
                ));
              },
              icon: const Icon(Icons.delete),
            ),
          );
        },
      ),
    );
  }
}
