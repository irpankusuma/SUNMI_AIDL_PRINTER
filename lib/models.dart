import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';

/// EXAMPLE FOR CONVERT STRING TO BYTES
/// String data = 'your data to print';
/// List<int> listToByte = data.codeUnits;              /// RETURN STRING TO INTEGER
/// Uint8List bytes = Uint8List.fromList(listToByte);   /// RETURN LIST TO BYTES 
/// String bytesToString = String.fromCharCodes(bytes); /// RETURN BYTES TO STRING
/// Future<Uint8List> stringToBytes(String data) async {
///   List<int> listToByte = data.codeUnits;              /// RETURN STRING TO INTEGER
///   Uint8List bytes = Uint8List.fromList(listToByte);   /// RETURN LIST TO BYTES 
///   String bytesToString = String.fromCharCodes(bytes); /// RETURN BYTES TO STRING
///   print("STRING ${data}");
///   print("LIST ${listToByte.toList()}");
///   print("STRING ${bytes.toString()}");
///   print("STRING ${bytesToString}");
///   return bytes;
/// }

enum GETINFO { PRINTER_SERIALNO, PRINTER_MODAL, PRINTER_VERSION, SERVICE_VERSION }
enum SYMBOLOGY { UPC_A, UPC_E, EAN_13, EAN_8, CODE_39, ITF, CODEBAR, CODE_93, CODE_128 }
enum TEXTPOS { NO_PRINT_TEXT, ABOVE_BARCODE, BELOW_BARCODE, BOTH }
enum ERRORLEVEL { L, M, Q, H }
enum TEXTALIGN { LEFT, CENTER, RIGHT }
enum SUNMI_PRINT_TYPE { TEXT, IMAGE, BARCODE, QRCODE, ENTER, ALIGN, FONT_SIZE, FONT_NAME }
enum SUNMI_FONT_NAME { COURIER, TIMES_NEW_ROMAN }

class SunmiPrinter {
  final SUNMI_PRINT_TYPE printType;
  final String printContent;
  final Uint8List printBytes;
  final SunmiPrinterOptions options;
  final int orderNo;

  SunmiPrinter({
    @required this.printType,
    this.printContent,
    this.printBytes,
    this.options,
    this.orderNo=0
  }) : assert(printType != null);
  
