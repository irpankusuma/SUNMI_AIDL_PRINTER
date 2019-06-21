import 'package:flutter/material.dart';
import 'package:sunmi_aidl_print/sunmi_aidl_print.dart';

class GetInfo_View extends StatefulWidget {
  GetInfo_View({Key key }) : super(key: key);

  _GetInfo_ViewState createState() => _GetInfo_ViewState();
}

class _GetInfo_ViewState extends State<GetInfo_View> {
  String _version = '';
  String _serialNo = '';
  String _model = '';
  String _serviceVersion = '';

  @override
  void initState() { 
    super.initState();
    this.init();
  }

  @override
  void dispose() { 
    super.dispose();
  }

  Future<Null> init() async {
    String serialNo = await SunmiAidlPrint.getPrinterInfo(code: GETINFO.PRINTER_SERIALNO);
    String version = await SunmiAidlPrint.getPrinterInfo(code: GETINFO.PRINTER_VERSION);
    String model = await SunmiAidlPrint.getPrinterInfo(code: GETINFO.PRINTER_MODAL);
    String serviceVer = await SunmiAidlPrint.getPrinterInfo(code: GETINFO.SERVICE_VERSION);

    setState(() {
      this._serialNo = serialNo;
      this._version = version;
      this._model = model;
      this._serviceVersion = serviceVer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("PRINTER INFORMATION"),
        elevation: 0,
      ),
      body: new Container(
        padding: EdgeInsets.all(5),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.fromLTRB(5.0,5.0,5.0,0.0),
              child: new Text("SERIAL NO : " + _serialNo),
            ),
            new Container(
              margin: EdgeInsets.fromLTRB(5.0,5.0,5.0,0.0),
              child: new Text("POS MODEL : " + _model),
            ),
            new Container(
              margin: EdgeInsets.fromLTRB(5.0,5.0,5.0,0.0),
              child: new Text("PRINTER VERSION : " + _version),
            ),
            new Container(
              margin: EdgeInsets.fromLTRB(5.0,5.0,5.0,0.0),
              child: new Text("SERVICE VERSION : " + _serviceVersion),
            )
          ],
        ),
      ),
    );
  }
}