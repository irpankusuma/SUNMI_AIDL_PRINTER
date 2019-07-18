import 'dart:async';
import 'package:meta/meta.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class ResultStatus {
  final int statusCode;
  final String statusMessage;
  
  const ResultStatus({ this.statusCode,this.statusMessage });
}

class SunmiAidlPrint {
  static const MethodChannel _channel = const MethodChannel('sunmi_aidl_print');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // INFORMATION
  static Future<dynamic> getPrinterInfo({GETINFO code}) async {
    Map<String,dynamic> args = <String,dynamic>{};
     
    if(code == GETINFO.PRINTER_SERIALNO){
      args.putIfAbsent("code", () => 1);  
    } else if(code == GETINFO.PRINTER_MODAL){
      args.putIfAbsent("code", () => 2);  
    } else if(code == GETINFO.PRINTER_VERSION){
      args.putIfAbsent("code", () => 3);  
    }else if(code == GETINFO.SERVICE_VERSION){
      args.putIfAbsent("code", () => 4);  
    } else {
      return "No Information found";
    }

    return await _channel.invokeMethod("getInfo",args);
  }

  // PRINTER INITIAL
  static Future<Null> initPrinter() async { await _channel.invokeMethod("initPrinter"); }
  static Future<Null> bindPrinter() async { await _channel.invokeMethod("bindPrinter"); }
  static Future<Null> unbindPrinter() async { await _channel.invokeMethod("unbindPrinter"); }
  static Future<Null> selfCheckingPrinter() async { await _channel.invokeMethod("selfCheckingPrinter"); }

  // STANDAR FUNCTION
  static Future<Null> setAlignment({ TEXTALIGN align }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("alignment", () => align == TEXTALIGN.LEFT ? 0 
      : align == TEXTALIGN.CENTER ? 1 
      : align == TEXTALIGN.RIGHT ? 2 
      : 0);
    await _channel.invokeMethod("setAlignment",args);
  }

  static Future<Null> setFontName({ String fontName }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("fontName", () => fontName);
    await _channel.invokeMethod("setFontName",args);
  }

  static Future<Null> setFontSize({ int fontSize }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("fontSize", () => fontSize);
    await _channel.invokeMethod("setFontSize",args);
  }

  static Future<Null> setLineWrap({ int line }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("line", () => line);
    await _channel.invokeMethod("setLineWrap",args);
  }

  static Future<Null> printText({ String text }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("text", () => text);
    await _channel.invokeMethod("printText",args);
  }

  static Future<Null> printTextWithFont({ String text, String fontName, int fontSize }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("text", () => text);
    args.putIfAbsent("fontName", () => fontName);
    args.putIfAbsent("fontSize", () => fontSize);
    await _channel.invokeMethod("printTextWithFont",args);
  }

  static Future<Null> printTextOriginal({ String text }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("text", () => text);
    await _channel.invokeMethod("printOriginalText",args);
  }

  static Future<Null> printColumnText({ List<String> text, List<int> width, List<int> align }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("text", () => text);
    args.putIfAbsent("width", () => width);
    args.putIfAbsent("align", () => align);
    await _channel.invokeMethod("printColumnText",args);
  }

  static Future<Null> printQRCodeZXING({ String text, int size }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("text", () => text);
    args.putIfAbsent("size", () => size);
    await _channel.invokeMethod("printQRCodeZXING",args);
  }

  static Future<Null> printQRCode({ String text, int moduleSize, ERRORLEVEL errorLevel }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("text", () => text);
    args.putIfAbsent("moduleSize", () => moduleSize > 16 ? 16 : moduleSize < 4 ? 4 : 4);
    args.putIfAbsent("errorLevel", () => errorLevel == ERRORLEVEL.L ? 0
      : errorLevel == ERRORLEVEL.M ? 1
      : errorLevel == ERRORLEVEL.Q ? 2
      : errorLevel == ERRORLEVEL.H ? 3
      : 0);
    await _channel.invokeMethod("printQRCode",args);
  }

