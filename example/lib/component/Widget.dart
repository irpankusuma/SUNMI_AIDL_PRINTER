import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sunmi_aidl_print_example/core/colors.dart';
import 'package:sunmi_aidl_print_example/core/zoomable.dart';

enum FLOATINGSTATUS {
  ERROR,
  SUCCESS,
  WARNING,
  INFO
}

class Button {
  Widget csImageClick({ ImageProvider imageProvider, VoidCallback onPressed }){
    return new InkWell(
      onTap: onPressed,
      child: new Image(image:imageProvider,fit:BoxFit.cover)
    );
  }

  Widget csCreateQR({ String content, double size, Color color=kShrineBlack80 }){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Your QRCODE'),
      ),
      body: new Container(
        margin: EdgeInsets.all(10.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CreateQR(content: content,size:size,color:color,),
            new Text(content,style:TextStyle(fontWeight:FontWeight.bold,fontSize:30.0,color:color),)
          ],
        ),
      )
    );
  }

  Widget csZoom({ dynamic image }){
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Preview Image'),
        elevation: 0.0,
      ),
      body: new ZoomableImage(image,backgroundColor:kShrineBlack50,),
    );
  }

  Widget csButton({ Widget child,VoidCallback onPressed }){
    return _CsButton(
      child: child,
      onPressed: onPressed,
    );
  }

  Widget csButtonMax({ VoidCallback onPressed, Color color, Text text, BorderRadius borderRadius, Border border, Icon icon }){
    return _ButtonMax(
      onPressed: onPressed,
      color: color,
      text: text,
      borderRadius: borderRadius,
      border: border,
      icon: icon
    );
  }

  Widget csButtonIcon({ VoidCallback onPressed, Widget text, Widget icon, double height, double width, Color color }){
    return _ButtonIcon(
      onPressed: onPressed,
      text: text,
      icon: icon,
      height: height,
      width: width,
      color: color
    );
  }

  Widget csStatus({ 
    BuildContext context, 
    FLOATINGSTATUS status, 
    String msg="", 
    String title,
    bool isDismis=false,
    FlatButton mainButton,
    int second=3
  }){
    Flushbar(
      title: title,
      message: msg,
      isDismissible: isDismis,
      mainButton: mainButton,
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: Icon(
        status == FLOATINGSTATUS.INFO ? Icons.info 
          : status == FLOATINGSTATUS.SUCCESS ? Icons.check
          : status == FLOATINGSTATUS.WARNING ? Icons.warning
          : Icons.error_outline,
        size: 28.0,
        color: status == FLOATINGSTATUS.INFO ? Colors.blue
          : status == FLOATINGSTATUS.SUCCESS ? Colors.green
          : status == FLOATINGSTATUS.WARNING ? Colors.yellow
          : Colors.red, 
      ),
      duration: new Duration(seconds:second),
      leftBarIndicatorColor: status == FLOATINGSTATUS.INFO ? Colors.blue
          : status == FLOATINGSTATUS.SUCCESS ? Colors.green
          : status == FLOATINGSTATUS.WARNING ? Colors.yellow
          : Colors.red, 
    )..show(context);
  }
}

/**
 * CLASS
 */

class CreateQR extends StatelessWidget {
  final String content;
  final double size;
  final Color color;
  const CreateQR({ Key key, @required this.content, this.size=100.0, this.color=kShrineBlack80 }) : assert(content != null), super(key:key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new QrImage(
        data: content,
        foregroundColor: color,
        padding: EdgeInsets.all(5.0),
        size: size,
        onError: (onError) => 
          new Button().csStatus(
            context: context,
            title: 'ERROR',
            msg: 'Error when creating QRCode'
          ),
      ),
    );
  }
}

class _ButtonMax extends StatelessWidget {
  const _ButtonMax({this.onPressed, this.color, @required this.text, this.borderRadius, this.border, this.icon }) 
    : assert(text != null);

  final VoidCallback onPressed;
  final Color color;
  final Text text;
  final BorderRadius borderRadius;
  final Border border;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new Container(
        height: 40.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border: border
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon == null ? new SizedBox(height:0.0,) 
            : new Container(
              padding: EdgeInsets.all(10.0),
              child:icon
            ),
            new Container(
              padding: EdgeInsets.all(10.0),
              child: text,
            )
          ],
        )
      )
    );
  }
}

class _ButtonIcon extends StatelessWidget {
  _ButtonIcon({ 
    Key key,
    this.onPressed,
    @required this.text,
    @required this.icon,
    this.height=64.0,
    this.width=64.0,
    this.color=Colors.black
  }) : assert(text != null || icon != null), super(key:key);

  final VoidCallback onPressed;
  final Widget text;
  final Widget icon;
  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new Container(
        padding: EdgeInsets.all(5.0),
        height: height,
        width: width,
        decoration: BoxDecoration(color: color),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            icon == null ? new SizedBox(height:0.0) : new Flexible(child:icon), 
            text == null ? new SizedBox(height:0.0) : text
          ],
        )
      ),
    );
  }
}

class _CsButton extends StatelessWidget {
  const _CsButton({Key key, this.child, this.onPressed}) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onPressed, child: child);
  }
}

