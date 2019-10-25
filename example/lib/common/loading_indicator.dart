import 'package:flutter/material.dart';
import 'package:sunmi_aidl_print_example/config.dart' as config;

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final mediaQuery = MediaQuery.of(context);
    final TextStyle style = TextStyle(color:Colors.black);

    return new Scaffold(
      // backgroundColor: Color(0xFF424242),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text(config.defaultLoading,style:style,),
            new Container(
              height: (mediaQuery.size.height * 15) / 100,
              width: (mediaQuery.size.width * 50) / 100,
              decoration: BoxDecoration(image: DecorationImage(image:AssetImage(config.defaultLogoImage))),
            ),
          ],
        ),
      )
    );
  }
}
