import 'package:absensi/provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({Key? key}) : super(key: key);

  @override
  _CreateClassState createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  // List<int> days = [];
  // List<int> hours = [];
  // List<int> minutes = [];
  int day1 = 0;
  int day2 = 0;
  int day3 = 0;
  int day4 = 0;
  int minute1 = 00;
  int minute2 = 00;
  int minute3 = 00;
  int minute4 = 00;
  int hour1 = 00;
  int hour2 = 00;
  int hour3 = 00;
  int hour4 = 00;
  int pertemuan = 0;
  int fee=0;
  String nameClass = '';
  List<bool> listBoolGuru = [];
  List<bool> listBoolMurid = [];
  List<String> listMurid = [];
  List<String> listGuru = [];
  List<String> selectedlistMurid = [];
  List<String> selectedlistGuru = [];
  bool loading = true;
  showTime(int asw) async {
    final newTime = await showTimePicker(
        initialEntryMode: TimePickerEntryMode.dial,
        context: context,
        initialTime: TimeOfDay(hour: 7, minute: 0));
    if (newTime == null) {
      return;
    }
    int hour = newTime.hour;
    final minute = newTime.minute;
    if (newTime.format(context).contains('PM')) {
      print(hour);
    }
    if (asw == 1) {
      hour1 = hour;
      minute1 = minute;
    }
    if (asw == 2) {
      hour2 = hour;
      minute2 = minute;
    }
    if (asw == 3) {
      hour3 = hour;
      minute4 = minute;
    }
    if (asw == 4) {
      hour4 = hour;
      minute4 = minute;
    }
    setState(() {});
  }

  @override
  void asu() async {
    QuerySnapshot<Map<String, dynamic>> gurus =
        await FirebaseFirestore.instance.collection('guru').get();
    gurus.docs.forEach((element) {
      listBoolGuru.add(false);
      listGuru.add(element.id);
    });
    QuerySnapshot<Map<String, dynamic>> murids =
        await FirebaseFirestore.instance.collection('murid').get();
    murids.docs.forEach((element) {
      listBoolMurid.add(false);
      listMurid.add(element.id);
    });
    setState(() {
      loading = false;
    });
  }

  void initState() {
    asu();
    super.initState();
  }

  createClass() async {
    await FirebaseFirestore.instance.collection('kelas').doc(nameClass).set({
      'NamaKelas': nameClass,'Fee':fee,
      'Pertemuan': pertemuan,
      "Guru": selectedlistGuru,
      "Murid": selectedlistMurid,
      'Day': [day1, day2, day3, day4],
      'Jam': [hour1, hour2, hour3, hour4],
      'Menit': [minute1, minute2, minute3, minute4]
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Container(
          width: double.infinity,
          child:
              ElevatedButton(onPressed: createClass, child: Text('Confirm'))),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        leading: Image.asset('assets/download.png'),
        title: Text(
          'Admin',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  TextFormField(
                    onChanged: (val) {
                      nameClass = val;
                    },
                    decoration: InputDecoration(hintText: 'Name Class'),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      pertemuan = int.parse(val);
                    },
                    decoration: InputDecoration(hintText: 'Pertemuan'),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      fee = int.parse(val);
                    },
                    decoration: InputDecoration(hintText: 'Fee'),
                  ),
                  Container(
                    width: width,
                    height: 250,
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) => buildTIme(index + 1),
                    ),
                  ),
                  Container(
                      width: width,
                      height: 50,
                      child: ListView.builder(
                        itemCount: listMurid.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => FilterChip(
                          selected: listBoolMurid[index],
                          onSelected: (c) {
                            if (c) {
                              selectedlistMurid.add(listMurid[index]);
                            } else {
                              selectedlistMurid.remove(listMurid[index]);
                            }
                            setState(() {
                              listBoolMurid[index] = c;
                            });
                          },
                          label: Text(listMurid[index]),
                        ),
                      )),
                  Container(
                      width: width,
                      height: 50,
                      child: ListView.builder(
                        itemCount: listGuru.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => FilterChip(
                          selected: listBoolGuru[index],
                          onSelected: (c) {
                            if (c) {
                              selectedlistGuru.add(listGuru[index]);
                            } else {
                              selectedlistGuru.remove(listGuru[index]);
                            }
                            setState(() {
                              listBoolGuru[index] = c;
                            });
                          },
                          label: Text(listGuru[index]),
                        ),
                      ))
                ]),
    );
  }

  Widget buildTIme(int asw) {
    print(asw);
    String? time() {
      if (asw == 1) {
        return hour1.toString();
      }
      if (asw == 2) {
        return hour2.toString();
      }
      if (asw == 3) {
        return hour3.toString();
      }
      if (asw == 4) {
        return hour3.toString();
      }
    }

    String? timeMinute() {
      if (asw == 1) {
        return minute1.toString();
      }
      if (asw == 2) {
        return minute2.toString();
      }
      if (asw == 3) {
        return minute3.toString();
      }
      if (asw == 4) {
        return minute4.toString();
      }
    }

    return Card(
      child: ListTile(
          title: Container(
            width: 30,
            child: TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (v) {
                if (asw == 1) {
                  day1 = int.parse(v);
                }
                if (asw == 2) {
                  day2 = int.parse(v);
                }
                if (asw == 3) {
                  day3 = int.parse(v);
                }
                if (asw == 4) {
                  day3 = int.parse(v);
                }
                setState(() {});
              },
            ),
          ),
          trailing: GestureDetector(
            onTap: () async {
              await showTime(asw);
            },
            child: Text(time()! + ' ' + timeMinute()!),
          )),
    );
  }
}
