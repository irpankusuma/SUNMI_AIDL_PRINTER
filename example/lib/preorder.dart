import 'package:flutter_offline/flutter_offline.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sunmi_aidl_print_example/core/toast.dart';
import 'package:sunmi_aidl_print_example/component/Widget.dart';
import 'package:sunmi_aidl_print_example/core/colors.dart';
import 'package:sunmi_aidl_print_example/core/focus.dart';
import 'package:sunmi_aidl_print_example/core/constructor.dart';
import 'package:sunmi_aidl_print_example/itemprice.dart';

import 'package:sunmi_aidl_print/sunmi_aidl_print.dart';

class _PreOrderInherited extends InheritedWidget {
  _PreOrderInherited({
    Key key,
    @required Widget child,
    @required this.data
  }) : super(key: key, child: child);

  final PreOrderViewState data;
  @override
  bool updateShouldNotify(_PreOrderInherited old) => true;
}

class PreOrderView extends StatefulWidget{
  static PreOrderViewState of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(_PreOrderInherited) as _PreOrderInherited).data;
  }

  @override
  PreOrderViewState createState() => new PreOrderViewState();
}

class PreOrderViewState extends State<PreOrderView>{
  BlinkingToast toast = new BlinkingToast();
  TextEditingController preorder = new TextEditingController();
  TextEditingController vechileno = new TextEditingController();
  FocusNode preorderFc = new FocusNode();
  FocusNode vechileFc = new FocusNode();
  bool isLoading = false;
  Button btn = new Button();
  List<Menu> _menu = <Menu>[];

  List<ItemPriceList> entranceList = <ItemPriceList>[];
  List<ItemPriceList> pedestalList = <ItemPriceList>[];


  @override
  void initState() { 
    print('-- login --');
    super.initState();

    SunmiAidlPrint.bindPrinter();
    //ENTRANCE
    entranceList.add(new ItemPriceList(
      idxItem: 1,
      itemDesc: "Entrance Ticket",
      itemPrice: 125000,
      itemValue: 0
    ));
    entranceList.add(new ItemPriceList(
      idxItem: 2,
      itemDesc: "Shuttle Ticket",
      itemPrice: 30000,
      itemValue: 0
    ));

    // PEDESTAL
    pedestalList.add(new ItemPriceList(
      idxItem: 1,
      itemDesc: "Entrance Ticket",
      itemPrice: 125000,
      itemValue: 0
    ));
    pedestalList.add(new ItemPriceList(
      idxItem: 2,
      itemDesc: "Entrance Ticket",
      itemPrice: 125000,
      itemValue: 0
    ));
    pedestalList.add(new ItemPriceList(
      idxItem: 3,
      itemDesc: "Entrance Ticket",
      itemPrice: 125000,
      itemValue: 0
    ));
    pedestalList.add(new ItemPriceList(
      idxItem: 4,
      itemDesc: "Entrance Ticket",
      itemPrice: 125000,
      itemValue: 0
    ));
    pedestalList.add(new ItemPriceList(
      idxItem: 5,
      itemDesc: "Entrance Ticket",
      itemPrice: 125000,
      itemValue: 0
    ));
    pedestalList.add(new ItemPriceList(
      idxItem: 6,
      itemDesc: "Entrance Ticket",
      itemPrice: 125000,
      itemValue: 0
    ));
    pedestalList.add(new ItemPriceList(
      idxItem: 7,
      itemDesc: "Entrance Ticket",
      itemPrice: 125000,
      itemValue: 0
    ));
    pedestalList.add(new ItemPriceList(
      idxItem: 8,
      itemDesc: "Entrance Ticket",
      itemPrice: 125000,
      itemValue: 0
    ));

    _menu.add(new Menu(
      icon:Icon(FontAwesomeIcons.dungeon,size:54.0,color:kShrineBlack80,),
      text:Text('ENTRANCE'),
      onPressed:() async => Navigator.push(context,new MaterialPageRoute(builder: (BuildContext context) => new ItemPriceListView(items:entranceList))))
    );
    _menu.add(new Menu(
      icon:Icon(FontAwesomeIcons.gopuram,size:54.0,color:kShrineBlack80,),
      text:Text('PEDESTAL'),
      onPressed:() async => Navigator.push(context,new MaterialPageRoute(builder: (BuildContext context) => new ItemPriceListView(items:pedestalList,))))
    );
  }

  @override
  void dispose() { 
    super.dispose();
    preorder.clear();
    vechileno.clear();
    _menu.clear();
  }

  // void loadAuth() async{
  //   new Timer(new Duration(milliseconds:10),() => push(path:'/dashboard'));
  // }

