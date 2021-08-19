
import 'package:absensi/login.dart';
import 'package:absensi/provider/provider.dart';
import 'package:absensi/widgets/absen1.dart';
import 'package:absensi/widgets/history_todat.dart';
import 'package:absensi/widgets/image_button.dart';
import 'package:absensi/widgets/location_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SiswaPage extends StatefulWidget {
  const SiswaPage({Key? key}) : super(key: key);

  @override
  _SiswaPageState createState() => _SiswaPageState();
}

class _SiswaPageState extends State<SiswaPage>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  String year = DateTime.now().year.toString();
  String month = DateTime.now().month < 10
      ? 0.toString() + DateTime.now().month.toString()
      : DateTime.now().month.toString();
  String day = DateTime.now().day < 10
      ? 0.toString() + DateTime.now().day.toString()
      : DateTime.now().day.toString();
  String hour = DateTime.now().hour.toString();

  String? nama;
  String? kelas;
  bool loading = true;
  @override
  void initState() {
    print('init siswa');
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    print('siswa didi');
    var data = await Provider.of<Fungsi>(context, listen: false).tryAutoLogin();
    nama = data['nama'];
    kelas = data['kelas'];
    setState(() {
      loading = false;
    });
    
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var devicewidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;

    Widget info() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: devicewidth * 0.2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bolos'),
                      CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Hadir'),
                      CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                width: devicewidth * 0.2,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Belum'),
                        CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.grey,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Izin'),
                        CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                )),
            Container(
              width: devicewidth * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Terlambat'),
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: Colors.amber,
                  ),
                ],
              ),
            ),
          ],
        );
    print('build all');
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Image.asset('assets/download.png'),
        title: Text(
          'Smanig Absensi',
          style: TextStyle(color: Colors.black),
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
      body: (DateTime.now().weekday == DateTime.saturday ||
              DateTime.now().weekday == DateTime.sunday)
          ? Center(child: Text('Libur'))
          : loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer<Fungsi>(builder: (context, snapshots, c) {
                        // kelas = snapshots.kelas!;
                        // nama = snapshots.nama!;
                        return Container(
                          width: devicewidth,
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListTile(
                                trailing: Text(
                                  snapshots.kelas!.toUpperCase(),
                                  style: TextStyle(fontSize: 20),
                                ),
                                title: Text(snapshots.nama!),
                                subtitle: Text('NIPD : ' + snapshots.nipd!),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5, top: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total Izin : " +
                                        snapshots.totalijin.toString()),
                                    Text("Total Hadir: " +
                                        snapshots.totalhadir.toString()),
                                    Text("Total Terlambat : " +
                                        snapshots.totalterlambat.toString()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      Spacer(),
                      Container(
                        color: Colors.white,
                        width: devicewidth,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10, top: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [DataButton(), ImageButton()],
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(bottom: 0),
                                margin: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Absen1(
                                      awal: '05:00:00',
                                      terlambat: '07:00:00',
                                      akhir: '07:30:00',
                                      nomor: '1',
                                      hour: 5,
                                    ),
                                    Absen1(
                                      awal: '09:00:00',
                                      terlambat: '09:15:00',
                                      hour: 9,
                                      akhir: '09:45:00',
                                      nomor: '2',
                                    ),
                                    Absen1(
                                      awal: '10:00:00',
                                      terlambat: '11:30:00',
                                      hour: 10,
                                      akhir: '12:30:00',
                                      nomor: '3',
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Spacer(),
                      Divider(
                        thickness: 1.2,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: info()),
                      Divider(
                        thickness: 1.2,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 6, top: 10),
                        child: Text(
                          DateFormat.MMMMEEEEd().format(DateTime.now()),
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      History1(
                        kelas: kelas!,
                        nama: nama!,
                        awal: '05:00:00',
                        akhir: '07:30:00',
                        nomor: '1',
                      ),
                      History1(
                        kelas: kelas!,
                        nama: nama!,
                        awal: '09:00:00',
                        akhir: '09:45:00',
                        nomor: '2',
                      ),
                      History1(
                        kelas: kelas!,
                        nama: nama!,
                        awal: '10:00:00',
                        nomor: '3',
                        akhir: '12:30:00',
                      )
                    ],
                  ),
                ),
    );
  }
}
