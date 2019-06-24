
import 'package:sunmi_aidl_print_example/example_print.dart';
import 'package:sunmi_aidl_print_example/info.dart';
import 'package:sunmi_aidl_print_example/home.dart';
import 'package:sunmi_aidl_print_example/set_config.dart';
import 'package:sunmi_aidl_print_example/printStruk.dart';


dynamic routes(){
  return {
    '/': (ctx) => new HomeView(),
    '/info': (ctx) => new GetInfo_View(),
    '/example_print': (ctx) => new ExamplePrint_View(),
    '/set_printer': (ctx) => new SetConfig_View(),
    '/print':(ctx) => new PrintStrukView() 
  };
}