  factory SunmiPrinter.fromJson(Map<String,dynamic> json) => new SunmiPrinter(
    orderNo: json['OrderNo'],
    printType: json['PrintType'] == null || json['PrintType'] == '' ? SUNMI_PRINT_TYPE.TEXT
      : json['PrintType'] == 'TEXT' ? SUNMI_PRINT_TYPE.TEXT
      : json['PrintType'] == 'IMAGE' ? SUNMI_PRINT_TYPE.IMAGE
      : json['PrintType'] == 'BARCODE' ? SUNMI_PRINT_TYPE.BARCODE
      : json['PrintType'] == 'QRCODE' ? SUNMI_PRINT_TYPE.QRCODE
      : json['PrintType'] == 'ENTER' ? SUNMI_PRINT_TYPE.ENTER
      : json['PrintType'] == 'ALIGN' ? SUNMI_PRINT_TYPE.ALIGN
      : json['PrintType'] == 'FONTSIZE' ? SUNMI_PRINT_TYPE.FONT_SIZE
      : json['PrintType'] == 'FONTNAME' ? SUNMI_PRINT_TYPE.FONT_NAME
      : SUNMI_PRINT_TYPE.TEXT,
    printContent: json['PrintContent'],
    printBytes: json['PrintBytes'],
    options: new SunmiPrinterOptions(
      fontSize: json['Options']['FontSize'] ==  null || json['Options']['FontSize'] == '' ? 20 
        : json['Options']['FontSize'] > 58 ? 58
        : json['Options']['FontSize'] < 20 ? 20 
        : json['Options']['FontSize'],
      fontName: json['Options']['FontName'] == null || json['Options']['FontName'] == '' ? SUNMI_FONT_NAME.COURIER
        : json['Options']['FontName'] == 'COURIER' ? SUNMI_FONT_NAME.COURIER
        : json['Options']['FontName'] == 'TIMES_NEW_ROMAN' ? SUNMI_FONT_NAME.TIMES_NEW_ROMAN
        : SUNMI_FONT_NAME.COURIER,
      qrCodeModuleSize: json['Options']['QRCodeModuleSize'] == null || json['Options']['QRCodeModuleSize'] == '' ? 4 
        : json['Options']['QRCodeModuleSize'] < 4 ? 4 
        : json['Options']['QRCodeModuleSize'] > 16 ? 16 : json['QRCodeModuleSize'],
      qrCodeErrorLevel: json['Options']['QRCodeErrorLevel'] == null || json['Options']['QRCodeErrorLevel'] == '' ? ERRORLEVEL.M
        : json['Options']['QRCodeErrorLevel'] == 3 ? ERRORLEVEL.H
        : json['Options']['QRCodeErrorLevel'] == 0 ? ERRORLEVEL.L
        : json['Options']['QRCodeErrorLevel'] == 1 ? ERRORLEVEL.M
        : json['Options']['QRCodeErrorLevel'] == 2 ? ERRORLEVEL.Q 
        : ERRORLEVEL.M,
      barcodeHeight: json['Options']['BarcodeHeight'] == null || json['Options']['BarcodeHeight'] == '' ? 255
        : json['Options']['BarcodeHeight'] > 255 ? 255
        : json['Options']['BarcodeHeight'] < 1 ? 1
        : json['Options']['BarcodeHeight'],
      barcodeWidth: json['Options']['BarcodeWidth'] == null || json['Options']['BarcodeWidth'] == '' ? 2
        : json['Options']['BarcodeWidth'] > 6 ? 6
        : json['Options']['BarcodeWidth'] < 2 ? 2
        : json['Options']['BarcodeWidth'],
      barcodeSymbology: json['Options']['BarcodeSymbology'] == null || json['Options']['BarcodeSymbology'] == '' ? SYMBOLOGY.CODE_39
        : json['Options']['BarcodeSymbology'] == 8 ? SYMBOLOGY.CODE_128
        : json['Options']['BarcodeSymbology'] == 4 ? SYMBOLOGY.CODE_39
        : json['Options']['BarcodeSymbology'] == 7 ? SYMBOLOGY.CODE_93
        : json['Options']['BarcodeSymbology'] == 6 ? SYMBOLOGY.CODEBAR
        : json['Options']['BarcodeSymbology'] == 2 ? SYMBOLOGY.EAN_13
        : json['Options']['BarcodeSymbology'] == 3 ? SYMBOLOGY.EAN_8
        : json['Options']['BarcodeSymbology'] == 5 ? SYMBOLOGY.ITF
        : json['Options']['BarcodeSymbology'] == 0 ? SYMBOLOGY.UPC_A
        : json['Options']['BarcodeSymbology'] == 1 ? SYMBOLOGY.UPC_E
        : SYMBOLOGY.CODE_39,
      barcodeTextPosition: json['Options']['BarcodeTextPosition'] == null || json['Options']['BarcodeTextPosition'] == '' ? TEXTPOS.BELOW_BARCODE
        : json['Options']['BarcodeTextPosition'] == 0 ? TEXTPOS.BELOW_BARCODE
        : json['Options']['BarcodeTextPosition'] == 1 ? TEXTPOS.ABOVE_BARCODE
        : json['Options']['BarcodeTextPosition'] == 2 ? TEXTPOS.BOTH
        : json['Options']['BarcodeTextPosition'] == 3 ? TEXTPOS.NO_PRINT_TEXT
        : TEXTPOS.BELOW_BARCODE,
      textAlign: json['Options']['TextAlign'] == null || json['Options']['TextAlign'] == '' ? TEXTALIGN.LEFT
        : json['Options']['TextAlign'] == 0 ? TEXTALIGN.LEFT
        : json['Options']['TextAlign'] == 1 ? TEXTALIGN.CENTER
        : json['Options']['TextAlign'] == 2 ? TEXTALIGN.RIGHT
        : TEXTALIGN.LEFT,
    )
  );

