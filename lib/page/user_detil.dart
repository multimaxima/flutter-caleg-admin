import 'dart:convert';

import 'package:caleg_admin/model/akses.dart';
import 'package:caleg_admin/model/caleg.dart';
import 'package:caleg_admin/model/kab.dart';
import 'package:caleg_admin/model/prop.dart';
import 'package:caleg_admin/service/service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserDetilPage extends StatefulWidget {
  final int idUser;
  const UserDetilPage(this.idUser, {super.key});

  @override
  State<UserDetilPage> createState() => _UserDetilPageState();
}

class _UserDetilPageState extends State<UserDetilPage> {
  late int idUser;
  String key = getKey();
  String baseKey = getBaseKey();
  String userUid = getUid();
  String userHp = getHp();

  final TextEditingController _id = TextEditingController();
  final TextEditingController _idPartai = TextEditingController();
  final TextEditingController _partai = TextEditingController();
  final TextEditingController _idCaleg = TextEditingController();
  final TextEditingController _caleg = TextEditingController();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _hp = TextEditingController();
  final TextEditingController _uid = TextEditingController();
  final TextEditingController _idAkses = TextEditingController();
  final TextEditingController _akses = TextEditingController();
  final TextEditingController _tingkat = TextEditingController();
  final TextEditingController _noPropWilayah = TextEditingController();
  final TextEditingController _propinsiWilayah = TextEditingController();
  final TextEditingController _noKabWilayah = TextEditingController();
  final TextEditingController _kotaWilayah = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool submitted = false;

  Future getUser() async {
    loadingData();

    var result = await http.get(Uri.parse(
        "${ApiStatus.baseUrl}/api/pengguna-detil?key=$key&id=$idUser"));

    if (result.statusCode == 200) {
      hapusLoader();
      var data = json.decode(result.body);

      setState(() {
        _id.text = data['id'].toString();
        _idPartai.text = data['id_partai'].toString();
        _partai.text = data['partai'] ?? "";
        _idCaleg.text = data['id_caleg'].toString();
        _caleg.text = data['caleg'] ?? "";
        _nama.text = data['nama'] ?? '';
        _hp.text = data['hp'].substring(2) ?? '';
        _uid.text = data['uid'] ?? '';
        _idAkses.text = data['id_akses'].toString();
        _akses.text = data['akses'] ?? '';
        _tingkat.text = data['tingkat'] ?? '';
        _noPropWilayah.text = data['no_prop_wilayah'] ?? '';
        _propinsiWilayah.text = data['propinsi_wilayah'] ?? '';
        _noKabWilayah.text = data['no_kab_wilayah'] ?? '';
        _kotaWilayah.text = data['kota_wilayah'] ?? '';
      });
    } else {
      hapusLoader();
      var data = json.decode(result.body);
      errorPesan(data["message"]);
    }
  }

