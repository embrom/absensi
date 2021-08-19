import 'package:absensi/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class DataButton extends StatelessWidget {

 
  @override
  Widget build(BuildContext context) {
    var devicewidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return Consumer<Fungsi>(builder: (context, snapshot, c) {
      return Card(elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: deviceHeight*0.1,
            width: devicewidth * 0.35,
            child: Row(children: [
              IconButton(
                  icon: Icon(
                    Icons.add_location_alt_sharp,
                    color: Colors.green,
                  ),
                  onPressed: () async {
                    Location location = new Location();

                    bool _serviceEnabled;
                    PermissionStatus _permissionGranted;
                    LocationData _locationData;

                    _serviceEnabled = await location.serviceEnabled();
                    if (!_serviceEnabled) {
                      _serviceEnabled = await location.requestService();
                      if (!_serviceEnabled) {
                        return;
                      }
                    }

                    _permissionGranted = await location.hasPermission();
                    if (_permissionGranted == PermissionStatus.denied) {
                      _permissionGranted = await location.requestPermission();
                      if (_permissionGranted != PermissionStatus.granted) {
                        return;
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 10000),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Get Location.....'),
                            CircularProgressIndicator()
                          ],
                        )));
                    _locationData = await location.getLocation();
                    ScaffoldMessenger.of(context).clearSnackBars();
                    snapshot.inputLocation(
                        _locationData.latitude!, _locationData.longitude!);
                    print(_locationData.latitude);
                  }),
              VerticalDivider(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Longitude : ' + snapshot.latitude.toString(),style: TextStyle(fontSize: 10),
                      overflow: TextOverflow.clip,
                    ),
                    Text(
                     'Latitude : ' + snapshot.atitude.toString(), style: TextStyle(fontSize: 10),
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
            ]),
          ));
    });
  }
}
