import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String message;
  final String image;
  Message({this.image, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.4,
          child: Image.asset('$image'),
        ),
        Text('$message'),
      ],
    );
  }
}
