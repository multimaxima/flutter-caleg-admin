import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:caleg_admin/model/kab.dart';
import 'package:caleg_admin/model/kec.dart';
import 'package:caleg_admin/model/kel.dart';
import 'package:caleg_admin/model/prop.dart';
import 'package:caleg_admin/page/login.dart';
import 'package:caleg_admin/page/map_kordinat.dart';
import 'package:caleg_admin/service/service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final TextEditingController _id = TextEditingController();
  final TextEditingController _partai = TextEditingController();
  final TextEditingController _caleg = TextEditingController();
  final TextEditingController _idPartai = TextEditingController();
  final TextEditingController _idCaleg = TextEditingController();
  final TextEditingController _idDistributor = TextEditingController();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _alamat = TextEditingController();
  final TextEditingController _dusun = TextEditingController();
  final TextEditingController _rt = TextEditingController();
  final TextEditingController _rw = TextEditingController();
  final TextEditingController _noProp = TextEditingController();
  final TextEditingController _noKab = TextEditingController();
  final TextEditingController _noKec = TextEditingController();
  final TextEditingController _noKel = TextEditingController();
  final TextEditingController _propinsi = TextEditingController();
  final TextEditingController _kota = TextEditingController();
  final TextEditingController _kecamatan = TextEditingController();
  final TextEditingController _desa = TextEditingController();
  final TextEditingController _kodepos = TextEditingController();
  final TextEditingController _lat = TextEditingController();
  final TextEditingController _lng = TextEditingController();
  final TextEditingController _tempLahir = TextEditingController();
  final TextEditingController _tglLahir = TextEditingController();
  final TextEditingController _tglLahir1 = TextEditingController();
  final TextEditingController _kelamin = TextEditingController();
  final TextEditingController _jenisKelamin = TextEditingController();
  final TextEditingController _hp = TextEditingController();
  final TextEditingController _uid = TextEditingController();
  final TextEditingController _nik = TextEditingController();
  final TextEditingController _ktp = TextEditingController();
  final TextEditingController _foto = TextEditingController();
  final TextEditingController _idAkses = TextEditingController();
  final TextEditingController _akses = TextEditingController();
  final TextEditingController _tingkat = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _status = TextEditingController();
  final TextEditingController _noPropWilayah = TextEditingController();
  final TextEditingController _noKabWilayah = TextEditingController();
  final TextEditingController _noKecWilayah = TextEditingController();
  final TextEditingController _noKelWilayah = TextEditingController();
  final TextEditingController _propinsiWilayah = TextEditingController();
  final TextEditingController _kotaWilayah = TextEditingController();
  final TextEditingController _kecamatanWilayah = TextEditingController();
  final TextEditingController _desaWilayah = TextEditingController();
  final TextEditingController _dusunWilayah = TextEditingController();
  final TextEditingController _rtWilayah = TextEditingController();
  final TextEditingController _rwWilayah = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool submitted = false;
  int? idAkses;
  String key = getKey();
  String baseKey = getBaseKey();
  String userUid = getUid();
  String userHp = getHp();

  File? foto;
  File? ktp;

  Position? _currentPosition;

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future logOut() async {
    await FirebaseAuth.instance
        .signOut()
        .then((value) => Get.offAll(() => const LoginPage()));
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Lokasi Tidak Aktif',
          'Service lokasi tidak aktif. Silahkan mengaktifkan service terlebih dahulu');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Lokasi Tidak Aktif', 'Izin lokasi tidak aktif');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Lokasi Tidak Aktif',
          'Izin lokasi tidak aktif secara permanen, silahkan akifkan service secara manual');
      return false;
    }
    return true;
  }

  Future getUser() async {
    loadingData();
    var result =
        await http.get(Uri.parse("${ApiStatus.baseUrl}/api/profil?key=$key"));

    if (result.statusCode == 200) {
      hapusLoader();
      var data = json.decode(result.body);

      setState(() {
        _id.text = data['id'].toString();
        _partai.text = data['partai'] ?? '';
        _caleg.text = data['caleg'] ?? '';
        _idPartai.text = data['id_partai'].toString();
        _idCaleg.text = data['id_caleg'].toString();
        _idDistributor.text = data['id_distributor'].toString();
        _nama.text = data['nama'] ?? '';
        _alamat.text = data['alamat'] ?? '';
        _dusun.text = data['dusun'] ?? '';
        _rt.text = data['rt'] ?? '';
        _rw.text = data['rw'] ?? '';
        _noProp.text = data['no_prop'] ?? '';
        _noKab.text = data['no_kab'] ?? '';
        _noKec.text = data['no_kec'] ?? '';
        _noKel.text = data['no_kel'] ?? '';
        _propinsi.text = data['propinsi'] ?? '';
        _kota.text = data['kota'] ?? '';
        _kecamatan.text = data['kecamatan'] ?? '';
        _desa.text = data['desa'] ?? '';
        _kodepos.text = data['kodepos'] ?? '';
        _lat.text = data['lat'] ?? '';
        _lng.text = data['lng'] ?? '';
        _tempLahir.text = data['temp_lahir'] ?? '';
        _tglLahir.text = data['tgl_lahir'] ?? '';
        _tglLahir1.text = _tglLahir.text != ""
            ? DateFormat("d MMMM yyyy", "id")
                .format(DateTime.parse(_tglLahir.text))
            : DateFormat("d MMMM yyyy", "id").format(DateTime.now());
        _kelamin.text = data['kelamin'].toString();
        _jenisKelamin.text = data["kelamin"] == 1
            ? 'LAKI-LAKI'
            : data["kelamin"] == 2
                ? 'PEREMPUAN'
                : '';
        _hp.text = data['hp'] ?? '';
        _uid.text = data['uid'] ?? '';
        _nik.text = data['nik'] ?? '';
        _foto.text = data['foto'] ?? '';
        _ktp.text = data['ktp'] ?? '';
        _idAkses.text = data['id_akses'].toString();
        _akses.text = data['akses'] ?? '';
        _tingkat.text = data['tingkat'] ?? '';
        _email.text = data['email'] ?? '';
        _status.text = data['status'].toString();
        _noPropWilayah.text = data['no_prop_wilayah'] ?? '';
        _noKabWilayah.text = data['no_kab_wilayah'] ?? '';
        _noKecWilayah.text = data['no_kec_wilayah'] ?? '';
        _noKelWilayah.text = data['no_kel_wilayah'] ?? '';
        _propinsiWilayah.text = data['propinsi_wilayah'] ?? '';
        _kotaWilayah.text = data['kota_wilayah'] ?? '';
        _kecamatanWilayah.text = data['kecamatan_wilayah'] ?? '';
        _desaWilayah.text = data['desa_wilayah'] ?? '';
        _dusunWilayah.text = data['dusun_wilayah'] ?? '';
        _rtWilayah.text = data['rt_wilayah'] ?? '';
        _rwWilayah.text = data['rw_wilayah'] ?? '';
      });
    } else {
      hapusLoader();
      var data = json.decode(result.body);
      errorPesan(data["message"]);
    }
  }

  Future getImage(ImageSource source, String jenis) async {
    loadingData();

    final pickedFile = await _picker.pickImage(
      maxWidth: 800,
      maxHeight: 800,
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

          if (jenis == 'Foto') {
            _foto.text = base64Encode(bytes);
            foto = file;
          }

          if (jenis == 'KTP') {
            _ktp.text = base64Encode(bytes);
            ktp = file;
          }
        } else {
          errorPesan("Tidak ada file dipilih");
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.lightGreen,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
          ],
        ),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            const SizedBox(height: 20),
            if ((idAkses ?? 0) >= 3) ...[
              Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(flex: 60),
                  1: FixedColumnWidth(30),
                  2: IntrinsicColumnWidth(flex: 100),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.top,
                children: <TableRow>[
                  TableRow(
                    children: [
                      const TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text(
                          "NAMA PARTAI",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const TableCell(
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
                          _partai.text,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text(
                          "NAMA CALEG",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const TableCell(
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
                          _caleg.text,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Text(
                          "HAK AKSES",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const TableCell(
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
                          _akses.text,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
            foto != null
                ? Image.file(
                    foto!,
                    width: 150,
                    height: 200,
                    fit: BoxFit.contain,
                  )
                : _foto.text != ""
                    ? Image.memory(
                        base64.decode(_foto.text.split(',').last),
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
                                getImage(ImageSource.camera, 'Foto');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text("Ambil File Dari Gallery"),
                              onTap: () {
                                Navigator.of(context).pop();
                                getImage(ImageSource.gallery, 'Foto');
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
                label: const Text("UNGGAH FOTO"),
              ),
            ),
            Visibility(
              visible: false,
              maintainState: true,
              child: TextFormField(
                controller: _foto,
                validator: (value) {
                  if (value == "") {
                    return "Error";
                  }
                  return null;
                },
              ),
            ),
            if (_foto.text == '')
              const Center(
                child: Text(
                  "FOTO WAJIB DIISI",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            const SizedBox(height: 25),
            TextFormField(
              controller: _nama,
              style: const TextStyle(fontSize: 14),
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: "NAMA LENGKAP",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
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
              controller: _alamat,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "ALAMAT",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value == "") {
                  return 'Alamat wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _dusun,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "DUSUN/LINGKUNGAN",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 5),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rt,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        labelText: "RT",
                        labelStyle: TextStyle(fontSize: 14),
                        contentPadding: EdgeInsets.all(10),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == "") {
                          return 'RT wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: _rw,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        labelText: "RW",
                        labelStyle: TextStyle(fontSize: 14),
                        contentPadding: EdgeInsets.all(10),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == "") {
                          return 'RW wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
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
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                fit: FlexFit.loose,
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "PROPINSI",
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _noProp.text = value?.noProp ?? "";
                  _propinsi.text = value?.nama ?? "";
                });
              },
              selectedItem: PropModel(
                noProp: _noProp.text,
                nama: _propinsi.text,
              ),
              dropdownBuilder: (context, selectedItem) => Text(
                selectedItem?.nama ?? "",
                style: const TextStyle(fontSize: 14),
              ),
              validator: (value) {
                if (value?.noProp == "") {
                  return 'Propinsi tempat tinggal wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            DropdownSearch<KabModel>(
              asyncItems: (String filter) async {
                var response = await http.get(Uri.parse(
                    "${ApiStatus.baseUrl}/api/kota?key=$key&no_prop=${_noProp.text}"));

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
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                fit: FlexFit.loose,
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "KOTA",
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _noKab.text = value?.noKab ?? "";
                  _kota.text = value?.nama ?? "";
                });
              },
              selectedItem: KabModel(
                noKab: _noKab.text,
                nama: _kota.text,
              ),
              dropdownBuilder: (context, selectedItem) => Text(
                selectedItem?.nama ?? "",
                style: const TextStyle(fontSize: 14),
              ),
              validator: (value) {
                if (value?.noKab == "") {
                  return 'Kota tempat tinggal wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            DropdownSearch<KecModel>(
              asyncItems: (String filter) async {
                var response = await http.get(Uri.parse(
                    "${ApiStatus.baseUrl}/api/kecamatan?key=$key&no_prop=${_noProp.text}&no_kab=${_noKab.text}"));

                if (response.statusCode != 200) {
                  errorData();
                  return [];
                } else {
                  List kecamatan = json.decode(response.body);
                  List<KecModel> kecamatanList = [];

                  for (var element in kecamatan) {
                    kecamatanList.add(KecModel.fromJson(element));
                  }

                  return kecamatanList;
                }
              },
              popupProps: PopupProps.dialog(
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(
                    '${item.nama?.toUpperCase()}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                fit: FlexFit.loose,
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "KECAMATAN",
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _noKec.text = value?.noKec ?? "";
                  _kecamatan.text = value?.nama?.toUpperCase() ?? "";
                });
              },
              selectedItem: KecModel(
                noKec: _noKec.text,
                nama: _kecamatan.text,
              ),
              dropdownBuilder: (context, selectedItem) => Text(
                selectedItem?.nama ?? "",
                style: const TextStyle(fontSize: 14),
              ),
              validator: (value) {
                if (value?.noKec == "") {
                  return 'Kecamatan tempat tinggal wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            DropdownSearch<KelModel>(
              asyncItems: (String filter) async {
                var response = await http.get(Uri.parse(
                    "${ApiStatus.baseUrl}/api/desa?key=$key&no_prop=${_noProp.text}&no_kab=${_noKab.text}&no_kec=${_noKec.text}"));

                if (response.statusCode != 200) {
                  errorData();
                  return [];
                } else {
                  List desa = json.decode(response.body);
                  List<KelModel> desaList = [];

                  for (var element in desa) {
                    desaList.add(KelModel.fromJson(element));
                  }

                  return desaList;
                }
              },
              popupProps: PopupProps.dialog(
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(
                    '${item.nama?.toUpperCase()}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                fit: FlexFit.loose,
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "DESA/KELURAHAN",
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _noKel.text = value?.noKel ?? "";
                  _desa.text = value?.nama?.toUpperCase() ?? "";
                });
              },
              selectedItem: KelModel(
                noKel: _noKel.text,
                nama: _desa.text,
              ),
              dropdownBuilder: (context, selectedItem) => Text(
                selectedItem?.nama ?? "",
                style: const TextStyle(fontSize: 14),
              ),
              validator: (value) {
                if (value?.noKel == "") {
                  return 'Desa/Kelurahan tempat tinggal wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _kodepos,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "KODEPOS",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _lat,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "GARIS LINTANG",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
              ),
              enabled: false,
              validator: (value) {
                if (value == "") {
                  return 'Garis Lintang wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _lng,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "GARIS BUJUR",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
              ),
              enabled: false,
              validator: (value) {
                if (value == "") {
                  return 'Garis Bujur wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            _lat.text == ""
                ? SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      label: const Text('ISI KORDINAT OTOMATIS'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      icon: const Icon(
                        Icons.location_pin,
                        size: 18,
                      ),
                      onPressed: () async {
                        loadingData();
                        await _getCurrentPosition().then(
                          (value) => {
                            _lat.text =
                                _currentPosition?.latitude.toString() ?? "",
                            _lng.text =
                                _currentPosition?.longitude.toString() ?? "",
                          },
                        );
                        hapusLoader();
                      },
                    ),
                  )
                : SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      label: const Text('KOORDINAT RUMAH'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      icon: const Icon(
                        Icons.location_pin,
                        size: 18,
                      ),
                      onPressed: () async {
                        LatLng kordinat;
                        kordinat = LatLng(
                            double.parse(_lat.text), double.parse(_lng.text));
                        final result =
                            await Get.to(() => MapKordinat(kordinat));

                        setState(() {
                          if (result != null) {
                            _lat.text = result.latitude.toString();
                            _lng.text = result.longitude.toString();
                          }
                        });
                      },
                    ),
                  ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _tempLahir,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "TEMPAT LAHIR",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value == "") {
                  return 'Tempat lahir wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "TANGGAL LAHIR",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
                suffixIcon: Icon(Icons.calendar_month),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value == "") {
                  return 'Tanggal lahir wajib diisi';
                }
                return null;
              },
              controller: _tglLahir1,
              autocorrect: false,
              readOnly: true,
              style: const TextStyle(fontSize: 14),
              onTap: () async {
                DateTime? newDateLahir = await showDatePicker(
                  context: context,
                  initialDate: _tglLahir.text != ""
                      ? DateTime.parse(_tglLahir.text)
                      : DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );

                if (newDateLahir != null) {
                  setState(() {
                    _tglLahir.text =
                        DateFormat("yyyy-MM-dd").format(newDateLahir);
                    _tglLahir1.text =
                        DateFormat("d MMMM yyyy", "id").format(newDateLahir);
                  });
                }
              },
            ),
            if (_tglLahir.text == '') const Text("Tanggal lahir wajib diisi"),
            Visibility(
              visible: false,
              maintainState: true,
              child: TextFormField(
                controller: _tglLahir,
                validator: (value) {
                  if (value == "") {
                    return "Error";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 5),
            DropdownSearch<Map<String, dynamic>>(
              items: const [
                {"id": 1, "kelamin": "LAKI-LAKI"},
                {"id": 2, "kelamin": "PEREMPUAN"},
              ],
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "JENIS KELAMIN",
                  labelStyle: TextStyle(fontSize: 14),
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _kelamin.text = value?["id"].toString() as String;
                  _jenisKelamin.text = value?["kelamin"] ?? "";
                });
              },
              selectedItem: {
                "id": _kelamin.text,
                "kelamin": _jenisKelamin.text
              },
              popupProps: PopupProps.menu(
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(
                    item["kelamin"],
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                fit: FlexFit.loose,
              ),
              dropdownBuilder: (context, selectedItem) => Text(
                selectedItem?["kelamin"] ?? "",
                style: const TextStyle(fontSize: 14),
              ),
              validator: (value) {
                if (value?["id"] == "") {
                  return 'Jenis kelamin wajib diisi';
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
                fillColor: Colors.white,
                filled: true,
              ),
              enabled: false,
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _nik,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "NOMOR INDUK KEPENDUDUKAN",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value == "") {
                  return 'NIK wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: "EMAIL",
                labelStyle: TextStyle(fontSize: 14),
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value == "") {
                  return 'Email wajib diisi';
                }
                return null;
              },
            ),
            if ((idAkses ?? 0) >= 2) ...[
              const SizedBox(height: 5),
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
                    labelText: "PROPINSI AREA",
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(10),
                    fillColor: Colors.white,
                    filled: true,
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
              ),
              const SizedBox(height: 15),
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
                    labelText: "KOTA AREA",
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(10),
                    fillColor: Colors.white,
                    filled: true,
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
              ),
              const SizedBox(height: 5),
              DropdownSearch<KecModel>(
                asyncItems: (String filter) async {
                  var response = await http.get(Uri.parse(
                      "${ApiStatus.baseUrl}/api/kecamatan?key=$key&no_prop=${_noPropWilayah.text}&no_kab=${_noKabWilayah.text}"));

                  if (response.statusCode != 200) {
                    errorData();
                    return [];
                  } else {
                    List kecamatan = json.decode(response.body);
                    List<KecModel> kecamatanList = [];

                    for (var element in kecamatan) {
                      kecamatanList.add(KecModel.fromJson(element));
                    }

                    return kecamatanList;
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
                    labelText: "KECAMATAN AREA",
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(10),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _noKecWilayah.text = value?.noKec ?? "";
                    _kecamatanWilayah.text = value?.nama?.toUpperCase() ?? "";
                  });
                },
                selectedItem: KecModel(
                  noKec: _noKecWilayah.text,
                  nama: _kecamatanWilayah.text,
                ),
                dropdownBuilder: (context, selectedItem) => Text(
                  selectedItem?.nama?.toUpperCase() ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 5),
              DropdownSearch<KelModel>(
                asyncItems: (String filter) async {
                  var response = await http.get(Uri.parse(
                      "${ApiStatus.baseUrl}/api/desa?key=$key&no_prop=${_noPropWilayah.text}&no_kab=${_noKabWilayah.text}&no_kec=${_noKecWilayah.text}"));

                  if (response.statusCode != 200) {
                    errorData();
                    return [];
                  } else {
                    List desa = json.decode(response.body);
                    List<KelModel> desaList = [];

                    for (var element in desa) {
                      desaList.add(KelModel.fromJson(element));
                    }

                    return desaList;
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
                    labelText: "DESA/KELURAHAN AREA",
                    labelStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(10),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _noKelWilayah.text = value?.noKel ?? "";
                    _desaWilayah.text = value?.nama?.toUpperCase() ?? "";
                  });
                },
                selectedItem: KelModel(
                  noKel: _noKelWilayah.text,
                  nama: _desaWilayah.text,
                ),
                dropdownBuilder: (context, selectedItem) => Text(
                  selectedItem?.nama?.toUpperCase() ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
            const SizedBox(height: 15),
            const Text(
              "KARTU TANDA PENDUDUK",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            ktp != null
                ? Image.file(
                    ktp!,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  )
                : _ktp.text != ""
                    ? Image.memory(
                        base64.decode(_ktp.text.split(',').last),
                        fit: BoxFit.contain,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Text('Loading foto...');
                        },
                      )
                    : Image.asset(
                        'assets/images/ktp.jpg',
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
            const SizedBox(height: 5),
            SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
                                getImage(ImageSource.camera, 'KTP');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text("Ambil File Dari Gallery"),
                              onTap: () {
                                Navigator.of(context).pop();
                                getImage(ImageSource.gallery, 'KTP');
                              },
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.upload),
                label: const Text("UNGGAH DOKUMEN"),
              ),
            ),
            Visibility(
              visible: false,
              maintainState: true,
              child: TextFormField(
                controller: _ktp,
                validator: (value) {
                  if (value == "") {
                    return "Error";
                  }
                  return null;
                },
              ),
            ),
            if (_ktp.text == '')
              const Center(
                child: Text(
                  "KTP WAJIB DIISI",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            submitted == false) {
                          submitted = true;
                          loadingData();

                          var request = await http.post(
                            Uri.parse("${ApiStatus.baseUrl}/api/profil"),
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
                              "alamat": _alamat.text,
                              "dusun": _dusun.text,
                              "rt": _rt.text,
                              "rw": _rw.text,
                              "no_prop": _noProp.text,
                              "no_kab": _noKab.text,
                              "no_kec": _noKec.text,
                              "no_kel": _noKel.text,
                              "propinsi": _propinsi.text,
                              "kota": _kota.text,
                              "kecamatan": _kecamatan.text,
                              "desa": _desa.text,
                              "kodepos": _kodepos.text,
                              "lat": _lat.text,
                              "lng": _lng.text,
                              "temp_lahir": _tempLahir.text,
                              "tgl_lahir": _tglLahir.text,
                              "kelamin": _kelamin.text,
                              "nik": _nik.text,
                              "email": _email.text,
                              "no_prop_wilayah": _noPropWilayah.text,
                              "no_kab_wilayah": _noKabWilayah.text,
                              "no_kec_wilayah": _noKecWilayah.text,
                              "no_kel_wilayah": _noKelWilayah.text,
                              "dusun_wilayah": _dusunWilayah.text,
                              "rw_wilayah": _rtWilayah.text,
                              "rt_wilayah": _rwWilayah.text,
                              "propinsi_wilayah": _propinsiWilayah.text,
                              "kota_wilayah": _kotaWilayah.text,
                              "kecamatan_wilayah": _kecamatanWilayah.text,
                              "desa_wilayah": _desaWilayah.text,
                              "foto": _foto.text,
                              "ktp": _ktp.text,
                            }),
                          );

                          if (request.statusCode == 200) {
                            submitted = false;
                            hapusLoader();
                            pesanData('Profil berhasil disimpan');
                          } else {
                            var data = await json.decode(request.body);
                            submitted = false;
                            hapusLoader();
                            errorPesan(data['message']);
                          }
                        } else {
                          hapusLoader();
                          errorPesan("DATA BELUM LENGKAP");
                        }
                      },
                      icon: const Icon(
                        Icons.save,
                        size: 35,
                        color: Colors.blue,
                      ),
                    ),
                    const Text(
                      "SIMPAN",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            content:
                                const Text('Yakin akan menghapus akun Anda ?'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  var response = await http.get(Uri.parse(
                                      "${ApiStatus.baseUrl}/api/hapus-akun?key=$key"));

                                  if (response.statusCode == 200) {
                                    logOut();
                                    Get.back();
                                  } else {
                                    errorData();
                                    Get.back();
                                  }
                                },
                                child: const Text("YA"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text("BATAL"),
                              )
                            ],
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        size: 35,
                        color: Colors.red,
                      ),
                    ),
                    const Text(
                      "HAPUS AKUN",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            content: const Text("Keluar dari aplikasi ?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  logOut();
                                },
                                child: const Text("YA"),
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
                      icon: const Icon(
                        Icons.exit_to_app,
                        size: 35,
                        color: Colors.teal,
                      ),
                    ),
                    const Text(
                      "LOGOUT",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
