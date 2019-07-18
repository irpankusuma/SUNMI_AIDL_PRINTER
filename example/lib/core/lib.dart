import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_aidl_print_example/core/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xmlR;
// import 'package:asribilling/freewidget/Button.dart';

class LibMe<T> {
  LibMe();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> ls(key,value) async => await _prefs.then((SharedPreferences prefs) => prefs.setString(key, value));
  Future<bool> isAuth() async{
    return await _prefs.then((SharedPreferences prefs) {
      final String session = prefs.getString(prefix+'session');
      return session == null || session == '' ? false : true;
    });
  }

  Future<String> getSession() async{
    return await _prefs.then((SharedPreferences prefs) {
      final String session = prefs.getString(prefix+'session');
      return session == null || session == '' ? session : null;
    });
  }

  // Future<dynamic> scanNow({ BuildContext context }) async {
  //   try {
  //     String _qrscan = await BarcodeScanner.scan();
      
  //     Map _map = json.decode(_qrscan);
  //     /// ---------------------------------------------------------------------------------------------------------------------------------------------
  //     ///         Build XML
  //     /// ---------------------------------------------------------------------------------------------------------------------------------------------
  //     var builder = new xmlR.XmlBuilder();
  //     void push(k,v) => builder.element(k, nest: v);
  //     builder.element('root',nest: () => builder.element('item',nest: () => _map.forEach(push)));
  //     var _qrxml = builder.build();
      
  //     /// ---------------------------------------------------------------------------------------------------------------------------------------------
  //     ///         Access API
  //     /// ---------------------------------------------------------------------------------------------------------------------------------------------
  //     var id = {
  //       "Session_ID": getSession().then((session) => session),
  //       "QRCodeOriginal":_qrscan,
  //       "QRCodeXML": _qrxml.toXmlString()
  //     };

  //     print(id);
  //     return id;
  //   } on PlatformException catch (e){
  //     if(e.code == BarcodeScanner.CameraAccessDenied){
  //       Button().csStatus(
  //         context: context,
  //         second: 5,
  //         title: "Warning",
  //         msg: "Camera Permission is access denied",
  //         status: FLOATINGSTATUS.WARNING
  //       );
  //     } else {
  //       Button().csStatus(
  //         context: context,
  //         second: 5,
  //         title: "Error",
  //         msg: "Unknown error: $e Please contact developers",
  //         status: FLOATINGSTATUS.ERROR
  //       );
  //     }
  //   } on FormatException {
  //     Button().csStatus(
  //         context: context,
  //         second: 5,
  //         title: "Warning",
  //         msg: "User returned using back button",
  //         status: FLOATINGSTATUS.WARNING
  //       );
  //   } catch (e) {
  //     Button().csStatus(
  //         context: context,
  //         second: 5,
  //         title: "Error",
  //         msg: "Unknown error: $e Please contact developers",
  //         status: FLOATINGSTATUS.ERROR
  //       );
  //   }
  // }
}
