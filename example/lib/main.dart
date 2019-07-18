import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sunmi_aidl_print_example/routes.dart';
import 'package:sunmi_aidl_print_example/core/colors.dart';
import 'package:sunmi_aidl_print_example/core/lib.dart';
import 'package:sunmi_aidl_print_example/core/splash.dart';

void main() async {
  print('Initializing system...');
  debugPaintSizeEnabled = false;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  LibMe<dynamic> m = new LibMe();
  
  runApp(MobileApp(isAuth: await m.isAuth()));
}

class MobileApp extends StatelessWidget {
  final bool isAuth;
  const MobileApp({ @required this.isAuth });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData base = ThemeData.light();
    return new MaterialApp(
      theme: new ThemeData(
        primaryColor: kShrineBlack80,
        buttonColor: kShrineBlack80,
        primaryIconTheme: _customIconTheme(base.iconTheme),
        textTheme: _buildShrineTextTheme(base.textTheme),
        primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
        accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
        iconTheme: _customIconTheme(base.iconTheme),
      ),
      home: isAuth
          ? new SplashView(
              image: AssetImage('assets/images/gwk-logo.png'),
              to: '/preorder',
            )
          : new SplashView(
              image: AssetImage('assets/images/gwk-logo.png'),
              to: '/preorder',
            ),
      routes: routes(isAuth)
    );
  }
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: kShrineWhite100);
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base.copyWith(
    headline: base.headline.copyWith(fontWeight: FontWeight.w500),
    title: base.title.copyWith(fontSize: 18.0),
    caption: base.caption.copyWith(fontWeight: FontWeight.w400, fontSize: 14.0),
    body2: base.body2.copyWith(fontWeight: FontWeight.w500, fontSize: 16.0),
    button: base.button.copyWith(fontWeight: FontWeight.w500, fontSize: 14.0),
  ).apply(
    fontFamily: 'Raleway',
  );
}

const ColorScheme kShrineColorScheme = ColorScheme(
  primary: kShrineBlack80,
  primaryVariant: kShrineWhite100,
  secondary: kShrinePink50,
  secondaryVariant: kShrineWhite100,
  surface: kShrineSurfaceWhite,
  background: kShrineBackgroundWhite,
  error: kShrineErrorRed,
  onPrimary: kShrineWhite100,
  onSecondary: kShrineWhite100,
  onSurface: kShrineWhite100,
  onBackground: kShrineWhite100,
  onError: kShrineSurfaceWhite,
  brightness: Brightness.dark,
);

