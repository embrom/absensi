import 'package:absensi/login.dart';
import 'package:absensi/provider/provider.dart';
import 'package:absensi/widgets/guru_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class GuruPage extends StatefulWidget {
  const GuruPage({Key? key}) : super(key: key);

  @override
  _GuruPageState createState() => _GuruPageState();
}

class _GuruPageState extends State<GuruPage> {
  String? days(int asw) {
    if (asw == 1) return 'Monday';
    if (asw == 2) return 'TuseDay';
    if (asw == 3) return 'Wednesday';
    if (asw == 4) return 'ThursDay';
    if (asw == 5) return 'Friday';
    if (asw == 6) return 'Saturday';
    if (asw == 7) return 'SUnday';
  }

  bool pressed = false;
  String nama = '';
  List listHadir = [];
  int? pertemuan = 0;
  bool loading = true;
  int fee = 0;
  Map<String, dynamic>? data;

  @override
  void initState() {
    init();
  }

  @override
  void init() async {
    print('siswa didi');
    data = await Provider.of<Fungsi>(context, listen: false).tryAutoLogin();

    pertemuan = data!['Pertemuan'];
    nama = data!['Nama'];
    listHadir = data!['ListHadir'];
    fee = data!['Fee'];
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> list = [];
    listHadir.forEach((element) {
      list.add(element);
    });
    var devicewidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;

    print('build all');
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        leading: Image.asset('assets/download.png'),
        title: Row(
          children: [
            Text(
              nama,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
              tooltip: 'LogOut',
              onPressed: () async {
                await Provider.of<Fungsi>(context, listen: false).clearPrefs();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginSiswa()));
              },
              icon: Icon(
                Icons.logout,
                color: Colors.red,
              ))
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('guru')
                      .doc(nama)
                      .snapshots(),
                  builder: (context, snapshot) => Card(
                    child: ListTile(
                      title: Text(snapshot.data!.data()!['Nama']),
                      trailing: Text(snapshot.data!.data()!['Fee'].toString()),
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('kelas')
                      .where('Guru', arrayContains: nama)
                      .snapshots(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? LinearProgressIndicator()
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) => GuruTile(
                                      snapshot.data!.docs, index, list, data!)),
                            ),
                ),
              ],
            ),
    );
  }
}
