import 'package:flutter/material.dart';
import 'package:sunmi_aidl_print/sunmi_aidl_print.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';


class StrukDetail {
  final String name;
  final String value;

  const StrukDetail({ this.name, this.value });
}

class StrukItemData {
  final String name;
  final String uom;
  final String price;

  const StrukItemData({ this.name, this.uom, this.price });
}



class PrintStrukView extends StatefulWidget {
  PrintStrukView({Key key}) : super(key: key);

  _PrintStrukViewState createState() => _PrintStrukViewState();
}

class _PrintStrukViewState extends State<PrintStrukView> {
  GlobalKey _globalKey = new GlobalKey();
  bool inside = false;
  Uint8List imageInMemory;
  Uint8List image;
  List<StrukDetail> _headerDetail = <StrukDetail>[];
  List<StrukItemData> _itemData = <StrukItemData>[];
  List<StrukDetail> _paymentDetail = <StrukDetail>[];

  String disclaimer_1 = "Tidak dapat dipindahtangankan, tidak dapat dijual kepada orang lain atau dialihkan dan tidak dapat diuangkan kembali, termasuk, "+
    "namun tidak tebatas pada kejadian-kejadian diluar kendali GWK. Tindakan pemerintah, kerusuhan, pemogokan, bencana alam";
  

  @override
  void initState() {
    super.initState();
    _headerDetail.add(new StrukDetail(name:"Order Number",value:"TC-1904-0059098-N"));
    _headerDetail.add(new StrukDetail(name:"POS ID",value:"10SDD123"));
    _headerDetail.add(new StrukDetail(name:"Cashier",value:"Cashier 01"));
    _headerDetail.add(new StrukDetail(name:"Printed",value:"24 April 2019 16:17:39"));

    _itemData.add(new StrukItemData(name:"SubTotal",uom:"(Rp.)",price:"250,000"));
    _itemData.add(new StrukItemData(name:"Total",uom:"(Rp.)",price:"200,000"));
    _itemData.add(new StrukItemData(name:"Payment",uom:"(Rp.)",price:"100,000"));
    _itemData.add(new StrukItemData(name:"Change",uom:"(Rp.)",price:"50,000"));

    _paymentDetail.add(new StrukDetail(name:"Payment Type",value:"Single Payment"));
    _paymentDetail.add(new StrukDetail(name:"Payment Method",value:"Cash"));
  }

  @override
  void dispose() { 
    
    super.dispose();
  }

  Future<Uint8List> _capturePng() async {
    try {
      inside = true;
      RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      print(pngBytes);
      SunmiAidlPrint.printBitmap(bitmap: pngBytes);
      setState(() {
        imageInMemory = pngBytes;
        inside = false;
      });
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      appBar: new AppBar(
        title: new Text("Print Struk"),
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.print),
            onPressed: () => _capturePng()
          )
        ],
      ),
      body: new RepaintBoundary(
        key: _globalKey,
        child: new Card(
          child: new ListView(
            children: <Widget>[
              new Text("GWK Cultural Park",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
              new Text("Selamat Datang / Welcome",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
              new Text("www.gwkbali.com",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
              new Divider(),
              // TABLE HEADER
              new ListView.builder(
                shrinkWrap: true,
                itemCount: _headerDetail.length,
                itemBuilder: (BuildContext context,int i){
                  return new StrukHeaderDetail(
                    name: _headerDetail[i].name,
                    separator: " : ",
                    value: _headerDetail[i].value
                  );
                },
              ),
              // TABLE BODY 1
              new Divider(),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Text('2X'),
                  new Text('ITEM DESCRIPTION'),
                  new Text('250,000')
                ],
              ),
              // TABLE BODY
              new Divider(),
              new ListView.builder(
                shrinkWrap: true,
                itemCount: _itemData.length,
                itemBuilder: (BuildContext context, int i){
                  return new BodyItemData(
                    name: _itemData[i].name,
                    uom: _itemData[i].uom,
                    price: _itemData[i].price,
                  );
                },
              ),

              // QR CODE
              new Divider(),
              new Container(
                alignment: Alignment.center,
                child: new QrImage(
                  data: "1234567890",
                  size: 200.0,
                ),
              ),
              new Divider(),
              // TABLE PAYMENT
              new Text("###### PAYMENT ######",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
              new ListView.builder(
                shrinkWrap: true,
                itemCount: _paymentDetail.length,
                itemBuilder: (BuildContext context,int i){
                  return new StrukHeaderDetail(
                    name: _paymentDetail[i].name,
                    separator: " : ",
                    value: _paymentDetail[i].value
                  );
                },
              ),
              // DISCLAIMER
              new Divider(),
              new Text(disclaimer_1,style: TextStyle(fontWeight: FontWeight.bold,fontSize:10.0),textAlign: TextAlign.center,),




              // IMAGE PREVIEW
              // inside ? CircularProgressIndicator() :
              //   imageInMemory != null
              //     ? Container(
              //         child: Image.memory(imageInMemory),
              //         margin: EdgeInsets.all(10))
              //     : Container(),
            ],
          ),
        )
      ),
    );
  }
}

class StrukHeaderDetail extends StatelessWidget {
  final String name;
  final String separator;
  final String value;
  const StrukHeaderDetail({ this.name, this.separator, this.value });

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(name, style: TextStyle(fontWeight: FontWeight.bold),),
          new Text(separator),
          new Text(value),
        ],
      ),
    );
  }
}

class BodyItemData extends StatelessWidget {
  final String name;
  final String uom;
  final String price;
  const BodyItemData({ this.name, this.uom, this.price });
  
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Text(name, style: TextStyle(fontWeight: FontWeight.bold),),
          new Text(uom, style: TextStyle(fontWeight: FontWeight.bold),),
          new Text(price, style: TextStyle(fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
