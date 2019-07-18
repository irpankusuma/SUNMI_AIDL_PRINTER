import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:sunmi_aidl_print_example/core/toast.dart';
import 'package:sunmi_aidl_print_example/component/Widget.dart';
import 'package:sunmi_aidl_print_example/core/colors.dart';
import 'package:sunmi_aidl_print_example/core/constructor.dart';
import 'package:sunmi_aidl_print_example/checkout.dart';

class _ItemPriceListInherited extends InheritedWidget {
  _ItemPriceListInherited({
    Key key,
    @required Widget child,
    @required this.data
  }) : super(key: key, child: child);

  final ItemPriceListViewState data;
  @override
  bool updateShouldNotify(_ItemPriceListInherited old) => true;
}

class ItemPriceListView extends StatefulWidget{
  final Widget child;
  final List<ItemPriceList> items;

  ItemPriceListView({
    Key key,
    this.child,
    this.items
  }) : super(key:key);

  static ItemPriceListViewState of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(_ItemPriceListInherited) as _ItemPriceListInherited).data;
  }

  @override
  ItemPriceListViewState createState() => new ItemPriceListViewState();
}

class ItemPriceListViewState extends State<ItemPriceListView>{
  BlinkingToast toast = new BlinkingToast();
  bool isLoading = false;
  Button btn = new Button();
  // List<ItemPriceList> _priceList = <ItemPriceList>[];
  List<ItemPriceList> _items = <ItemPriceList>[];
  
  @override
  void initState() { 
    print('-- item pricelist --');
    super.initState();
    this._items = widget.items;

    // _priceList.add(new ItemPriceList(
    //   idxItem: 1,
    //   itemDesc: "Entrance Ticket",
    //   itemPrice: 125000,
    //   itemValue: 0
    // ));
    // _priceList.add(new ItemPriceList(
    //   idxItem: 2,
    //   itemDesc: "Shuttle Ticket",
    //   itemPrice: 30000,
    //   itemValue: 0
    // ));
  }
  

  @override
  void dispose() { 
    super.dispose();
  }

  void onChange(int id,ItemPriceList data){
    List<ItemPriceList> _filter = _items.where((k) => k.idxItem != id).toList();
    _filter.add(data);
    print(data.itemValue);
    setState(() => this._items = _filter);
  }

  Future<Null> next(){
    List<ItemPriceList> _data = this._items.where((k) => k.itemValue != 0).toList();
    if(_data.isEmpty){
      btn.csStatus(
        context: context,
        status: FLOATINGSTATUS.WARNING,
        title: "WARNING",
        msg: "Please add some ticket.",
        second: 5
      );
    } else {
      Navigator.push(context,new MaterialPageRoute(builder: (BuildContext context) => new CheckOutView(items: _data,)));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return new _ItemPriceListInherited(
      data: this,
      child: new PreOrderRender() // gak boleh dari class yg sama, keluarin ke class baru
    );
  }
}

class PreOrderRender extends StatelessWidget {
  MediaQueryData mQuery;

  @override
  Widget build(BuildContext context) {
    final ItemPriceListViewState state = ItemPriceListView.of(context);
    this.mQuery = MediaQuery.of(context);
    final num_format = new NumberFormat("#,###.##");

    List<ItemPriceList> items = [];
    for(var i=0;i<state._items.length;i++){
      items.add(new ItemPriceList(
        idxItem: state._items[i].idxItem,
        itemDesc: state._items[i].itemDesc,
        itemPrice: state._items[i].itemPrice,
        itemValue: state._items[i].itemValue,
      ));
    }
    items.sort((a,b) => a.idxItem.compareTo(b.idxItem));
    
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
                                state.btn.csButtonMax(
                                  color: Colors.lightGreen.withOpacity(0.8),
                                  border:  new Border.all(color: Colors.green),
                                  borderRadius: new BorderRadius.circular(10.0),
                                  text: Text('   NEXT   ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                  onPressed: () => state.next()
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ),
                new Expanded(
                  child: new ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context,int i){
                      TextEditingController qty = new TextEditingController();
                      qty.text = items[i].itemValue == 0 ? '0' : items[i].itemValue.toString();
                      
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
                                    child: new Text(items[i].itemDesc,style:TextStyle(fontSize:16.0,fontWeight:FontWeight.bold)),
                                  ),
                                  new Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                                    child: new Text("Rp. "+num_format.format(items[i].itemPrice),style:TextStyle(fontSize:20.0)),
                                  )
                                ],
                              ),
                            ),
                            new Flexible(
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new IconButton(
                                    icon: new Icon(Icons.remove_circle,size:26.0,color:Colors.red,),
                                    onPressed: (){
                                      int n = int.tryParse(qty.text);
                                      int inc = n == 0 ? 0 : n-1;
                                      qty.text = inc.toString();
                                      state.onChange(items[i].idxItem, new ItemPriceList(
                                        idxItem: items[i].idxItem,
                                        itemDesc: items[i].itemDesc,
                                        itemPrice: items[i].itemPrice,
                                        itemValue: inc
                                      ));
                                    },
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
                                      onFieldSubmitted: (v){
                                        qty.text = v;
                                        state.onChange(items[i].idxItem, new ItemPriceList(
                                          idxItem: items[i].idxItem,
                                          itemDesc: items[i].itemDesc,
                                          itemPrice: items[i].itemPrice,
                                          itemValue: int.tryParse(v)
                                        ));
                                      },
                                      onEditingComplete: () => state.onChange(items[i].idxItem, new ItemPriceList(
                                          idxItem: items[i].idxItem,
                                          itemDesc: items[i].itemDesc,
                                          itemPrice: items[i].itemPrice,
                                          itemValue: int.tryParse(qty.text)
                                        )
                                      ),
                                      style: TextStyle(color:kShrineBlack80,fontSize:24.0,fontWeight:FontWeight.bold),
                                    ),
                                  ),
                                  new IconButton(
                                    icon: new Icon(Icons.add_circle,size:26.0,color:Colors.green),
                                    onPressed: (){
                                      int n = int.tryParse(qty.text);
                                      int inc = n+1;
                                      qty.text = inc.toString();
                                      state.onChange(items[i].idxItem, new ItemPriceList(
                                        idxItem: items[i].idxItem,
                                        itemDesc: items[i].itemDesc,
                                        itemPrice: items[i].itemPrice,
                                        itemValue: inc
                                      ));
                                    },
                                  )
                                ],
                              )
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