  // void push({String path}) async{
  //   if(await m.isAuth()){
  //     Navigator.of(context).pushNamedAndRemoveUntil(path, (Route<dynamic> route) => false);
  //   }
  // }

  // Future<void> login() async {
  //   print('-- login -- '+ username.text);
  // }

  Widget buildUsername(){
    return new Container(
      child: new Focused(
        focusNode: preorderFc,
        child: new TextFormField(
          decoration: new InputDecoration(
            prefixIcon: new Icon(FontAwesomeIcons.ticketAlt,color:kShrineBlack80,size:20.0),
            labelText: 'PRE ORDER',
            labelStyle: TextStyle(color:kShrineIconColor),
            border: new OutlineInputBorder(),
          ),
          controller: preorder,
          focusNode: preorderFc,
          style: TextStyle(color:kShrineBlack80),
        ),
      ),
    );
  }

  Widget buildPassword(){
    return new Container(
      child: new Focused(
        focusNode: vechileFc,
        child: new TextFormField(
          decoration: new InputDecoration(
              prefixIcon: new Icon(FontAwesomeIcons.busAlt,color:kShrineBlack80,size:20.0),
              labelText: 'VECHILE NO',
              labelStyle: TextStyle(color: kShrineBlack80,),
              border: new OutlineInputBorder(),
            ),
          controller: vechileno,
          focusNode: vechileFc,
          style: TextStyle(color:kShrineBlack80),
        ),
      )
    );
  }

  void buildRegister(PreOrderViewState state){
    Navigator.of(context).push(
      new MaterialPageRoute<Null>(
        builder: (BuildContext ctx) => new PreOrderMenu(items:_menu),
        fullscreenDialog: true
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return new _PreOrderInherited(
      data: this,
      child: new PreOrderRender() // gak boleh dari class yg sama, keluarin ke class baru
    );
  }
}

class PreOrderRender extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final PreOrderViewState state = PreOrderView.of(context);
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        body: new OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
              ConnectivityResult status,
              Widget child,
          ) {
            final connect = status != ConnectivityResult.none;
            return new Container(
              decoration: new BoxDecoration(
                  ),
              child: new ListView(
                children: <Widget>[
                  new Center(
                      child: Column(
                      children: <Widget>[
                        new SizedBox(
                          height: 40.0,
                        ),
                        new Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            new Container(height: 300.0,),
                            new Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                              decoration: BoxDecoration(
                                color: Colors.teal.shade200.withOpacity(0.0),
                                borderRadius: new BorderRadius.circular(25.0),
                              ),
                              child: SafeArea(
                                top: false,
                                bottom: false,
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Container(width: double.infinity,height: 80.0),
                                      state.buildUsername(),SizedBox(height: 10.0),
                                      state.buildPassword(),SizedBox(height: 10.0),
                                      new Container(
                                        padding: EdgeInsets.all(6.0),
                                        child: state.isLoading == true
                                          ? new Center(
                                              child: new CircularProgressIndicator(
                                                strokeWidth: 4.0,
                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.lime)
                                            )
                                          ) : state.btn.csButtonMax(
                                            color: Colors.lightGreen.withOpacity(0.8),
                                            border:  new Border.all(color: Colors.green),
                                            borderRadius: new BorderRadius.circular(25.0),
                                            text: Text('BUY TICKET',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                            onPressed: () => state.buildRegister(state)
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            new Positioned(
                                top: 0.0,
                                child: Center(
                                  child: new Container(
                                    height: 100.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                      image: AssetImage('assets/images/gwk-logo.png')
                                    )
                                  ),
                                ),
                              )
                            )
                          ],
                        ),
                      ],
                    )
                  )
                ],
              ),
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

class PreOrderMenu extends StatelessWidget {
  final List<Menu> items;
  const PreOrderMenu({Key key, this.items }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('GWK E-KIOS'),
      ),
      body: new Container(
        child: new GridView.builder(
          itemCount:items.length,
          gridDelegate:new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2),
          itemBuilder: (BuildContext context, int i) => new CustomGridButton(
            icon: items[i].icon,
            text: items[i].text,
            onPressed: items[i].onPressed,
          ),
        )
      ),
    );
  }
}


class CustomGridButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final Text text;

  const CustomGridButton({ this.icon, this.text, this.onPressed}) : assert(icon != null, text != null);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new InkWell(
      onTap: onPressed,
      child: new Card(
        child: new Container(
          padding: EdgeInsets.all(5),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              icon, new SizedBox(height:5.0,),text
            ],
          ),
        ),
      )
    );
  }
}