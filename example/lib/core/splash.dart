import 'dart:async';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  final bool isIOS;
  final AssetImage image;
  final String to;

  SplashView({this.isIOS, this.image, this.to});

  @override
  SplashScreen createState() => new SplashScreen();
}

class SplashScreen extends State<SplashView> {
  MediaQueryData mQuery;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(widget.to, (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    this.mQuery = MediaQuery.of(context);

    return new Scaffold(
      backgroundColor: Color(0xFF424242),
        body: new Center(
      child: new Container(
        height: (this.mQuery.size.height * 25) / 100,
        width: (this.mQuery.size.width * 50) / 100,
        decoration: BoxDecoration(image: DecorationImage(image: widget.image),),
      ),
    ));
  }
}
