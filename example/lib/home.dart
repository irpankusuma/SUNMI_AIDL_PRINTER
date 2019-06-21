import 'package:flutter/material.dart';
import 'package:sunmi_aidl_print/sunmi_aidl_print.dart';

class Menu {
  final Icon icon;
  final Text text;
  final VoidCallback onPressed;

  const Menu({ this.icon, this.text, this.onPressed });
}

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Menu> _menu = <Menu>[];
  
  @override
  void initState() {
    super.initState();

    SunmiAidlPrint.bindPrinter();
    // INFORMATION
    _menu.add(new Menu(icon:Icon(Icons.info,size:54.0,color:Colors.blue,),text:Text('GET INFO'),onPressed:() async => Navigator.pushNamed(context,'/info')));

    // BINDING
    _menu.add(new Menu(icon:Icon(Icons.print,size:54.0,color: Colors.green,),text:Text('CONNECT/BINDING'),onPressed:() async => await SunmiAidlPrint.bindPrinter()));
    _menu.add(new Menu(icon:Icon(Icons.delete_sweep,size:54.0,color: Colors.grey,),text:Text('RESET CONFIG PRINTER'),onPressed:() => SunmiAidlPrint.initPrinter()));
    _menu.add(new Menu(icon:Icon(Icons.accessibility_new,size:54.0,),text:Text('SELF CHECKING'),onPressed:() => SunmiAidlPrint.selfCheckingPrinter()));

    //STANDAR FUNCTION
    _menu.add(new Menu(icon:Icon(Icons.assignment,size:54.0,color: Colors.amber),text:Text('SET CONFIG'),onPressed:() => Navigator.pushNamed(context,'/set_printer')));
    _menu.add(new Menu(icon:Icon(Icons.print,size:54.0,color: Colors.cyan,),text:Text('EXAMPLE PRINT'),onPressed:() => Navigator.pushNamed(context,'/example_print')));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('SUNMI AIDL PRINTER'),
      ),
      body: new Container(
        child: new GridView.builder(
          itemCount: _menu.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2),
          itemBuilder: (BuildContext context, int i){
            return new CustomGridButton(
              icon: _menu[i].icon,
              text: _menu[i].text,
              onPressed: _menu[i].onPressed,
            );
          },
        ),
      )
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


