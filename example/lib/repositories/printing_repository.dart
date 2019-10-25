import 'dart:typed_data';
import 'package:sunmi_aidl_print/models.dart';
import 'package:sunmi_aidl_print/sunmi_aidl_print.dart';
import 'package:sunmi_aidl_print_example/models/models.dart';

class PrintingRepository {

  Future<ReturnData> binding() async => await SunmiAidlPrint.bindPrinter();
  Future<ReturnData> unbind() async => await SunmiAidlPrint.unbindPrinter();
  Future<ReturnData> printText({ String text }) async => await SunmiAidlPrint.printText(text:text);
  Future<void> printArray({ List<SunmiPrinter> array }) async => await SunmiAidlPrint.printArray(array:array);
  Future<ReturnData> printQRCode({ String text, int moduleSize, ERRORLEVEL errorlevel }) async => await SunmiAidlPrint.printQRCode(text:text,moduleSize:moduleSize,errorLevel:errorlevel);
  Future<ReturnData> printBarcode({ String text, SYMBOLOGY symbology, int width, int height, TEXTPOS textpos }) async => await SunmiAidlPrint.printBarcode(text:text,symbology:symbology,width:width,height:height,textPosition:textpos);
  Future<ReturnData> printBitmap({ Uint8List bytes }) async => await SunmiAidlPrint.printBitmap(bitmap:bytes);
}