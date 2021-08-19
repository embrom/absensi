
import 'package:absensi/login.dart';
import 'package:absensi/siswa_page.dart';

import 'package:absensi/wali_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/provider.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await Firebase.initializeApp();

  // FirebaseFirestore.instance.settings =
  //     Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  //cameras = await availableCameras();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (ctx) => Fungsi(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  Future<bool> future() async {
    print('future');
    var pref = await SharedPreferences.getInstance();
    //pref.clear();
    if (pref.containsKey('siswa') == true || pref.containsKey('wali') == true) {
      return true;
    } else {
      return false;
    }
    
  }

  Future<bool> siswaOrWali() async {
    print('siswa or Wali');
    var pref = await SharedPreferences.getInstance();
    if (pref.containsKey('siswa')) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build Main');
    return MaterialApp(debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: GoogleFonts.nunito().fontFamily,
            primarySwatch: Colors.green,
            accentColor: Colors.green.shade200),
        title: 'Smanig Absensi',
        home: FutureBuilder(
            future: future(),
            builder: (context, snapshot) {
              return snapshot.data == true
                  ? FutureBuilder<bool>(
                      future: siswaOrWali(),
                      builder: (context, snapshots) =>
                          snapshots.data == true ? SiswaPage() : WaliPage(),
                    )
                  : LoginSiswa();
            }));
  }
}
