import 'package:flutter/material.dart';
import 'package:sunmi_aidl_print_example/core/toast.dart';
import 'package:sunmi_aidl_print_example/component/Widget.dart';
import 'package:sunmi_aidl_print_example/core/colors.dart';
import 'package:sunmi_aidl_print_example/core/focus.dart';
import 'package:sunmi_aidl_print_example/core/constructor.dart';
import 'package:sunmi_aidl_print/sunmi_aidl_print.dart';

enum E_CaraBayar {
  CASH,
  DEBIT_CARD,
  CREDIT_CARD,
  DIMOPAY,
  TCASH,
  OVO,
  GOJEK
}

// enum E_TransactionType {
//   CASH,               //0
//   DEBIT_PIN,          //1
//   DEBIT_SIGNATURE,    //2
//   CREDIT_PIN,         //3  
//   CREDIT_SIGNATURE,   //4
//   LOCAL_PIN,          //5
//   LOCAL_NOPIN,        //6
//   INTERNATIONAL       //7
// }

class CaraBayarView extends StatefulWidget {
  final E_CaraBayar carabayar; 
  
  CaraBayarView({Key key, this.carabayar }) : super(key: key);
  _CaraBayarViewState createState() => _CaraBayarViewState();
}

class _CaraBayarViewState extends State<CaraBayarView> {
  String caraBayar;
  TextEditingController _ovo_phoneNo = new TextEditingController();     //OVO
  TextEditingController _gojek_phoneNo = new TextEditingController();   //GOJEK
  TextEditingController _debit_pin = new TextEditingController();       //DEBIT
  // DEBIT SIGNATURE
  TextEditingController _creditcard_pin = new TextEditingController();  //CC PIN
  // CREDIT SIGNATURE
  TextEditingController _local_pin = new TextEditingController();
  TextEditingController _local_nopin = new TextEditingController();
  // LOCAL PIN DAN NO PIN GAK NGERTI
  TextEditingController _all_desc = new TextEditingController();
  TextEditingController _all_amount = new TextEditingController();


  
  @override
  void initState() { 
    super.initState();
    this.getCaraBayarName();
  }
  
  @override
  void dispose() { 
    super.dispose();
  }

  void getCaraBayarName(){
    switch (widget.carabayar) {
      case E_CaraBayar.CASH:
        setState(() => this.caraBayar = "CASH");
        break;
      case E_CaraBayar.CREDIT_CARD:
        setState(() => this.caraBayar = "CREDIT CARD");
        break;
      case E_CaraBayar.DEBIT_CARD:
        setState(() => this.caraBayar = "DEBIT CARD");
        break;
      case E_CaraBayar.DIMOPAY:
        setState(() => this.caraBayar = "DIMOPAY");
        break;
      case E_CaraBayar.TCASH:
        setState(() => this.caraBayar = "TCASH");
        break;
      case E_CaraBayar.OVO:
        setState(() => this.caraBayar = "OVO");
        break;
      case E_CaraBayar.GOJEK:
        setState(() => this.caraBayar = "GOJECK");
        break;
      default:
    }
  }
  
  
  



  


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(this.caraBayar),
      ),
      body: new Container(
        child: new ListView(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}