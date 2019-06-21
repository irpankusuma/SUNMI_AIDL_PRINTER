# sunmi_aidl_print

A new flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

## Device Model
<span>
  TESTED ON
</span>
<ul>
  <li>V2 PRO</li>
  <li>P1 (4G)</li>
</ul>


## How To Use
<code>
  // 1. bindservice 
  @override
  void initState() {
    super.initState();
    SunmiAidlPrint.bindPrinter();
  }

  

</code>
