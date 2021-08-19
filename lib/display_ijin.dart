import 'package:flutter/material.dart';

class IzinDisplay extends StatelessWidget {
  final String alasan;
  final String imageUrl;
  const IzinDisplay({Key? key, required this.alasan, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var devicewidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body:  Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: deviceHeight * 0.5,
                child: FadeInImage.assetNetwork(
                    placeholder: 'assets/download.png', image: imageUrl),
              ),
              Text(alasan)
            ],
          ),
      ),
      
    );
  }
}
