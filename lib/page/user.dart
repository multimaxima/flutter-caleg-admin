import 'dart:convert';

import 'package:caleg_admin/model/user.dart';
import 'package:caleg_admin/page/beranda.dart';
import 'package:caleg_admin/page/user_detil.dart';
import 'package:caleg_admin/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<UserModel> penggunaList = [];
  String key = getKey();

  Future getData() async {
    loadingData();
    penggunaList = [];

    var result =
        await http.get(Uri.parse("${ApiStatus.baseUrl}/api/pengguna?key=$key"));

    if (result.statusCode == 200) {
      hapusLoader();
      List pengguna = json.decode(result.body);

      for (var element in pengguna) {
        setState(() {
          penggunaList.add(UserModel.fromJson(element));
        });
      }

      return penggunaList;
    } else {
      hapusLoader();
      errorPesan("Gagal mendapatkan data pengguna");
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
          "DAFTAR USER",
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
                final result = await Get.to(() => const UserDetilPage(0));

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
        itemCount: penggunaList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              final result =
                  await Get.to(() => UserDetilPage(penggunaList[index].id!));

              setState(() {
                if (result != null) {
                  getData();
                }
              });
            },
            contentPadding: const EdgeInsets.all(5),
            leading: SizedBox(
              width: 60,
              child: penggunaList[index].foto != null
                  ? Image.memory(
                      base64.decode(
                          penggunaList[index].foto.toString().split(',').last),
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Text('Loading foto...');
                      },
                    )
                  : Image.asset(
                      'assets/images/noimage.jpg',
                      fit: BoxFit.contain,
                    ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${penggunaList[index].nama}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                Text("0${penggunaList[index].hp?.substring(2)}",
                    style: const TextStyle(fontSize: 12)),
                Text("${penggunaList[index].akses?.toUpperCase()}",
                    style: const TextStyle(fontSize: 12)),
                if (penggunaList[index].idAkses == 4)
                  Text("${penggunaList[index].tingkat?.toUpperCase()}",
                      style: const TextStyle(fontSize: 12)),
                if (penggunaList[index].uid != null)
                  Text("${penggunaList[index].uid}",
                      style: const TextStyle(fontSize: 12)),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                Get.dialog(AlertDialog(
                  content: Text("Hapus ${penggunaList[index].nama} ?"),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        loadingData();

                        var response = await http.delete(Uri.parse(
                            "${ApiStatus.baseUrl}/api/pengguna?key=$key&id=${penggunaList[index].id}"));

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
