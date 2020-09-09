import 'dart:async';

import 'package:beda3a/Models/offer_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:kumi_popup_window/kumi_popup_window.dart';


class PopUp extends StatefulWidget {
  final Offer popsUp;
  PopUp({this.popsUp});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PopUp> {
  GlobalKey btnKey = GlobalKey();

  Timer _timer;
  int _start ;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }
  @override
  void initState() {
    if(widget.popsUp.time!=null)
    _start = widget.popsUp.time;
    else
      _start = 3;
    startTimer();
    super.initState();
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
       backgroundColor: Colors.black45,
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width*0.9,
            height: MediaQuery.of(context).size.width*0.9,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width*0.9,
                  child:CachedNetworkImage(
                    imageUrl:  'https://xlink.ideagroup-sa.com/storage/${widget.popsUp.image}',
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),

                  ),

                ),

               Align(alignment: Alignment.topLeft,child:_start!=0?
               IconButton(icon: CircleAvatar(child: Text('$_start',style: TextStyle(color: Colors.white),)),):
               IconButton(icon: Icon(Icons.cancel,color: Colors.redAccent,), onPressed: (){
                 Navigator.pop(context);
               })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}