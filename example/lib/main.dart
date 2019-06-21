import 'package:flutter/material.dart';
import 'package:sunmi_aidl_print_example/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes()
    );
  }
}