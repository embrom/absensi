import 'dart:io';

import 'package:absensi/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class IzinPage extends StatefulWidget {
  final String nomor;
  IzinPage(this.nomor);
  @override
  State<IzinPage> createState() => _IzinPageState();
}

class _IzinPageState extends State<IzinPage> {
  FocusNode _focusNode = FocusNode();
  File? image;
  final _controller = TextEditingController();
  String alasan = '';
  _pickBukti() async {
    var imagepicker = ImagePicker();
    XFile? photo = await imagepicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 25,
        preferredCameraDevice: CameraDevice.front);
    if (photo != null) {
      setState(() {
        image = File(photo.path);
      });
    } else {
      return;
    }
  }

  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    // _focusNode.requestFocus();
    var devicewidth = MediaQuery.of(context).size.width;
    var devsiceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      appBar: AppBar(
        title: Text('Izin Page'),
      ),
      floatingActionButton: Container(
        constraints: BoxConstraints(maxHeight: 200),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: TextFormField(
            focusNode: _focusNode,
            onTap: () {},
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: _controller,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: pressed
                        ? null
                        : () async {
                            if (alasan.isEmpty ||
                                alasan == '' ||
                                image == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      content: Text('Mohon langkapi')));
                              return;
                            }
                            setState(() {
                              pressed = true;
                            });
                            await Provider.of<Fungsi>(context, listen: false)
                                .ijin(context, widget.nomor, alasan, image!);
                            Navigator.of(context).pop();
                          },
                    icon: Icon(Icons.send)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: 'Berikan Alasan:'),
            onChanged: (val) {
              setState(() {
                alasan = val;
              });
            },
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
        
          width: devicewidth * 0.9,
          height: devsiceHeight * 0.7,
          child: image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  child: Image.file(
                    image!,
                    fit: BoxFit.cover,
                  ))
              : Container(
                  padding: EdgeInsets.all(50),
                  margin: EdgeInsets.all(20),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.green)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          iconSize: 100,
                          onPressed: () {
                            _pickBukti();
                          },
                          icon: Icon(Icons.camera_alt_rounded)),
                      Text('Bukti Berupa Gambar')
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
