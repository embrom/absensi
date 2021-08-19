import 'dart:async';
import 'dart:math';

import 'package:absensi/display_ijin.dart';
import 'package:absensi/login.dart';
import 'package:absensi/provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class WaliPage extends StatefulWidget {
  const WaliPage({Key? key}) : super(key: key);

  @override
  _WaliPageState createState() => _WaliPageState();
}

class _WaliPageState extends State<WaliPage> {
  late String kelas;
  final _random = Random();

  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pref();
  }

  pref() async {
    var pref = await SharedPreferences.getInstance();
    kelas = pref.getString('wali')!;
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,
        actions: [
          IconButton(color: Colors.red,
              onPressed: () async {
                print('logot');

                var pref = await SharedPreferences.getInstance();

                await pref.clear();

                // //  await googleSignIn.signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginSiswa(),
                ));
              },
              icon: Icon(Icons.logout_outlined))
        ],
        title: Text(loading
            ? '....'
            : kelas.toUpperCase() +
                '    ' +
                DateFormat.MMMMEEEEd().format(DateTime.now()),style: TextStyle(color: Colors.black),),
      ),
      body: (DateTime.now().weekday == DateTime.saturday ||
              DateTime.now().weekday == DateTime.sunday)
          ? Center(child: Text('Libur'))
          : loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream:
                      FirebaseFirestore.instance.collection(kelas).snapshots(),
                  builder: (context, snapshot) {
                    //   print(snapshot.data!.docs[index]data()['nama']);
                    return snapshot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: Card(
                                elevation: 5,
                                child: ListTile(
                                  isThreeLine: true,
                                  contentPadding: EdgeInsets.all(10),
                                  subtitle: StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection(kelas)
                                          .doc(
                                            snapshot.data!.docs[index]
                                                .data()['nama'],
                                          )
                                          .collection(DateFormat.MMMMEEEEd()
                                              .format(DateTime.now()))
                                          .snapshots(),
                                      builder: (context, snapshot2) {
                                        if (snapshot2.connectionState ==
                                            ConnectionState.waiting) {
                                          return SizedBox();
                                        }
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            History2(
                                              kelas: kelas,
                                              nama: snapshot.data!.docs[index]
                                                  .data()['nama'],
                                              awal: '05:00:00',
                                              akhir: '07:30:00',
                                              nomor: '1',
                                            ),
                                            History2(
                                              kelas: kelas,
                                              nama: snapshot.data!.docs[index]
                                                  .data()['nama'],
                                              awal: '09:00:00',
                                              akhir: '09:45:00',
                                              nomor: '2',
                                            ),
                                            History2(
                                              kelas: kelas,
                                              nama: snapshot.data!.docs[index]
                                                  .data()['nama'],
                                              awal: '10:00:00',
                                              nomor: '3',
                                              akhir: '12:30:00',
                                            )
                                          ],
                                        );
                                      }),
                                  trailing: Card(
                                    elevation: 3,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('TH: ' +
                                              snapshot.data!.docs[index]
                                                  .data()['totalHadir']
                                                  .toString()),
                                          Text('TT: ' +
                                              snapshot.data!.docs[index]
                                                  .data()['totalIjin']
                                                  .toString()),
                                          Text('TI: ' +
                                              snapshot.data!.docs[index]
                                                  .data()['totalTerlambat']
                                                  .toString())
                                        ],
                                      ),
                                    ),
                                  ),
                                  leading: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.primaries[
                                                  _random.nextInt(
                                                      Colors.primaries.length)]
                                              [_random.nextInt(9) * 100],
                                          child: Text(
                                            (snapshot.data!.docs[index]
                                                .data()['nama'] as String)[0],
                                            overflow: TextOverflow.fade,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Text(
                                            snapshot.data!.docs[index]
                                                .data()['nipd'],
                                            style: TextStyle(
                                              color: Colors.grey,
                                            )),
                                      ],
                                    ),
                                  ),
                                  title: Text(snapshot.data!.docs[index]
                                      .data()['nama']),
                                ),
                              ),
                            ),
                          );
                  }),
    );
  }
}

