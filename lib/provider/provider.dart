import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'data_nipd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Fungsi extends ChangeNotifier {
  bool absen1 = false;
  bool absen2 = false;
  bool absen3 = false;

  String? nipd;
  String? kelas;
  double latitude = 0;
  String? nama;
  double atitude = 0;
  String imagePath = '';
  int totalhadir = 0;

  int totalterlambat = 0;
  int totalijin = 0;
  Future ijin(BuildContext context, String nomor, String alasan,
      {File? buktiFoto, dynamic blob}) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 10000),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sending.....'),
          ],
        )));
    var ref = FirebaseStorage.instance
        .ref()
        .child(kelas!)
        .child(nama!)
        .child(DateTime.now().millisecond.toString() + '.jpg');

    if (!kIsWeb) await ref.putFile(buktiFoto!);
    if (kIsWeb) await ref.putBlob(blob);
    var imageUrl = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection(kelas!)
        .doc(nama)
        .collection(DateFormat.MMMMEEEEd().format(DateTime.now()))
        .doc(nomor)
        .set({
      'presensi': 'Izin',
      'buktiGambar': imageUrl,
      'alasan': alasan,
      'waktu': DateFormat.Hm().format(DateTime.now())
    });
    await FirebaseFirestore.instance.collection(kelas!).doc(nama).update({
      'totalIjin': totalijin + 1,
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    totalijin++;
    notifyListeners();
  }

  inputLocation(double a, double b) {
    latitude = a;
    atitude = b;
    notifyListeners();
  }

  inputPhoto(String path) {
    imagePath = path;
    notifyListeners();
  }

  sudahAbsen(String a) {
    print('tanda sudah absen');
    if (a == '1') {
      absen1 = true;
    }
    if (a == '2') {
      absen2 = true;
    }
    if (a == '3') {
      absen3 = true;
    }
    notifyListeners();
  }

  absen(BuildContext context, DateTime datetime, String nomor,
      bool terlambat) async {
    try {
      if (latitude == 0 || atitude == 0 || imagePath == '') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Text('Tolong Lengkapi')));
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 10000),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Sending.....'), CircularProgressIndicator()],
          )));

      await FirebaseFirestore.instance
          .collection(kelas!)
          .doc(nama)
          .collection(DateFormat.MMMMEEEEd().format(DateTime.now()))
          .doc(nomor)
          .set({
        'presensi': terlambat ? 'Terlambat' : 'Hadir',
        'longitude': atitude,
        'latitude': latitude,
        'waktu': DateFormat.Hm().format(DateTime.now())
      });
      await FirebaseFirestore.instance
          .collection(kelas!)
          .doc(nama)
          .update(terlambat
              ? {'totalTerlambat': totalterlambat + 1}
              : {
                  'totalHadir': totalhadir + 1,
                });
      ScaffoldMessenger.of(context).clearSnackBars();
      latitude = 0;
      atitude = 0;
      imagePath = '';
      terlambat ? totalterlambat++ : totalhadir++;
      sudahAbsen(nomor);
      notifyListeners();
    } catch (c) {
      print(c);
      return;
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signIn(BuildContext context, bool siswa, String nipd) async {
    try {
      if (siswa) {
        if (nipd == '') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: Text('Mohon Lengkapi')));
          return false;
        }

        if (DATA_NIPD.every((element) => element['NIPD'] != nipd)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: Text('NIPD Tidak Terdaftar')));
          return false;
        }
        Map<String, String> dataUser;
        dataUser = DATA_NIPD.firstWhere((element) => element['NIPD'] == nipd);
        kelas = dataUser['Kelas']!;
        nama = dataUser['Nama']!;
      }
      if (!siswa) {
        if (DATA_NIPD.every((element) => element['Kelas'] != nipd)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: Text('Kode Salah')));
          return false;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 10000),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Loading.....'),
            ],
          )));

      await _auth.signInAnonymously();

      var pref = await SharedPreferences.getInstance();
      var dataSiswa = json.encode({'kelas': kelas, 'nipd': nipd, 'nama': nama});
      await pref.setString(siswa ? 'siswa' : 'wali', siswa ? dataSiswa : nipd);
      if (siswa) {
        var checkData =
            await FirebaseFirestore.instance.collection(kelas!).doc(nama).get();
        if (checkData.data() == null) {
          await FirebaseFirestore.instance.collection(kelas!).doc(nama).set({
            'nipd': nipd,
            'nama': nama,
            'totalHadir': 0,
            'totalTerlambat': 0,
            'totalIjin': 0
          });
        }
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<void> clearPrefs() async {
    var pref = await SharedPreferences.getInstance();

    pref.clear();
    //  await googleSignIn.signOut();
    await _auth.signOut();
    nipd = '';
    kelas = '';
    nama = '';
  }

  Future<Map<String, String?>> tryAutoLogin() async {
    var pref = await SharedPreferences.getInstance();
    var data = pref.getString('siswa');
    //  pref.clear();
    if (data == 'wali') {
      return {};
    } else {
      var pref = await SharedPreferences.getInstance();
      var data = pref.getString('siswa');
      var extracteData = json.decode(data!);
      nipd = extracteData['nipd'];
      nama = extracteData['nama'];
      kelas = extracteData['kelas'];
      var myData =
          await FirebaseFirestore.instance.collection(kelas!).doc(nama).get();
      totalhadir = myData['totalHadir'];
      totalijin = myData['totalIjin'];
      totalterlambat = myData['totalTerlambat'];
      notifyListeners();
      return {'nipd': nipd, 'kelas': kelas, 'nama': nama};
    }
  }
}
