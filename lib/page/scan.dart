import 'dart:convert';
import 'dart:io';

import 'package:caleg_admin/page/scan_home.dart';
import 'package:caleg_admin/service/service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mnc_identifier_ocr/mnc_identifier_ocr.dart';
import 'package:mnc_identifier_ocr/model/ocr_result_model.dart';
import 'package:caleg_admin/model/scanner_provider.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  OcrResultModel? result;
  final _formKey = GlobalKey<FormState>();
  bool submitted = false;
  Position? _currentPosition;
  final ImagePicker _picker = ImagePicker();
  String key = getKey();

  int idUser = 0;
  int idAkses = 0;
  int idCaleg = 0;

  File? foto;

  FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController _isSuccess = TextEditingController();
  final TextEditingController _errorMessage = TextEditingController();
  final TextEditingController _imagePath = TextEditingController();
  final TextEditingController _nik = TextEditingController();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _tempatLahir = TextEditingController();
  final TextEditingController _tglLahir = TextEditingController();
  final TextEditingController _jenisKelamin = TextEditingController();
  final TextEditingController _alamat = TextEditingController();
  final TextEditingController _rt = TextEditingController();
  final TextEditingController _rw = TextEditingController();
  final TextEditingController _kelurahan = TextEditingController();
  final TextEditingController _kecamatan = TextEditingController();
  final TextEditingController _kota = TextEditingController();
  final TextEditingController _propinsi = TextEditingController();
  final TextEditingController _agama = TextEditingController();
  final TextEditingController _kawin = TextEditingController();
  final TextEditingController _pekerjaan = TextEditingController();
  final TextEditingController _wni = TextEditingController();
  final TextEditingController _lat = TextEditingController();
  final TextEditingController _lng = TextEditingController();
  final TextEditingController _foto = TextEditingController();

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

  Future<void> scanKtp() async {
    OcrResultModel? res;

    try {
      res = await MncIdentifierOcr.startCaptureKtp(
        // withFlash: true,
        cameraOnly: true,
      );
    } catch (e) {
      errorPesan('Terjadi kesalahan, silahkan ulangi kembali');
    }

    if (!mounted) return;

    setState(() {
      result = res;
      _isSuccess.text = result?.isSuccess.toString() ?? "";
      _errorMessage.text = result?.errorMessage.toString() ?? "";
      _imagePath.text = result?.imagePath.toString() ?? "";
      _nik.text = result?.ktp?.nik ?? "";
      _nama.text = result?.ktp?.nama ?? "";
      _tempatLahir.text = result?.ktp?.tempatLahir ?? "";
      _tglLahir.text = result?.ktp?.tglLahir ?? "";
      _jenisKelamin.text = result?.ktp?.jenisKelamin ?? "";
      _alamat.text = result?.ktp?.alamat ?? "";
      _rt.text = result?.ktp?.rt ?? "";
      _rw.text = result?.ktp?.rw ?? "";
      _kelurahan.text = result?.ktp?.kelurahan ?? "";
      _kecamatan.text = result?.ktp?.kecamatan ?? "";
      _kota.text = result?.ktp?.kabKot ?? "";
      _propinsi.text = result?.ktp?.provinsi ?? "";
      _agama.text = result?.ktp?.agama ?? "";
      _kawin.text = result?.ktp?.statusPerkawinan ?? "";
      _pekerjaan.text = result?.ktp?.pekerjaan ?? "";
      _wni.text = result?.ktp?.kewarganegaraan ?? "";
    });
  }

  Future getFoto() async {
    loadingData();
    try {
      final gambar = await _picker.pickImage(
        maxHeight: 800,
        maxWidth: 800,
        source: ImageSource.camera,
      );
      if (gambar == null) {
        hapusLoader();
        return;
      }

      final gambarPicked = File(gambar.path);
      hapusLoader();

      setState(() {
        _foto.text = gambarPicked.toString();
        foto = gambarPicked;
      });
    } on PlatformException catch (e) {
      hapusLoader();
      errorPesan("Error waktu mengambil gambar :$e");
    }
  }

  getUser() async {
    loadingData();
    var result = await http
        .get(Uri.parse("${ApiStatus.baseUrl}/api/get-user-detil?key=$key"));

    if (result.statusCode == 200) {
      hapusLoader();
      var data = json.decode(result.body);

      setState(() {
        idUser = data['id'];
        idAkses = data['id_akses'];
        idCaleg = data['id_caleg'];
      });
    } else {
      hapusLoader();
      var data = json.decode(result.body);
      errorPesan(data["message"]);
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScannerProvider(),
      child: ScanerKtp(),
    );
  }
}
