import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Siswa extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> data;
  final int i;
  final List<String> listHadir;
  final Map<String, dynamic> mapData;
  Siswa(this.data, this.i, this.listHadir, this.mapData);

  @override
  _SiswaState createState() => _SiswaState();
}

class _SiswaState extends State<Siswa> {
  bool pressed = false;
  String? days(int asw) {
    if (asw == 1) return 'Monday';
    if (asw == 2) return 'TuseDay';
    if (asw == 3) return 'Wednesday';
    if (asw == 4) return 'ThursDay';
    if (asw == 5) return 'Friday';
    if (asw == 6) return 'Saturday';
    if (asw == 7) return 'SUnday';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
              trailing: SizedBox(
                height: 50,
                width: 100,
                child: ListView.builder(
                  itemCount: widget.data[widget.i].data()['Guru'].length,
                  itemBuilder: (context, index0) =>
                      Text(widget.data[widget.i].data()['Guru'][index0]),
                ),
              ),
              subtitle: SizedBox(
                height: 50,
                child: ListView.builder(
                  itemCount: widget.data[widget.i].data()['Murid'].length,
                  itemBuilder: (context, index1) =>
                      Text(widget.data[widget.i].data()['Murid'][index1]),
                ),
              ),
              leading: Text('Sisa :' +
                  widget.data[widget.i].data()['Pertemuan'].toString()),
              title: Text(
                widget.data[widget.i].data()['NamaKelas'],
              )),
          SizedBox(
            width: 400,
            height: 50,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.data[widget.i].data()['Day'].length,
                itemBuilder: (context, index3) =>
                    widget.data[widget.i].data()['Day'][index3] != 0
                        ? Text(
                            days(widget.data[widget.i].data()['Day'][index3])! +
                                ' ' +
                                widget.data[widget.i]
                                    .data()['Jam'][index3]
                                    .toString()
                                    .toString() +
                                ' ' +
                                widget.data[widget.i]
                                    .data()['Menit'][index3]
                                    .toString() +
                                ' ||    ',
                          )
                        : SizedBox()),
          ),
          ElevatedButton(
              onPressed: pressed
                  ? null
                  : 
                  (widget.data[widget.i].data()['Day'] as List).every(
                              (element) => element != DateTime.now().weekday) ||
                          (widget.data[widget.i].data()['Jam'] as List).every(
                              (element) => element != DateTime.now().hour)
                              ||
                          (widget.listHadir.contains(DateFormat.MMMMEEEEd()
                                  .format(DateTime.now())
                                  .toString())&&widget.listHadir.isNotEmpty)
                              
                      ? null
                      : () async {
                          widget.listHadir
                              .add(DateFormat.MMMMEEEEd().format(DateTime.now()).toString());
                          await FirebaseFirestore.instance
                              .collection('murid')
                              .doc(widget.mapData['Nama'])
                              .update({
                            
                            'ListHadir': widget.listHadir
                          });
                          setState(() {
                            pressed = true;
                          });
                        },
              child: Text('Absen'))
        ],
      ),
    );
  }
}
