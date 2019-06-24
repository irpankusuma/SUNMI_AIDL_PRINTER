import 'package:flutter/material.dart';
import 'package:sunmi_aidl_print/sunmi_aidl_print.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/rendering.dart';

class SymbologyData {
  final SYMBOLOGY code;
  final String name;

  const SymbologyData({ this.code, this.name });
}

class ErrorLevelData {
  final ERRORLEVEL code;
  final String name;

  const ErrorLevelData({ this.code, this.name });
}

class TextPosition {
  final TEXTPOS code;
  final String name;

  const TextPosition({ this.code, this.name });
}

class ItemData {
  final int itemQty;
  final String itemDesc;
  final String itemPrice;

  const ItemData({ this.itemQty,this.itemDesc,this.itemPrice });
}


class ExamplePrint_View extends StatefulWidget {
  ExamplePrint_View({Key key}) : super(key: key);

  _ExamplePrint_ViewState createState() => _ExamplePrint_ViewState();
}

class _ExamplePrint_ViewState extends State<ExamplePrint_View> {
  TextEditingController _text = new TextEditingController();
  TextEditingController _fontName = new TextEditingController();
  TextEditingController _fontSize = new TextEditingController();
  TextEditingController _height = new TextEditingController();
  TextEditingController _width = new TextEditingController();
  TextEditingController _size = new TextEditingController();
  List<SymbologyData> _listSymbol = <SymbologyData>[];
  List<ErrorLevelData> _listError = <ErrorLevelData>[];
  List<TextPosition> _listTextPosition = <TextPosition>[];
  List<ItemData> _itemData = <ItemData>[];

  SymbologyData _selectedSymbology;
  ErrorLevelData _selectedErrorLevel;
  TextPosition _selectedTextPosition;

  GlobalKey _globalKey = new GlobalKey();
  bool inside = false;
  Uint8List imageInMemory;
  Uint8List image;

