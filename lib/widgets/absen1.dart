import 'dart:async';
import 'package:absensi/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Absen1 extends StatefulWidget {
  final String nomor;
  final String awal;
  final String terlambat;
  final String akhir;
  final int hour;
  const Absen1(
      {Key? key,
      required this.nomor,
      required this.awal,
      required this.akhir,
      required this.terlambat,
      required this.hour})
      : super(key: key);
  @override
  _Absen1State createState() => _Absen1State();
}

class _Absen1State extends State<Absen1> {
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
  bool pressed = false;
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
          setState(() {
            _start = Duration(seconds: seconds);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    if (isTimer) _timer!.cancel();

    super.dispose();
  }

  color(Fungsi snap) {
    // if (snap.absen1) {
    //   return MaterialStateProperty.all(Colors.green.shade200);
    // }
    if (DateTime.now().hour < widget.hour) {
      return MaterialStateProperty.all(Colors.grey.shade400);
    }
    if (DateTime.now().isAfter(
            (DateTime.parse("$year-$month-$day ${widget.terlambat}"))) &&
        DateTime.now()
            .isBefore(DateTime.parse("$year-$month-$day ${widget.akhir}"))) {
      terlambat = true;
      return MaterialStateProperty.all(Colors.amber);
    }

    if (DateTime.now()
        .isAfter(DateTime.parse("$year-$month-$day ${widget.akhir}"))) {
      return MaterialStateProperty.all(Colors.grey.shade400);
    }
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final jam = twoDigits(_start.inHours.remainder(60));
    final menit = twoDigits(_start.inMinutes.remainder(60));
    final detik = twoDigits(_start.inSeconds.remainder(60));
    print('rebuild absen${widget.nomor}');
    return Consumer<Fungsi>(builder: (context, snapshot, c) {
      late bool sudahAbsen;
      if (widget.nomor == '1') {
        sudahAbsen = snapshot.absen1;
      }
      if (widget.nomor == '2') {
        sudahAbsen = snapshot.absen2;
      }
      if (widget.nomor == '3') {
        sudahAbsen = snapshot.absen3;
      }
      return Container(
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: sudahAbsen
                  ? MaterialStateProperty.all(Colors.grey.shade100)
                  : color(snapshot),
            ),
            onPressed: pressed==false
                ? DateTime.now().hour < widget.hour ||
                        sudahAbsen == true ||
                        DateTime.now().isAfter(
                            DateTime.parse("$year-$month-$day ${widget.akhir}"))
                    ? null
                    : () async {
                        setState(() {
                          pressed = true;
                        });
                        if (DateTime.now().isAfter((DateTime.parse(
                                "$year-$month-$day ${widget.terlambat}"))) &&
                            DateTime.now().isBefore(DateTime.parse(
                                "$year-$month-$day ${widget.akhir}"))) {
                          terlambat = true;
                        }
                        Provider.of<Fungsi>(context, listen: false).absen(
                            context,
                            DateTime.parse("$year-$month-$day ${widget.awal}"),
                            widget.nomor,
                            terlambat);
                      }
                : null,
            child: Text(DateTime.now().isBefore(
                    DateTime.parse("$year-$month-$day ${widget.awal}"))
                ? '$jam : $menit : $detik'
                : sudahAbsen
                    ? 'Sudah Absen ${widget.nomor}'
                    : 'Kirim Absen ${widget.nomor}')),
      );
    });
  }
}
