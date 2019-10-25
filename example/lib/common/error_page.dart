import 'package:flutter/material.dart';
import 'package:sunmi_aidl_print_example/config.dart' as config;

class ErrorPage extends StatelessWidget {
  final String error;
  ErrorPage({ this.error=config.defaultErrorNoData });

  @override
  Widget build(BuildContext context){
    final mediaQuery = MediaQuery.of(context);
    
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              height: (mediaQuery.size.height * 50) / 100,
              width: (mediaQuery.size.width * 100) / 100,
              decoration: BoxDecoration(image: DecorationImage(image:AssetImage('assets/images/error_404.jpg'))),
            ),
          ],
        ),
      )
    );
  }
}
