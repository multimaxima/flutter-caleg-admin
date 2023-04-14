import 'dart:convert';
import 'dart:io';

import 'package:caleg_admin/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PartaiDetilPage extends StatefulWidget {
  final int idPartai;
  const PartaiDetilPage(this.idPartai, {super.key});

  @override
  State<PartaiDetilPage> createState() => _PartaiDetilPageState();
}

class _PartaiDetilPageState extends State<PartaiDetilPage> {
  late int idPartai;
  String key = getKey();
  String baseKey = getBaseKey();
  Base64Codec base64 = const Base64Codec();

  final TextEditingController _id = TextEditingController();
  final TextEditingController _partai = TextEditingController();
  final TextEditingController _kode = TextEditingController();
  final TextEditingController _urut = TextEditingController();
  final TextEditingController _logo = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool submitted = false;

  String userUid = getUid();
  String userHp = getHp();

  File? logo;
  Future getImage(ImageSource source) async {
    loadingData();

    final pickedFile = await _picker.pickImage(
      maxWidth: 300,
      source: source,
    );

    if (pickedFile == null) {
      hapusLoader();
      return;
    } else {
      hapusLoader();
      setState(() {
        if (pickedFile != null) {
          final file = File(pickedFile.path);
          final bytes = file.readAsBytesSync();

          _logo.text = base64Encode(bytes);
          logo = file;
        } else {
          errorPesan("Tidak ada file dipilih");
        }
      });
    }
  }

  Future getData() async {
    loadingData();

    var result = await http.get(Uri.parse(
        "${ApiStatus.baseUrl}/api/partai-detil?key=$key&id=$idPartai"));

    if (result.statusCode == 200) {
      hapusLoader();
      var data = json.decode(result.body);

      setState(() {
        _id.text = data['id'].toString();
        _partai.text = data['partai'] ?? "";
        _kode.text = data['kode'] ?? "";
        _urut.text =
            data['urut'].toString() == 'null' ? "" : data['urut'].toString();
        _logo.text = data['logo'] ?? '';
      });
    } else {
      hapusLoader();
      var data = json.decode(result.body);
      errorPesan(data["message"]);
    }
  }

  Future simpanData() async {
    if (_formKey.currentState!.validate() && submitted == false) {
      submitted = true;
      loadingData();

      if (idPartai == 0) {
        var request = await http.post(
          Uri.parse("${ApiStatus.baseUrl}/api/partai-baru"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "key": baseKey,
            "uidKey": userUid,
            "hpKey": userHp,
            "partai": _partai.text,
            "kode": _kode.text,
            "urut": _urut.text,
            "logo": _logo.text,
          }),
        );

        if (request.statusCode == 200) {
          submitted = false;
          hapusLoader();
          pesanData('Data partai berhasil ditambahkan');
          Get.back(result: 'Ok');
        } else {
          var data = await json.decode(request.body);
          submitted = false;
          hapusLoader();
          errorPesan(data['message']);
        }
      } else {
        var request = await http.post(
          Uri.parse("${ApiStatus.baseUrl}/api/partai-edit"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "key": baseKey,
            "uidKey": userUid,
            "hpKey": userHp,
            "id": _id.text,
            "partai": _partai.text,
            "kode": _kode.text,
            "urut": _urut.text,
            "logo": _logo.text,
          }),
        );

        if (request.statusCode == 200) {
          submitted = false;
          hapusLoader();
          pesanData('Data partai berhasil disimpan');
          Get.back(result: 'Ok');
        } else {
          var data = await json.decode(request.body);
          submitted = false;
          hapusLoader();
          errorPesan(data['message']);
        }
      }
    } else {
      hapusLoader();
      errorPesan("DATA BELUM LENGKAP");
    }
  }

  @override
  void initState() {
    super.initState();

    idPartai = widget.idPartai;

    if (idPartai > 0) {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          idPartai == 0 ? "TAMBAH PARTAI" : "EDIT PARTAI",
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: GestureDetector(
              onTap: () {
                simpanData();
              },
              child: const Icon(
                Icons.save,
                size: 24.0,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            const SizedBox(height: 15),
            TextFormField(
              controller: _partai,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "NAMA PARTAI",
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
            const SizedBox(height: 15),
            TextFormField(
              controller: _kode,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "KODE PARTAI",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _urut,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "NOMOR URUT",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "LOGO PARTAI",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            logo != null
                ? Image.file(
                    logo!,
                    width: 150,
                    height: 200,
                    fit: BoxFit.contain,
                  )
                : _logo.text != ""
                    ? Image.memory(
                        base64.decode(_logo.text.split(',').last),
                        width: 150,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Text('Loading foto...');
                        },
                      )
                    : Image.asset(
                        'assets/images/noimg.png',
                        width: 150,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
            const SizedBox(height: 5),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 125,
                        color: Colors.white,
                        child: ListView(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text("Foto Dari Kamera"),
                              onTap: () {
                                Navigator.of(context).pop();
                                getImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text("Ambil File Dari Gallery"),
                              onTap: () {
                                Navigator.of(context).pop();
                                getImage(ImageSource.gallery);
                              },
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.upload),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                label: const Text("UNGGAH LOGO"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
