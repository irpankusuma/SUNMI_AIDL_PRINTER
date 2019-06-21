import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunmi_aidl_print/sunmi_aidl_print.dart';

void main() {
  const MethodChannel channel = MethodChannel('sunmi_aidl_print');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SunmiAidlPrint.platformVersion, '42');
  });
}
