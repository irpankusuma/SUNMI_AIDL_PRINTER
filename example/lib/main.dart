import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunmi_aidl_print_example/blocs/printing_bloc.dart';
import 'package:sunmi_aidl_print_example/repositories/repositories.dart';
import 'package:sunmi_aidl_print_example/widget/widget.dart';
import 'package:bloc/bloc.dart';
import 'package:sunmi_aidl_print_example/blocs/blocs.dart';


class SimpleBlocDeletage extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) { super.onEvent(bloc, event); }

  @override
  void onTransition(Bloc bloc, Transition transition) { super.onTransition(bloc, transition); }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) { super.onError(bloc, error, stacktrace); }
}

void main() {
  final PrintingRepository printingRepostory = PrintingRepository();
  BlocSupervisor.delegate = SimpleBlocDeletage();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PrintingBloc>(
          builder: (context) => PrintingBloc(printingRepository: printingRepostory),
        )
      ],
      child: new MobileApp()
    )
  );
}

class MobileApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUNMI AIDL PRINT',
      theme: new ThemeData(
        primaryColor: Colors.black,
        buttonColor: Color(0xFFF37028),
        bottomAppBarColor: Color(0xFF00AB7A),
        fontFamily: 'Pantone',
      ),
      home: new PrintingPage()
    );
  }
}