  Future<Uint8List> _capturePng() async {
    try {
      inside = true;
      RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      String bs64 = base64Encode(pngBytes);
      SunmiAidlPrint.printBitmap(bitmap: pngBytes);


      print(pngBytes);
      print(bs64);
      print('png done');
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
  void initState() {
    _text.text = 'qwertyuiopasdfghjklzxcvbnm';
    _fontSize.text = '20';
    _fontName.text = 'Times New Roman';
    _size.text = '300';
    _height.text = '120';
    _width.text = '120';

    _listSymbol.add(new SymbologyData(code: SYMBOLOGY.UPC_A,name:"UPC-A"));
    _listSymbol.add(new SymbologyData(code: SYMBOLOGY.UPC_E,name:"UPC-E"));
    _listSymbol.add(new SymbologyData(code: SYMBOLOGY.EAN_13,name:"EAN-13"));
    _listSymbol.add(new SymbologyData(code: SYMBOLOGY.EAN_8,name:"EAN-8"));
    _listSymbol.add(new SymbologyData(code: SYMBOLOGY.CODE_39,name:"CODE-39"));
    _listSymbol.add(new SymbologyData(code: SYMBOLOGY.ITF,name:"ITF"));
    _listSymbol.add(new SymbologyData(code: SYMBOLOGY.CODEBAR,name:"CODEBAR"));
    _listSymbol.add(new SymbologyData(code: SYMBOLOGY.CODE_93,name:"CODE-93"));
    _listSymbol.add(new SymbologyData(code: SYMBOLOGY.CODE_128,name:"CODE-128"));


    _listError.add(new ErrorLevelData(code: ERRORLEVEL.L, name: "ERROR L"));
    _listError.add(new ErrorLevelData(code: ERRORLEVEL.M, name: "ERROR M"));
    _listError.add(new ErrorLevelData(code: ERRORLEVEL.Q, name: "ERROR Q"));
    _listError.add(new ErrorLevelData(code: ERRORLEVEL.H, name: "ERROR H"));

    _listTextPosition.add(new TextPosition(code: TEXTPOS.NO_PRINT_TEXT, name: "NO PRINT TEXT"));
    _listTextPosition.add(new TextPosition(code: TEXTPOS.ABOVE_BARCODE, name: "ABOVE BARCODE"));
    _listTextPosition.add(new TextPosition(code: TEXTPOS.BELOW_BARCODE, name: "BELOW BARCODE"));
    _listTextPosition.add(new TextPosition(code: TEXTPOS.BOTH, name: "BOTH"));

    _itemData.add(new ItemData(itemQty: 10,itemDesc: "DESCRIPTION 01", itemPrice: "150.000"));
    _itemData.add(new ItemData(itemQty: 20,itemDesc: "DESCRIPTION 02", itemPrice: "100.000"));
    _itemData.add(new ItemData(itemQty: 5,itemDesc: "DESCRIPTION 03", itemPrice: "200.000"));



    super.initState();
  }

  @override
  void dispose() { 
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('EXAMPLE PRINT'),
        elevation: 0.0,
      ),
      body: new Container(
        child: new ListView(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
              child: new Card(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(5.0),
                      child:  new TextField(
                        controller: _text,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          prefixIcon: new Icon(Icons.description, size: 20.0),
                          labelText: 'Input Text',
                          border: OutlineInputBorder()
                        ),
                      )
                    ),
                    new Container(
                      padding: EdgeInsets.all(5.0),
                      child:  new TextField(
                        controller: _fontName,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          prefixIcon: new Icon(Icons.description, size: 20.0),
                          labelText: 'Font Name',
                          border: OutlineInputBorder()
                        ),
                      )
                    ),
                    new Container(
                      padding: EdgeInsets.all(5.0),
                      child:  new TextField(
                        controller: _fontSize,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          prefixIcon: new Icon(Icons.description, size: 20.0),
                          labelText: 'Font Size',
                          border: OutlineInputBorder()
                        ),
                      )
                    ),
                    new RaisedButton(
                      child: new Text('PRINT TEXT WITH FONT'),
                      onPressed: (){
                        SunmiAidlPrint.setAlignment(align:TEXTALIGN.CENTER);
                        SunmiAidlPrint.printTextWithFont(text:_text.text,fontName: _fontName.text, fontSize: int.parse(_fontSize.text));
                        SunmiAidlPrint.setLineWrap(line: 3);
                      },
                    )
                  ],
                ),
              )
            ),

            new Container(
              margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
              child: new Card(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(5.0),
                      child:  new TextField(
                        controller: _text,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          prefixIcon: new Icon(Icons.description, size: 20.0),
                          labelText: 'Input Text',
                          border: OutlineInputBorder()
                        ),
                      )
                    ),
                    new RaisedButton(
                      child: new Text('PRINT TEXT ORIGINAL'),
                      onPressed: (){
                        SunmiAidlPrint.setAlignment(align:TEXTALIGN.CENTER);
                        SunmiAidlPrint.printTextOriginal(text:_text.text);
                        SunmiAidlPrint.setLineWrap(line: 3);
                      }
                    )
                  ],
                ),
              )
            ),

            // QRCODE
            new Container(
              margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
              child: new Card(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(5.0),
                      child:  new TextField(
                        controller: _text,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          prefixIcon: new Icon(Icons.description, size: 20.0),
                          labelText: 'Input Text',
                          border: OutlineInputBorder()
                        ),
                      )
                    ),
                    new Container(
                      padding: EdgeInsets.all(5.0),
                      child:  new TextField(
                        controller: _size,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          prefixIcon: new Icon(Icons.description, size: 20.0),
                          labelText: 'QR Size',
                          border: OutlineInputBorder()
                        ),
                      )
                    ),
                    new RaisedButton(
                      child: new Text('PRINT QRCODE'),
                      onPressed: () {
                        SunmiAidlPrint.setAlignment(align:TEXTALIGN.CENTER);
                        SunmiAidlPrint.printQRCode(text: _text.text,moduleSize:4,errorLevel:ERRORLEVEL.L);
                        SunmiAidlPrint.setLineWrap(line: 3);
                      }
                    )
                  ],
                ),
              )
            ),

            //BARCODE
            new Container(
              margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
              child: new Card(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(5.0),
                      child:  new TextField(
                        controller: _text,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          prefixIcon: new Icon(Icons.description, size: 20.0),
                          labelText: 'Input Text',
                          border: OutlineInputBorder()
                        ),
                      )
                    ),
                    new Container(
                      padding: EdgeInsets.all(5.0),
                      child:  new TextField(
                        controller: _height,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          prefixIcon: new Icon(Icons.description, size: 20.0),
                          labelText: 'Height',
                          border: OutlineInputBorder()
                        ),
                      )
                    ),
                    new Container(
                      padding: EdgeInsets.all(5.0),
                      child:  new TextField(
                        controller: _width,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          prefixIcon: new Icon(Icons.description, size: 20.0),
                          labelText: 'Width',
                          border: OutlineInputBorder()
                        ),
                      )
                    ),
                    new Container(
                      padding: EdgeInsets.all(5.0),
                      child:  new DropdownButtonHideUnderline(
                        child: new DropdownButton<SymbologyData>(
                          iconSize: 24.0,
                          isExpanded: true,
                          hint: Text('Choose Symbology'),
                          value: this._selectedSymbology,
                          onChanged: (SymbologyData val) => setState(() => this._selectedSymbology = val),
                          items: this._listSymbol.map((SymbologyData map) {
                            return new DropdownMenuItem<SymbologyData>(
                              value: map,
                              child: new Text(map.name),
                            );
                          }).toList()
                        )
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.all(5.0),
                      child:  new DropdownButtonHideUnderline(
                        child: new DropdownButton<TextPosition>(
                          iconSize: 24.0,
                          isExpanded: true,
                          hint: Text('Choose Text Position'),
                          value: this._selectedTextPosition,
                          onChanged: (TextPosition val) => setState(() => this._selectedTextPosition = val),
                          items: this._listTextPosition.map((TextPosition map) {
                            return new DropdownMenuItem<TextPosition>(
                              value: map,
                              child: new Text(map.name),
                            );
                          }).toList()
                        )
                      ),
                    ),
                    new RaisedButton(
                      child: new Text('PRINT BARCODE'),
                      onPressed: () {
                        SunmiAidlPrint.setAlignment(align:TEXTALIGN.CENTER);
                        SunmiAidlPrint.printBarcode(
                          text: _text.text,
                          height: int.parse(_height.text),
                          width: int.parse(_width.text),
                          symbology: _selectedSymbology == null ? SYMBOLOGY.CODE_39 : _selectedSymbology.code,
                          textPosition: _selectedTextPosition == null ? TEXTPOS.NO_PRINT_TEXT : _selectedTextPosition.code
                        );
                        SunmiAidlPrint.setLineWrap(line: 3);
                      }
                    )
                  ],
                ),
              ),
            ),

            new Container(
              margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
              child: new Card(
                child: new Column(
                  children: <Widget>[
                    new RaisedButton(
                      color: Colors.red,
                      child: Text('CAPTURE IMAGE', style: TextStyle(color:Colors.white),),
                      onPressed: _capturePng,
                    ),
                    inside ? CircularProgressIndicator()
                    :
                    imageInMemory != null
                        ? Container(
                            child: Image.memory(imageInMemory),
                            margin: EdgeInsets.all(10))
                        : Container(),
                    new RaisedButton(
                      color: Colors.red,
                      child: Text('PRINT IMAGE', style: TextStyle(color:Colors.white),),
                      onPressed: () => Navigator.pushNamed(context, '/print'),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

