import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunmi_aidl_print_example/blocs/blocs.dart';
import 'package:sunmi_aidl_print_example/blocs/printing_bloc.dart';
import 'package:sunmi_aidl_print_example/config.dart' as config;
import 'package:flutter/material.dart';
import 'package:sunmi_aidl_print/models.dart';
import 'package:sunmi_aidl_print/sunmi_aidl_print.dart';
import 'package:sunmi_aidl_print_example/models/models.dart';
import 'package:sunmi_aidl_print_example/common/common.dart';


class PrintingPage extends StatefulWidget {
  @override
  State<PrintingPage> createState() => PrintingPageState();
}

class PrintingPageState extends State<PrintingPage>{
  List<SunmiPrinter> array = <SunmiPrinter>[];
  List<MenuService> menus = <MenuService>[];
  Uint8List bytes;
  
  @override
  void initState() {
    super.initState();
    _getBytesImage();
    SunmiAidlPrint.bindPrinter();
  }

  @override
  void dispose() {
    super.dispose();
    SunmiAidlPrint.unbindPrinter();
  }

  void _getBytesImage() async{
    ByteData getBytes = await rootBundle.load(config.defaultPrintLogoImage);
    Uint8List image = getBytes.buffer.asUint8List();
    setState(() => bytes = image);
  }

  void _generateMenu() {
    menus.add(new MenuService(
      name:'TEXT',
      icons: Icon(Icons.text_fields),
      onTap: () => null
    ));
  }

  void _openAlert({ String error}){
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Alert'),
        content: new Text(error),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('PRINT EXAMPLE'),
      ),
      body: new Container(
        child: BlocListener<PrintingBloc,PrintingState>(
          listener: (context,state){
            if(state is ErrorPrinting){ _openAlert(error:state.error); }
          },
          child: BlocBuilder<PrintingBloc,PrintingState>(
            builder: (context,state){
              if(state is LoadingPrinting){ return new LoadingIndicator(); }
              if(state is InitialPrinting){ 
                return new Container(
                  child: new MenuServiceState(items:menus,),
                );
              }
              if(state is LoadedPrinting){
                return new Container(
                  child: new MenuServiceState(items:menus,),
                );
              }
              
              new Container();
            },
          ),
        ),
      ),
    );
  }
}


class MenuServiceState extends StatelessWidget {
  final List<MenuService> items;
  final int crossAxis;
  MenuServiceState({ this.items, this.crossAxis=3 });
  
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(top:8.0,bottom:8.0),
      child: new GridView.builder(
        shrinkWrap: true,
        gridDelegate:new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:crossAxis),
        physics: ClampingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context,i) => new GestureDetector(
          onTap: () => items[i].onTap,
          child: new Container(
            alignment: Alignment.center,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  decoration: new BoxDecoration(
                    border: Border.all(color:Colors.grey,width:1.0),
                    borderRadius: new BorderRadius.all(new Radius.circular(20.0))
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: items[i].icons,
                ),
                new Padding(padding: EdgeInsets.only(top:6.0),),new Text("${items[i].name}")
              ],
            ),
          ),
        ),
      ),
    );
  }
}