  Map<String,dynamic> toJson() => {
    'OrderNo': orderNo,
    'PrintType': printType == null ? SUNMI_PRINT_TYPE.TEXT
      : printType == SUNMI_PRINT_TYPE.TEXT ? 'TEXT'   
      : printType == SUNMI_PRINT_TYPE.IMAGE ? 'IMAGE'   
      : printType == SUNMI_PRINT_TYPE.BARCODE ? 'BARCODE'
      : printType == SUNMI_PRINT_TYPE.QRCODE ? 'QRCODE' 
      : printType == SUNMI_PRINT_TYPE.ENTER ? 'ENTER'  
      : printType == SUNMI_PRINT_TYPE.ALIGN ? 'ALIGN'  
      : printType == SUNMI_PRINT_TYPE.FONT_SIZE ? 'FONTSIZE'  
      : printType == SUNMI_PRINT_TYPE.FONT_NAME ? 'FONTNAME'  
      : 'TEXT',
    'PrintContent': printContent,
    'PrintBytes': printBytes,
    'Options': options.toJson()
  };
}

class SunmiPrinterOptions {
  final int fontSize;
  final SUNMI_FONT_NAME fontName;
  final int qrCodeModuleSize;
  final ERRORLEVEL qrCodeErrorLevel;
  final SYMBOLOGY barcodeSymbology;
  final int barcodeHeight;
  final int barcodeWidth;
  final TEXTPOS barcodeTextPosition;
  final TEXTALIGN textAlign;

  SunmiPrinterOptions({
    this.fontSize=20,
    this.fontName=SUNMI_FONT_NAME.COURIER,
    this.qrCodeModuleSize=4,
    this.qrCodeErrorLevel=ERRORLEVEL.L,
    this.barcodeSymbology=SYMBOLOGY.CODE_39,
    this.barcodeTextPosition=TEXTPOS.BELOW_BARCODE,
    this.barcodeHeight=255,
    this.barcodeWidth=6,
    this.textAlign=TEXTALIGN.LEFT
  });

  factory SunmiPrinterOptions.fromJson(Map<String,dynamic> json) => new SunmiPrinterOptions(
    fontSize: json['FontSize'] ==  null || json['FontSize'] == '' ? 20 
      : json['FontSize'] > 58 ? 58
      : json['FontSize'] < 20 ? 20 
      : json['FontSize'],
    fontName: json['FontName'] == null || json['FontName'] == '' ? SUNMI_FONT_NAME.COURIER
      : json['FontName'] == 'COURIER' ? SUNMI_FONT_NAME.COURIER
      : json['FontName'] == 'TIMES_NEW_ROMAN' ? SUNMI_FONT_NAME.TIMES_NEW_ROMAN
      : SUNMI_FONT_NAME.COURIER,
    qrCodeModuleSize: json['QRCodeModuleSize'] == null || json['QRCodeModuleSize'] == '' ? 4 
      : json['QRCodeModuleSize'] < 4 ? 4 
      : json['QRCodeModuleSize'] > 16 ? 16 
      : json['QRCodeModuleSize'],
    qrCodeErrorLevel: json['QRCodeErrorLevel'] == null || json['QRCodeErrorLevel'] == '' ? ERRORLEVEL.M
      : json['QRCodeErrorLevel'] == 3 ? ERRORLEVEL.H
      : json['QRCodeErrorLevel'] == 0 ? ERRORLEVEL.L
      : json['QRCodeErrorLevel'] == 1 ? ERRORLEVEL.M
      : json['QRCodeErrorLevel'] == 2 ? ERRORLEVEL.Q 
      : ERRORLEVEL.M,
    barcodeHeight: json['BarcodeHeight'] == null || json['BarcodeHeight'] == '' ? 255
      : json['BarcodeHeight'] > 255 ? 255
      : json['BarcodeHeight'] < 1 ? 1
      : json['BarcodeHeight'],
    barcodeWidth: json['BarcodeWidth'] == null || json['BarcodeWidth'] == '' ? 2
      : json['BarcodeWidth'] > 6 ? 6
      : json['BarcodeWidth'] < 2 ? 2
      : json['BarcodeWidth'],
    barcodeSymbology: json['BarcodeSymbology'] == null || json['BarcodeSymbology'] == '' ? SYMBOLOGY.CODE_39
      : json['BarcodeSymbology'] == 8 ? SYMBOLOGY.CODE_128
      : json['BarcodeSymbology'] == 4 ? SYMBOLOGY.CODE_39
      : json['BarcodeSymbology'] == 7 ? SYMBOLOGY.CODE_93
      : json['BarcodeSymbology'] == 6 ? SYMBOLOGY.CODEBAR
      : json['BarcodeSymbology'] == 2 ? SYMBOLOGY.EAN_13
      : json['BarcodeSymbology'] == 3 ? SYMBOLOGY.EAN_8
      : json['BarcodeSymbology'] == 5 ? SYMBOLOGY.ITF
      : json['BarcodeSymbology'] == 0 ? SYMBOLOGY.UPC_A
      : json['BarcodeSymbology'] == 1 ? SYMBOLOGY.UPC_E
      : SYMBOLOGY.CODE_39,
    barcodeTextPosition: json['BarcodeTextPosition'] == null || json['BarcodeTextPosition'] == '' ? TEXTPOS.BELOW_BARCODE
      : json['BarcodeTextPosition'] == 0 ? TEXTPOS.BELOW_BARCODE
      : json['BarcodeTextPosition'] == 1 ? TEXTPOS.ABOVE_BARCODE
      : json['BarcodeTextPosition'] == 2 ? TEXTPOS.BOTH
      : json['BarcodeTextPosition'] == 3 ? TEXTPOS.NO_PRINT_TEXT
      : TEXTPOS.BELOW_BARCODE,
    textAlign: json['TextAlign'] == null || json['TextAlign'] == '' ? TEXTALIGN.LEFT
      : json['TextAlign'] == 0 ? TEXTALIGN.LEFT
      : json['TextAlign'] == 1 ? TEXTALIGN.CENTER
      : json['TextAlign'] == 2 ? TEXTALIGN.RIGHT
      : TEXTALIGN.LEFT
  );

