import 'package:absensi/create_class.dart';
import 'package:absensi/login.dart';
import 'package:absensi/provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String newGuru = '';
  String newMurid = '';
  String? nama;

  bool loading = true;
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void init() async {
    print('siswa didi');
    Map<String, dynamic>? data =
        await Provider.of<Fungsi>(context, listen: false).tryAutoLogin();

    setState(() {
      loading = false;
    });

    ;
  }

  String? days(int asw) {
    if (asw == 1) return 'Monday';
    if (asw == 2) return 'TuseDay';
    if (asw == 3) return 'Wednesday';
    if (asw == 4) return 'ThursDay';
    if (asw == 5) return 'Friday';
    if (asw == 6) return 'Saturday';
    if (asw == 7) return 'SUnday';
  }

  void bottom(bool guru) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(children: [
        TextFormField(
          onChanged: (v) {
            setState(() {
              guru ? newGuru = v : newMurid = v;
            });
          },
        ),
        ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection(guru ? 'guru' : 'murid')
                  .doc(guru ? newGuru : newMurid)
                  .set({});
              Navigator.of(context).pop();
            },
            child: Text('Confirm'))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    var devicewidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;

    print('build all');
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
              child: Text('NewGuru'),
              onPressed: () {
                bottom(true);
              }),
          ElevatedButton(
            child: Text('NewMurid'),
            onPressed: () async {
              bottom(false);
            },
          ),
          ElevatedButton(
            child: Text('NewClass'),
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateClass(),
              ));
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        leading: Image.asset('assets/download.png'),
        title: Text(
          'Admin',
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
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance.collection('kelas').snapshots(),
              builder: (context, snapshot) => ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => snapshot.connectionState==ConnectionState.waiting?CircularProgressIndicator(): Card(
                  child: Column(
                    children: [
                      ListTile(
                          trailing: SizedBox(
                            height: 50,
                            width: 100,
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs[index]
                                  .data()['Guru']
                                  .length,
                              itemBuilder: (context, index0) => Text(
                                  snapshot.data!.docs[index].data()['Guru']
                                      [index0]),
                            ),
                          ),
                          subtitle: SizedBox(
                            height: 50,
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs[index]
                                  .data()['Murid']
                                  .length,
                              itemBuilder: (context, index1) => Text(
                                  snapshot.data!.docs[index].data()['Murid']
                                      [index1]),
                            ),
                          ),
                          leading: Text(snapshot.data!.docs[index]
                              .data()['Pertemuan']
                              .toString()),
                          title: Text(
                            snapshot.data!.docs[index].data()['NamaKelas'],
                          )),
                      SizedBox(
                        width: devicewidth,
                        height: 50,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                snapshot.data!.docs[index].data()['Day'].length,
                            itemBuilder: (context, index3) =>
                                snapshot.data!.docs[index].data()['Day']
                                            [index3] !=
                                        0
                                    ? Text(
                                        days(snapshot.data!.docs[index]
                                                .data()['Day'][index3])! +
                                            ' ' +
                                            snapshot.data!.docs[index]
                                                .data()['Jam'][index3]
                                                .toString()
                                                .toString() +
                                            ' ' +
                                            snapshot.data!.docs[index]
                                                .data()['Menit'][index3]
                                                .toString() +
                                            ' ||    ',
                                      )
                                    : SizedBox()),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          onPressed: () async {
                         await   FirebaseFirestore.instance
                                .collection('kelas')
                                .doc(snapshot.data!.docs[index].id)
                                .delete();
                          },
                          child: Text('Delete'))
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
