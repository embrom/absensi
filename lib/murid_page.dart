import 'package:absensi/login.dart';
import 'package:absensi/provider/provider.dart';
import 'package:absensi/widgets/admin_tile.dart';
import 'package:absensi/widgets/guru_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class MuridPage extends StatefulWidget {
  const MuridPage({Key? key}) : super(key: key);

  @override
  _MuridPageState createState() => _MuridPageState();
}

class _MuridPageState extends State<MuridPage> {
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

  bool loading = true;

  Map<String, dynamic>? data;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    print('siswa didi');
    data = await Provider.of<Fungsi>(context, listen: false).tryAutoLogin();

    // pertemuan = data!['Pertemuan'];
    nama = data!['Nama'];
    listHadir = data!['ListHadir'];
    //  fee = data!['Fee'];
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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        leading: CircleAvatar(radius: 16,child: Image.asset('assets/download.png')),
        title: Row(
          children: [
            Text(
              nama,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('kelas')
                      .where('Murid', arrayContains: nama)
                      .snapshots(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? LinearProgressIndicator()
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) => Siswa(
                                      snapshot.data!.docs, index, list, data!)),
                            ),
                ),
                Expanded(
                  child: Card(elevation: 17,
                                      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('murid')
                          .doc(nama)
                          .snapshots(),
                      builder: (context, snapshot) => snapshot.connectionState==ConnectionState.waiting?LinearProgressIndicator(): Card(
                          child: ListView.builder(
                        itemCount: snapshot.data!.data()!['ListHadir'].length,
                        itemBuilder: (context, index) => ListTile(
                          tileColor: Colors.green,
                          title: Text(snapshot.data!.data()!['ListHadir'][index]),
                        ),
                      )),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
