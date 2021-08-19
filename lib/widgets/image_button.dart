import 'dart:io';

import 'package:absensi/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageButton extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    var devicewidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return Consumer<Fungsi>(builder: (context, snapshot, c) {
      return Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
              height: deviceHeight * 0.1,
              width: devicewidth * 0.35,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.add_a_photo_rounded,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          var imagepicker = ImagePicker();
                          XFile? photo = await imagepicker.pickImage(
                              source: ImageSource.camera,
                              imageQuality: 25,
                              preferredCameraDevice: CameraDevice.front);
                          if (photo != null) {
                            snapshot.inputPhoto(photo.path);
                          } else {
                            return;
                          }
                        }),
                    VerticalDivider(),
                    snapshot.imagePath == ''
                        ? ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            child: AspectRatio(
                              aspectRatio: 3 / 4,
                              child: Image.asset(
                                'assets/download.png',
                                fit: BoxFit.cover,
                              ),
                            ))
                        : ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            child: Image.file(
                              File(
                                snapshot.imagePath,
                              ),
                              fit: BoxFit.cover,
                            ))
                  ])));
    });
  }
}
