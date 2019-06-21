import 'package:flutter/material.dart';
import 'package:sunmi_aidl_print/sunmi_aidl_print.dart';

class TextAlign {
  final TEXTALIGN code;
  final String name;

  const TextAlign({ this.code, this.name });
}


class SetConfig_View extends StatefulWidget {
  SetConfig_View({Key key}) : super(key: key);

  _SetConfig_ViewState createState() => _SetConfig_ViewState();
}

class _SetConfig_ViewState extends State<SetConfig_View> {
  List<TextAlign> _listAlign = <TextAlign>[];
  TextAlign _selectedAlign;
  TextEditingController _fontSize = TextEditingController();
  TextEditingController _lineWrap = TextEditingController();

  @override
  void initState() {
    super.initState();

    _fontSize.text = '20';
    _lineWrap.text = '3';
    _listAlign.add(new TextAlign(code:TEXTALIGN.LEFT,name:"LEFT"));
    _listAlign.add(new TextAlign(code:TEXTALIGN.CENTER,name:"CENTER"));
    _listAlign.add(new TextAlign(code:TEXTALIGN.RIGHT,name:"RIGHT"));
  }

  @override
  void dispose() { 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("SET CONFIG"),
        elevation: 0,
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
                      child:  new DropdownButtonHideUnderline(
                        child: new DropdownButton<TextAlign>(
                          iconSize: 24.0,
                          isExpanded: true,
                          hint: Text('CHOOSE ALIGN'),
                          value: this._selectedAlign,
                          onChanged: (TextAlign val) => setState(() => this._selectedAlign = val),
                          items: this._listAlign.map((TextAlign map) {
                            return new DropdownMenuItem<TextAlign>(
                              value: map,
                              child: new Text(map.name),
                            );
                          }).toList()
                        )
                      ),
                    ),
                    new RaisedButton(
                      child: new Text('SET ALIGNMENT'),
                      onPressed: () => SunmiAidlPrint.setAlignment(
                        align: _selectedAlign == null ? TEXTALIGN.CENTER : _selectedAlign.code
                      ),
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
                      child: new Text('SET FONT'),
                      onPressed: () => SunmiAidlPrint.setFontSize(fontSize: int.parse(_fontSize.text))
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
                    new Container(
                      padding: EdgeInsets.all(5.0),
                      child:  new TextField(
                        controller: _lineWrap,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          prefixIcon: new Icon(Icons.description, size: 20.0),
                          labelText: 'Line Wrap',
                          border: OutlineInputBorder()
                        ),
                      )
                    ),
                    new RaisedButton(
                      child: new Text('SET LINE WRAP'),
                      onPressed: () => SunmiAidlPrint.setLineWrap(line: int.parse(_lineWrap.text))
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}