  Future simpanUser() async {
    if (_formKey.currentState!.validate() && submitted == false) {
      submitted = true;
      loadingData();

      if (idUser == 0) {
        final request = await http.post(
          Uri.parse("${ApiStatus.baseUrl}/api/pengguna"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "key": baseKey,
            "uidKey": userUid,
            "hpKey": userHp,
            "id_partai": _idPartai.text,
            "id_caleg": _idCaleg.text,
            "nama": _nama.text,
            "hp": "62${_hp.text}",
            "id_akses": _idAkses.text,
            "tingkat": _tingkat.text,
            "no_prop_wilayah": _noPropWilayah.text,
            "propinsi_wilayah": _propinsiWilayah.text,
            "no_kab_wilayah": _noKabWilayah.text,
            "kota_wilayah": _kotaWilayah.text,
          }),
        );

        if (request.statusCode == 200) {
          submitted = false;
          hapusLoader();
          pesanData(json.decode(request.body)['message']);
          Get.back(result: json.decode(request.body)['status']);
        } else {
          submitted = false;
          hapusLoader();
          errorPesan(json.decode(request.body)['message']);
        }
      } else {
        final request = await http.put(
          Uri.parse("${ApiStatus.baseUrl}/api/pengguna"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "key": baseKey,
            "uidKey": userUid,
            "hpKey": userHp,
            "id": _id.text,
            "id_partai": _idPartai.text,
            "id_caleg": _idCaleg.text,
            "nama": _nama.text,
            "hp": "62${_hp.text}",
            "id_akses": _idAkses.text,
            "tingkat": _tingkat.text,
            "no_prop_wilayah": _noPropWilayah.text,
            "propinsi_wilayah": _propinsiWilayah.text,
            "no_kab_wilayah": _noKabWilayah.text,
            "kota_wilayah": _kotaWilayah.text,
          }),
        );

        if (request.statusCode == 200) {
          submitted = false;
          hapusLoader();
          pesanData(json.decode(request.body)['message']);
          Get.back(result: json.decode(request.body)['status']);
        } else {
          submitted = false;
          hapusLoader();
          errorPesan(json.decode(request.body)['message']);
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

    idUser = widget.idUser;

    if (idUser > 0) {
      getUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          idUser == 0 ? "TAMBAH USER" : "EDIT USER",
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
                simpanUser();
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
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          children: [
            const SizedBox(height: 20),
            DropdownSearch<AksesModel>(
              asyncItems: (String filter) async {
                var response = await http.get(Uri.parse(
                    "${ApiStatus.baseUrl}/api/akses?key=$key&id_akses=0"));

                if (response.statusCode != 200) {
                  errorData();
                  return [];
                } else {
                  List akses = json.decode(response.body);
                  List<AksesModel> aksesList = [];

                  for (var element in akses) {
                    aksesList.add(AksesModel.fromJson(element));
                  }

                  return aksesList;
                }
              },
              popupProps: PopupProps.menu(
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(
                    '${item.akses?.toUpperCase()}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                fit: FlexFit.loose,
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "HAK AKSES",
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _idAkses.text = value?.id.toString() ?? "";
                  _akses.text = value?.akses ?? "";
                });
              },
              selectedItem: AksesModel(
                id: int.tryParse(_idAkses.text),
                akses: _akses.text,
              ),
              dropdownBuilder: (context, selectedItem) => Text(
                selectedItem?.akses?.toUpperCase() ?? "",
                style: const TextStyle(fontSize: 14),
              ),
              validator: (value) {
                if (value?.id == null) {
                  return 'Hak akses tinggal wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            if (_idAkses.text != "" && int.parse(_idAkses.text) == 4) ...[
              DropdownSearch<Map<String, dynamic>>(
                items: const [
                  {"tingkat": "NASIONAL"},
                  {"tingkat": "PROPINSI"},
                  {"tingkat": "KABUPATEN/KOTA"},
                ],
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "TINGKAT",
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _tingkat.text = value?["tingkat"] ?? "";
                  });
                },
                selectedItem: {"tingkat": _tingkat.text},
                popupProps: PopupProps.menu(
                  itemBuilder: (context, item, isSelected) => ListTile(
                    title: Text(
                      item["tingkat"],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  fit: FlexFit.loose,
                ),
                dropdownBuilder: (context, selectedItem) => Text(
                  selectedItem?["tingkat"] ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
                validator: (value) {
                  if (value?["tingkat"] == "") {
                    return 'Tingkat wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
            ],
            if (_idAkses.text != "" &&
                int.parse(_idAkses.text) == 4 &&
                (_tingkat.text == 'PROPINSI' ||
                    _tingkat.text == 'KABUPATEN/KOTA')) ...[
              DropdownSearch<PropModel>(
                asyncItems: (String filter) async {
                  var response = await http.get(
                      Uri.parse("${ApiStatus.baseUrl}/api/propinsi?key=$key"));

                  if (response.statusCode != 200) {
                    errorData();
                    return [];
                  } else {
                    List propinsi = json.decode(response.body);
                    List<PropModel> propinsiList = [];

                    for (var element in propinsi) {
                      propinsiList.add(PropModel.fromJson(element));
                    }

                    return propinsiList;
                  }
                },
                popupProps: PopupProps.dialog(
                  itemBuilder: (context, item, isSelected) => ListTile(
                    title: Text(
                      '${item.nama}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  fit: FlexFit.loose,
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "PROPINSI",
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _noPropWilayah.text = value?.noProp ?? "";
                    _propinsiWilayah.text = value?.nama ?? "";
                  });
                },
                selectedItem: PropModel(
                  noProp: _noPropWilayah.text,
                  nama: _propinsiWilayah.text,
                ),
                dropdownBuilder: (context, selectedItem) => Text(
                  selectedItem?.nama ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
                validator: (value) {
                  if (value?.noProp == "") {
                    return 'Propinsi wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
            ],
            if (_idAkses.text != "" &&
                int.parse(_idAkses.text) == 4 &&
                _tingkat.text == 'KABUPATEN/KOTA') ...[
              DropdownSearch<KabModel>(
                asyncItems: (String filter) async {
                  var response = await http.get(Uri.parse(
                      "${ApiStatus.baseUrl}/api/kota?key=$key&no_prop=${_noPropWilayah.text}"));

                  if (response.statusCode != 200) {
                    errorData();
                    return [];
                  } else {
                    List kota = json.decode(response.body);
                    List<KabModel> kotaList = [];

                    for (var element in kota) {
                      kotaList.add(KabModel.fromJson(element));
                    }

                    return kotaList;
                  }
                },
                popupProps: PopupProps.dialog(
                  itemBuilder: (context, item, isSelected) => ListTile(
                    title: Text(
                      '${item.nama}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  fit: FlexFit.loose,
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "KOTA",
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _noKabWilayah.text = value?.noKab ?? "";
                    _kotaWilayah.text = value?.nama ?? "";
                  });
                },
                selectedItem: KabModel(
                  noKab: _noKabWilayah.text,
                  nama: _kotaWilayah.text,
                ),
                dropdownBuilder: (context, selectedItem) => Text(
                  selectedItem?.nama ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
                validator: (value) {
                  if (value?.noKab == "") {
                    return 'Kota wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
            ],
            if (_idAkses.text != "" && int.parse(_idAkses.text) > 4) ...[
              DropdownSearch<CalegModel>(
                asyncItems: (String filter) async {
                  var response = await http.get(
                      Uri.parse("${ApiStatus.baseUrl}/api/caleg?key=$key"));

                  if (response.statusCode != 200) {
                    errorData();
                    return [];
                  } else {
                    List caleg = json.decode(response.body);
                    List<CalegModel> calegList = [];

                    for (var element in caleg) {
                      calegList.add(CalegModel.fromJson(element));
                    }

                    return calegList;
                  }
                },
                popupProps: PopupProps.dialog(
                  itemBuilder: (context, item, isSelected) => ListTile(
                    title: Text(
                      '${item.nama}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  fit: FlexFit.loose,
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "NAMA CALEG",
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _idCaleg.text = value?.id.toString() ?? "";
                    _caleg.text = value?.nama ?? "";
                  });
                },
                selectedItem: CalegModel(
                  id: int.tryParse(_idCaleg.text),
                  nama: _caleg.text,
                ),
                dropdownBuilder: (context, selectedItem) => Text(
                  selectedItem?.nama ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
                validator: (value) {
                  if (value?.id == null) {
                    return 'Nama caleg tinggal wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
            ],
            TextFormField(
              controller: _nama,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "NAMA LENGKAP",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
              ),
              validator: (value) {
                if (value == "") {
                  return 'Nama wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _hp,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "NOMOR HP",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
                prefix: Text("62"),
              ),
              validator: (value) {
                if (value == "") {
                  return 'Nomor HP wajib diisi';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