  static Future<Null> printBarcode({ String text, SYMBOLOGY symbology, int height, int width, TEXTPOS textPosition }) async {
    Map<String,dynamic> args = <String,dynamic>{};

    args.putIfAbsent("text", () => text);
    args.putIfAbsent("symbology", () => symbology == SYMBOLOGY.UPC_A ? 0
      : symbology == SYMBOLOGY.UPC_E ? 1
      : symbology == SYMBOLOGY.EAN_13 ? 2
      : symbology == SYMBOLOGY.EAN_8 ? 3
      : symbology == SYMBOLOGY.CODE_39 ? 4
      : symbology == SYMBOLOGY.ITF ? 5 
      : symbology == SYMBOLOGY.CODEBAR ? 6
      : symbology == SYMBOLOGY.CODE_93 ? 7
      : symbology == SYMBOLOGY.CODE_128 ? 8 
      : 4);
    args.putIfAbsent("height", () => height > 255 ? 255 : height < 1 ? 1 : height);
    args.putIfAbsent("width", () => width > 6 ? 6 : width < 2 ? 2 : width);
    args.putIfAbsent("textPosition", () => textPosition == TEXTPOS.NO_PRINT_TEXT ? 0 
      : textPosition == TEXTPOS.ABOVE_BARCODE ? 1 
      : textPosition == TEXTPOS.BELOW_BARCODE ? 2
      : textPosition == TEXTPOS.BOTH ? 3 
      : 0);
    await _channel.invokeMethod("printBarcode",args);
  }

  static Future<Null> printBitmap({ Uint8List bitmap }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("bitmap", () => bitmap);
    await _channel.invokeMethod("printBitmap",args);
  }

  static Future<Null> nextLine({ int line }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("line", () => line);
    await _channel.invokeMethod("nextLine",args);
  }

  static Future<Null> initBlackBox({ int width, int height }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("width", () => width);
    args.putIfAbsent("height", () => height);

    await _channel.invokeMethod("initBlackBox",args);
  }

  static Future<Null> initGrayBox({ int width, int height }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("width", () => width);
    args.putIfAbsent("height", () => height);

    await _channel.invokeMethod("initGrayBox",args);
  }

  static Future<Null> initTable({ int width, int height }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("width", () => width);
    args.putIfAbsent("height", () => height);

    await _channel.invokeMethod("initTable",args);
  }

  static Future<Null> underline1Dot() async {
    await _channel.invokeMethod("underline1Dot");
  }

  static Future<Null> underline2Dot() async {
    await _channel.invokeMethod("underline2Dot");
  }

  static Future<Null> underlineOff() async {
    await _channel.invokeMethod("underlineOff");
  }

  static Future<Null> boldOn() async {
    await _channel.invokeMethod("boldOn");
  }

  static Future<Null> boldOff() async {
    await _channel.invokeMethod("boldOff");
  }

  /**
   * Cashlezz
   */
  static Future<ResultStatus> clz_doLogin({ @required String username, @required String pin }) async {
    Map<String,dynamic> args = <String,dynamic>{};
    args.putIfAbsent("username", () => username);
    args.putIfAbsent("pin", () => pin);

    Map<dynamic,dynamic> _result = await _channel.invokeMethod("clz_doLogin",args);
    return new ResultStatus(statusCode:_result['StatusCode'],statusMessage:_result['StatusMessage']);
  }




}


enum GETINFO { PRINTER_SERIALNO, PRINTER_MODAL, PRINTER_VERSION, SERVICE_VERSION }
enum SYMBOLOGY { UPC_A, UPC_E, EAN_13, EAN_8, CODE_39, ITF, CODEBAR, CODE_93, CODE_128 }
enum TEXTPOS { NO_PRINT_TEXT, ABOVE_BARCODE, BELOW_BARCODE, BOTH }
enum ERRORLEVEL { L, M, Q, H }
enum TEXTALIGN { LEFT, CENTER, RIGHT }