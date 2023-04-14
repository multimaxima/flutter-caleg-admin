import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ApiStatus {
  static String baseUrl = 'https://calegapi.multimaxima.com';
}

getBaseKey() {
  return 'A4TwnRH9AKdDGaC9pObFxZ0tv1jxu5isL0nqfElkkEM6C3xx85lkIU9WkzoqxGoA96JoBoAQGrU8GErnd2U1QDgf14r5WGAvd8pjfwjc14NPeUarS4Y2ZhNw6uJ30yKptYKdbL8eVVlqzoiD8lCASrioJPLtVF11TequCyFYfsEqUrLhkXdJK3TjDc48Cs0eQ2u8UUrR12Mk6fdmlQRFWo82fo1n9pbmMJYNOyqfUeqA0QVS6Mx5JoDLI5GTUjlg';
}

getKey() {
  FirebaseAuth auth = FirebaseAuth.instance;
  return 'A4TwnRH9AKdDGaC9pObFxZ0tv1jxu5isL0nqfElkkEM6C3xx85lkIU9WkzoqxGoA96JoBoAQGrU8GErnd2U1QDgf14r5WGAvd8pjfwjc14NPeUarS4Y2ZhNw6uJ30yKptYKdbL8eVVlqzoiD8lCASrioJPLtVF11TequCyFYfsEqUrLhkXdJK3TjDc48Cs0eQ2u8UUrR12Mk6fdmlQRFWo82fo1n9pbmMJYNOyqfUeqA0QVS6Mx5JoDLI5GTUjlg&uidKey=${auth.currentUser?.uid}&hpKey=${auth.currentUser?.phoneNumber}';
}

getUid() {
  FirebaseAuth auth = FirebaseAuth.instance;
  return auth.currentUser?.uid;
}

getHp() {
  FirebaseAuth auth = FirebaseAuth.instance;
  return auth.currentUser?.phoneNumber.toString().substring(1);
}

Future loadingData() {
  return EasyLoading.show(
    status: 'Mohon tunggu...',
    maskType: EasyLoadingMaskType.black,
  );
}

Future hapusLoader() {
  return EasyLoading.dismiss();
}

Future pesanData(String pesan) {
  return EasyLoading.showToast(pesan);
}

Future errorPesan(String pesan) {
  return EasyLoading.showError(pesan);
}

Future errorData() {
  return EasyLoading.showError(
      "Gagal mendapatkan data, silahkan ulangi kembali.");
}