  Map<String,dynamic> toJson() => {
    'FontSize': fontSize ==  null ? 20 
      : fontSize > 58 ? 58
      : fontSize < 20 ? 20 
      : fontSize,
    'FontName': fontName == null ? 'COURIER' 
      : fontName == SUNMI_FONT_NAME.COURIER ? 'COURIER'
      : fontName == SUNMI_FONT_NAME.TIMES_NEW_ROMAN ? 'TIMES_NEW_ROMAN'
      : 'COURIER',
    'QRCodeModuleSize': qrCodeModuleSize == null ? 4 
      : qrCodeModuleSize < 4 ? 4 
      : qrCodeModuleSize > 16 ? 16 
      : qrCodeModuleSize,
    'QRCodeErrorLevel': qrCodeErrorLevel == null ? 1
      : qrCodeErrorLevel == ERRORLEVEL.H ? 3 
      : qrCodeErrorLevel == ERRORLEVEL.L ? 0 
      : qrCodeErrorLevel == ERRORLEVEL.M ? 1 
      : qrCodeErrorLevel == ERRORLEVEL.Q ? 2  
      : 1,
    'BarcodeHeight': barcodeHeight == null ? 255
      : barcodeHeight > 255 ? 255
      : barcodeHeight < 1 ? 1
      : barcodeHeight,
    'BarcodeWidth': barcodeWidth == null ? 2
      : barcodeWidth > 6 ? 6
      : barcodeWidth < 2 ? 2
      : barcodeWidth,
    'BarcodeSymbology': barcodeSymbology == null ? 4
      : barcodeSymbology == SYMBOLOGY.CODE_128  ? 8
      : barcodeSymbology == SYMBOLOGY.CODE_39   ? 4 
      : barcodeSymbology == SYMBOLOGY.CODE_93   ? 7 
      : barcodeSymbology == SYMBOLOGY.CODEBAR   ? 6 
      : barcodeSymbology == SYMBOLOGY.EAN_13    ? 2  
      : barcodeSymbology == SYMBOLOGY.EAN_8     ? 3   
      : barcodeSymbology == SYMBOLOGY.ITF       ? 5     
      : barcodeSymbology == SYMBOLOGY.UPC_A     ? 0   
      : barcodeSymbology == SYMBOLOGY.UPC_E     ? 1   
      : 4,
    'BarcodeTextPosition': barcodeTextPosition == null ? 0
      : barcodeTextPosition == TEXTPOS.BELOW_BARCODE ? 0
      : barcodeTextPosition == TEXTPOS.ABOVE_BARCODE ? 1
      : barcodeTextPosition == TEXTPOS.BOTH ? 2 
      : barcodeTextPosition == TEXTPOS.NO_PRINT_TEXT ? 3   
      : 0,
    'TextAlign': textAlign == null ? 0
      : textAlign == TEXTALIGN.LEFT ? 0  
      : textAlign == TEXTALIGN.CENTER ? 1
      : textAlign == TEXTALIGN.RIGHT ? 2
      : 0
  };
}
