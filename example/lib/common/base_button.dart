import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({this.onPressed, this.color, this.text, this.borderRadius});

  final VoidCallback onPressed;
  final Color color;
  final Text text;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new Container(
        height: 40.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[text],
        )
      )
    );
  }
}