class History2 extends StatefulWidget {
  final String kelas;
  final String awal;
  final String akhir;
  final String nomor;
  final String nama;
  const History2(
      {Key? key,
      required this.kelas,
      required this.awal,
      required this.akhir,
      required this.nama,
      required this.nomor})
      : super(key: key);

  @override
  _History2State createState() => _History2State();
}

class _History2State extends State<History2> {
  Timer? _timer;
  Duration _start = Duration();
  bool isTimer = false;
  String year = DateTime.now().year.toString();
  String month = DateTime.now().month < 10
      ? 0.toString() + DateTime.now().month.toString()
      : DateTime.now().month.toString();
  String day = DateTime.now().day < 10
      ? 0.toString() + DateTime.now().day.toString()
      : DateTime.now().day.toString();
  String hour = DateTime.now().hour.toString();
  bool terlambat = false;
  @override
  void initState() {
    if (DateTime.now()
        .isBefore(DateTime.parse("$year-$month-$day ${widget.awal}"))) {
      _start = DateTime.now()
          .difference(DateTime.parse("$year-$month-$day ${widget.awal}"));
      _start = _start + -_start + -_start;
      startTimer();
    }
    super.initState();
  }

  void startTimer() {
    isTimer = true;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start.inSeconds == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          final seconds = _start.inSeconds - 1;
          _start = Duration(seconds: seconds);
          // setState(() {
          //
          // });
          print('belum stream');
        }
      },
    );
  }

  @override
  void dispose() {
    if (isTimer) _timer!.cancel();

    super.dispose();
  }

  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    print('rebuild');
    String year = DateTime.now().year.toString();
    String month = DateTime.now().month < 10
        ? 0.toString() + DateTime.now().month.toString()
        : DateTime.now().month.toString();
    String day = DateTime.now().day < 10
        ? 0.toString() + DateTime.now().day.toString()
        : DateTime.now().day.toString();

    color(Map<String, dynamic> data) {
      if (data['presensi'] == 'Hadir') {
        return Colors.green;
      }
      if (data['presensi'] == 'Terlambat') {
        return Colors.amber;
      }
      if (data['presensi'] == 'Izin') {
        return Colors.blue;
      }

      if (DateTime.now()
          .isBefore(DateTime.parse("$year-$month-$day ${widget.awal}"))) {
        return Colors.grey;
      }
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: DateTime.now()
                .isBefore(DateTime.parse("$year-$month-$day ${widget.awal}"))
            ? null
            : FirebaseFirestore.instance
                .collection(widget.kelas)
                .doc(widget.nama)
                .collection(DateFormat.MMMMEEEEd()
                    .format(DateTime.parse("$year-$month-$day ${widget.awal}")))
                .doc(widget.nomor)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError) {
            return Text('......');
          }
          if (DateTime.now().isAfter(
                      DateTime.parse("$year-$month-$day ${widget.akhir}")) &&
                  !snapshot.data!.exists ||
              snapshot.hasError) {
            return Text(
              'Bolos',
              style: TextStyle(color: Colors.red),
            );
          }
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data != null &&
              snapshot.data!.data() != null) {
            print('has data');

            return InkWell(
              onTap: snapshot.data!.data()!['presensi'] == 'Izin'
                  ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => IzinDisplay(
                            alasan: snapshot.data!.data()!['alasan'],
                            imageUrl: snapshot.data!.data()!['buktiGambar']),
                      ));
                      print('ontap');
                    }
                  : null,
              child: Text(
                // 'Jam Ke ${widget.nomor}: ' +
                snapshot.data!.data()!['presensi'],
                style: TextStyle(
                    color: color(snapshot.data!.data()!),
                    decoration: snapshot.data!.data()!['presensi'] == 'Izin'
                        ? TextDecoration.underline
                        : TextDecoration.none),
              ),
            );
          }

          return Text('Belum');
        });
  }
}
