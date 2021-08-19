import 'package:absensi/provider/provider.dart';
import 'package:absensi/izin_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class History1 extends StatefulWidget {
  final String kelas;
  final String awal;
  final String akhir;
  final String nomor;
  final String nama;
  const History1(
      {Key? key,
      required this.kelas,
      required this.awal,
      required this.akhir,
      required this.nama,
      required this.nomor})
      : super(key: key);

  @override
  _History1State createState() => _History1State();
}

class _History1State extends State<History1> {
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
        builder: (context,
           
            snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError) {
            return Container(
              child: Card(
                color: Colors.grey.shade300,
                child: ListTile(
                  title: Text('Loading...'),
                ),
              ),
            );
          }
          if (DateTime.now().isAfter(
                      DateTime.parse("$year-$month-$day ${widget.akhir}")) &&
                  !snapshot.data!.exists ||
              snapshot.hasError) {
            return Container(
              child: Card(
                color: Colors.red,
                child: ListTile(
                  title: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey.shade200)),
                      onPressed: () async {
                        Navigator.of(
                          context,
                        ).push(MaterialPageRoute(
                          builder: (context) => IzinPage(widget.nomor),
                        ));
                      },
                      child: Text(
                        'Ajukan Izin!',
                        style: TextStyle(
                            letterSpacing: 2.5,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            );
          }
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data != null &&
              snapshot.data!.data() != null) {
            print('has data');
            if (snapshot.data!.data()!['presensi'] != 'Izin') {
              SchedulerBinding.instance!.addPostFrameCallback((_) {
                // add your code here.

                Provider.of<Fungsi>(context, listen: false)
                    .sudahAbsen(widget.nomor);
              });
            }

            return Container(
              child: Card(
                  color: color(snapshot.data!.data()!),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  child: ListTile(
                    trailing: Text(
                      snapshot.data!['waktu'],
                      style: TextStyle(color: Colors.white),
                    ),
                    title: Text(
                      // 'Jam Ke ${widget.nomor}: ' +
                      snapshot.data!.data()!['presensi'],
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            );
          }

          return Container(
              child: Card(
            color: Colors.grey,
            child: ListTile(
              title: Text('Belum'),
            ),
          ));
        });
  }
}
