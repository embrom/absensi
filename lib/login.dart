import 'package:absensi/provider/provider.dart';
import 'package:absensi/siswa_page.dart';
import 'package:absensi/wali_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class LoginSiswa extends StatefulWidget {
  const LoginSiswa({Key? key}) : super(key: key);

  @override
  _LoginSiswaState createState() => _LoginSiswaState();
}

class _LoginSiswaState extends State<LoginSiswa> {
  String nipd = '';

  @override
  Widget build(BuildContext context) {
    var devicewidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: deviceHeight,
            height: deviceHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/daun.png'),
                  alignment: Alignment.topCenter),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.green, Colors.yellow.shade200],
              ),
            ),
          ),
          Positioned(
              right: 50,
              top: 100,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/download.png'),
              )),
          Container(
            width: devicewidth * 0.8,
            height: deviceHeight * 0.5,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: PreferredSize(
                      preferredSize: Size(double.infinity, deviceHeight * 0.05),
                      child: AppBar(
                        bottom: TabBar(
                          labelStyle: TextStyle(fontSize: 20),
                          tabs: [Text('Siswa'), Text('Guru')],
                        ),
                      )),
                  body: TabBarView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: devicewidth / 2,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight: Radius.circular(7))),
                              color: Colors.grey.shade200,
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                style: TextStyle(color: Colors.green),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    labelText: 'NIPD :',
                                    hintText: 'eg : 200710184',
                                    labelStyle: TextStyle(
                                      color: Colors.green,
                                    )),
                                keyboardType: TextInputType.number,
                                onChanged: (v) {
                                  setState(() {
                                    nipd = v.trim();
                                  });
                                },
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              debugPrint(nipd);
                              bool login = await Provider.of<Fungsi>(context,
                                      listen: false)
                                  .signIn(context, true, nipd);
                              if (login == true) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SiswaPage(),
                                    ));
                              }
                            },
                            child: Text(
                              '           Continue            ',
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: devicewidth / 2,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight: Radius.circular(7))),
                              color: Colors.grey.shade200,
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                style: TextStyle(color: Colors.green),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    labelText: 'Kode :',
                                    labelStyle: TextStyle(
                                      color: Colors.green,
                                    )),
                              
                                onChanged: (v) {
                                  setState(() {
                                    nipd = v.trim();
                                  });
                                },
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              debugPrint(nipd);
                              bool login = await Provider.of<Fungsi>(context,
                                      listen: false)
                                  .signIn(context, false, nipd);
                              if (login == true) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WaliPage(),
                                    ));
                              }
                            },
                            child: Text(
                              '           Continue            ',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
