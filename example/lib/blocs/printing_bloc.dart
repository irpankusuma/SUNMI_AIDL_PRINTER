import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sunmi_aidl_print/models.dart';
import 'package:sunmi_aidl_print_example/repositories/repositories.dart';
import 'package:sunmi_aidl_print_example/models/models.dart';

abstract class PrintingEvent extends Equatable { PrintingEvent([List props = const[]]) : super([props]); }
abstract class PrintingState extends Equatable { PrintingState([List props = const[]]) : super([props]); }

/// EVENT
class PrintingInitial extends PrintingEvent {}
class PrintingBinding extends PrintingEvent {}
class PrintingAddAlign extends PrintingEvent { final TEXTALIGN align; PrintingAddAlign({ this.align }); }
class PrintingSetFontName extends PrintingEvent { final String fontName; PrintingSetFontName({ this.fontName }); }
class PrintingSetFontSize extends PrintingEvent { final int size; PrintingSetFontSize({ this.size }); }
class PrintingSetLineWrap extends PrintingEvent { final int line; PrintingSetLineWrap({ this.line }); }
class PrintingText extends PrintingEvent { final String text; PrintingText({ this.text }); }
class PrintingTextWithFont extends PrintingEvent { 
  final String text; 
  final String fontName;
  final int size;
  PrintingTextWithFont({ this.text, this.fontName='Times New Roman', this.size=12 }); 
}
class PrintingTextOri extends PrintingEvent { final String text; PrintingTextOri({ this.text }); }
class PrintingColumnText extends PrintingEvent {
  final List<String> text;
  final List<int> width;
  final List<int> align;
  PrintingColumnText({ this.text, this.width, this.align });
}
class PrintingQRCode extends PrintingEvent {
  final String text;
  final int moduleSize;
  final ERRORLEVEL errorlevel;
  PrintingQRCode({ this.text, this.moduleSize, this.errorlevel });
}
class PrintingBarcode extends PrintingEvent {
  final String text;
  final SYMBOLOGY symbology;
  final int width;
  final int height;
  final TEXTPOS textpos;
  PrintingBarcode({ this.text, this.symbology, this.width, this.height, this.textpos });
}
class PrintingBitmap extends PrintingEvent { final Uint8List bytes; PrintingBitmap({ this.bytes }); }
class PrintingArray extends PrintingEvent { final List<SunmiPrinter> array; PrintingArray({ @required this.array }) : assert(array != null); }
class PrintingClose extends PrintingEvent {}

/// STATE
class InitialPrinting extends PrintingState {}
class LoadingPrinting extends PrintingState {}
class LoadedPrinting extends PrintingState { final ReturnData rs; LoadedPrinting({ this.rs }); }
class ErrorPrinting extends PrintingState { final String error; ErrorPrinting({ this.error }); }

/// BLOC
class PrintingBloc extends Bloc<PrintingEvent,PrintingState>{
  final PrintingRepository printingRepository;
  PrintingBloc({ @required this.printingRepository }) : assert(printingRepository != null);

  @override
  PrintingState get initialState => InitialPrinting();

  @override
  Stream<PrintingState> mapEventToState(PrintingEvent event) async* {
    print('event => ${event.toString()}');
    if(event is PrintingInitial){
      yield LoadingPrinting();

      try {
        yield LoadedPrinting(rs:new ReturnData(
          code: 'SUCCESS',
          message: 'Please choose menu to printing.',
          status: 'Success'
        ));
      } catch (e) {
        yield ErrorPrinting(error:e.toString());
      }
    }

    if(event is PrintingText){
       yield LoadingPrinting();

      try {
        final ReturnData data = await printingRepository.printText(text:event.text);
        yield LoadedPrinting(rs:data);
      } catch (e) {
        yield ErrorPrinting(error:e.toString());
      }
    }

    if(event is PrintingBinding){
       yield LoadingPrinting();

      try {
        final ReturnData data = await printingRepository.binding();
        yield LoadedPrinting(rs:data);
      } catch (e) {
        yield ErrorPrinting(error:e.toString());
      }
    }

    if(event is PrintingClose){
       yield LoadingPrinting();

      try {
        final ReturnData data = await printingRepository.unbind();
        yield LoadedPrinting(rs:data);
      } catch (e) {
        yield ErrorPrinting(error:e.toString());
      }
    }

    if(event is PrintingQRCode){
       yield LoadingPrinting();

      try {
        final ReturnData data = await printingRepository.printQRCode(text:event.text,moduleSize:event.moduleSize,errorlevel:event.errorlevel);
        yield LoadedPrinting(rs:data);
      } catch (e) {
        yield ErrorPrinting(error:e.toString());
      }
    }

    if(event is PrintingBarcode){
       yield LoadingPrinting();

      try {
        final ReturnData data = await printingRepository.printBarcode(
          text: event.text,
          symbology: event.symbology,
          width: event.width,
          height: event.height,
          textpos: event.textpos
        );
        yield LoadedPrinting(rs:data);
      } catch (e) {
        yield ErrorPrinting(error:e.toString());
      }
    }

    if(event is PrintingArray){
       yield LoadingPrinting();

      try {
        final void data = await printingRepository.printArray(array:event.array);
        dispatch(PrintingInitial());
      } catch (e) {
        yield ErrorPrinting(error:e.toString());
      }
    }

    if(event is PrintingBitmap){
       yield LoadingPrinting();

      try {
        final ReturnData data = await printingRepository.printBitmap(bytes:event.bytes);
        dispatch(PrintingInitial());
      } catch (e) {
        yield ErrorPrinting(error:e.toString());
      }
    }
  }
}


