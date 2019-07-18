import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:sunmi_aidl_print_example/core/constructor.dart';
import 'package:sunmi_aidl_print_example/component/Widget.dart';
import 'package:sunmi_aidl_print_example/core/colors.dart';

class CheckOutView extends StatefulWidget {
  final List<ItemPriceList> items;

  const CheckOutView({
    Key key,
    @required this.items
  }) : super(key: key);

  _CheckOutViewState createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  MediaQueryData mQuery;
  Button btn = new Button();
  final num_format = new NumberFormat("#,###.##");
  double total = 0;

  @override
  void initState() { 
    super.initState();
    this.calculateTotal();
    print(widget.items);
  }

  void calculateTotal(){
    double sum = 0;
    setState(() {
      for(var i=0;i<widget.items.length;i++){
        sum += (widget.items[i].itemValue) * (widget.items[i].itemPrice);
        if(i == 0){
          this.total = (widget.items[i].itemValue) * (widget.items[i].itemPrice);
        } else {
          this.total = this.total + (widget.items[i].itemValue) * (widget.items[i].itemPrice);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    this.mQuery = MediaQuery.of(context);

    return new WillPopScope(
      onWillPop: () async => true,
      child: new Scaffold(
        body: new OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
              ConnectivityResult status,
              Widget child,
          ) {
            final connect = status != ConnectivityResult.none;
            return new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Container(
                  height: (mQuery.size.height * 20) / 100,
                  child: new ListView(
                    children: <Widget>[
                      new Stack(
                        children: <Widget>[
                          new Container(
                            height:(this.mQuery.size.height * 15) / 100,
                            width:(this.mQuery.size.width * 100) / 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/gwk-home.jpg'),
                                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8),BlendMode.dstATop),
                              )
                            ),
                          ),
                          new Positioned(
                            child: new Container(
                              width: (this.mQuery.size.width * 15) / 100,
                              alignment: Alignment.centerRight,
                              child: new AppBar(
                                title: new Container(
                                  height: 35.0,
                                  width: 40.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage('assets/images/gwk-logo.png'))),
                                ),
                                backgroundColor: Colors.transparent,
                                elevation: 0.0,
                              )
                            )
                          ),
                          new Positioned(
                            top: (this.mQuery.size.height * 5)/100,
                            left: (this.mQuery.size.height * -5)/100,
                            width: (mQuery.size.width * 100)/100,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                btn.csButtonMax(
                                  color: Colors.lightGreen.withOpacity(0.8),
                                  border:  new Border.all(color: Colors.green),
                                  borderRadius: new BorderRadius.circular(10.0),
                                  text: Text('   CHECKOUT   ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                  onPressed: () => null
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ),
                new Container(
                  padding: EdgeInsets.all(5.0),
                  child: new Card(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          margin: new EdgeInsets.all(5.0),
                          width: 8.0,
                          height: (mQuery.size.height * 5) / 100,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            border: new Border.all(color: Colors.red,),
                            borderRadius: new BorderRadius.circular(50.0)),
                        ),
                        new Flexible(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Container(
                                child: new Text('TOTAL',style:TextStyle(fontWeight:FontWeight.bold,fontSize:20.0),),
                              ),
                              new Flexible(
                                child: new Text('Rp. '+num_format.format(this.total),style:TextStyle(fontWeight:FontWeight.bold,fontSize:20.0),),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                new Expanded(
                  child: new ListView.builder(
                    itemCount: widget.items.length,
                    itemBuilder: (BuildContext context,int i){
                      TextEditingController qty = new TextEditingController();
                      qty.text = widget.items[i].itemValue.toString();
                      
                      return new Card(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Container(
                              margin: new EdgeInsets.all(5.0),
                              width: 8.0,
                              height: (mQuery.size.height * 15) / 100,
                              decoration: BoxDecoration(
                                color: kShrineBlack50,
                                border: new Border.all(color: kShrineBlack50,),
                                borderRadius: new BorderRadius.circular(50.0)),
                            ),
                            new Flexible(
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                                    child: new Text(widget.items[i].itemDesc,style:TextStyle(fontSize:16.0,fontWeight:FontWeight.bold)),
                                  ),
                                  new Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                                    child: new Text("Rp. "+num_format.format(widget.items[i].itemPrice),style:TextStyle(fontSize:20.0)),
                                  )
                                ],
                              ),
                            ),
                            new Flexible(
                              child: new TextFormField(
                                decoration: new InputDecoration(
                                  labelText: 'QTY',
                                  labelStyle: TextStyle(color:kShrineIconColor,fontSize:12.0),
                                  border: new OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                controller: qty,
                                enabled: false,
                                style: TextStyle(color:kShrineBlack80,fontSize:24.0,fontWeight:FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                )
              ],
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[],
          ),
        ),
      ) 
    ); 
  }
}