package asriworks.com.sunmi_aidl_print;

import android.app.Activity;
import android.graphics.Bitmap;
import android.widget.Toast;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** WOYOU **/
import android.content.Intent;
import woyou.aidlservice.jiuiv5.*;
import android.content.ComponentName;
import android.content.Context;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;

/** SunmiAidlPrintPlugin */
public class SunmiAidlPrintPlugin implements MethodCallHandler {
  private final MethodChannel channel;
  private Activity activity;
  private static final String TAG = "SUNMI_AIDL_PRINT";

  private IWoyouService woyouService;
  private ICallback callback = null;
  private Context context;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "sunmi_aidl_print");
    channel.setMethodCallHandler(new SunmiAidlPrintPlugin(registrar.activity(),channel,registrar.context()));
  }

  /**
   *
   * @param activity
   * @param channel
   * @param context
   */
  private SunmiAidlPrintPlugin(Activity activity, MethodChannel channel, Context context){
    this.activity = activity;
    this.channel = channel;
    this.channel.setMethodCallHandler(this);
    this.context = context; //not used when using onCreate
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) { result.success("Android " + android.os.Build.VERSION.RELEASE); }

    // INFORMATION
    else if(call.method.equals("getInfo")){
      int code = call.argument("code");
      result.success(this.getInfo(code));
    }

    // PRINTER INITIAL AND BINDING UNBINDING
    else if(call.method.equals("initPrinter")){ this.initPrinter(); }
    else if(call.method.equals("bindPrinter")){ this.bindingService(); }
    else if(call.method.equals("unbindPrinter")){ this.unBindService(); }
    else if(call.method.equals("selfCheckingPrinter")){ this.selfChecking(); }

    // STANDAR FUNCTION
    else if(call.method.equals("setAlignment")){
      int alignment = call.argument("alignment");
      this.setAlignment(alignment);
    }
    else if(call.method.equals("setFontName")){
      String fontName = call.argument("fontName");
      this.setFontName(fontName);
    }
    else if(call.method.equals("setFontSize")){
      int fontSize = call.argument("fontSize");
      this.setFontSize(fontSize);
    }
    else if(call.method.equals("setLineWrap")){
      int line = call.argument("line");
      this.setLineWrap(line);
    }
    else if(call.method.equals("printText")){
      String text = call.argument("text");
      this.printText(text);
    }
    else if(call.method.equals("printTextWithFont")){
      String text = call.argument("text");
      String fontName = call.argument("fontName");
      int fontSize = call.argument("fontSize");
      this.printTextWithFont(text,fontName,fontSize);
    }
    else if(call.method.equals("printOriginalText")){
      String text = call.argument("text");
      this.printOriText(text);
    }
    else if(call.method.equals("printColumnText")){
      String[] text = call.argument("text");
      int[] width = call.argument("width");
      int[] align = call.argument("align");
      this.printColumnText(text,width,align);
    }
    else if(call.method.equals("printQRCodeZXING")){
      String text = call.argument("text");
      int size = call.argument("size");
      this.printQRCodeWithZxing(text,size);
    }
    else if(call.method.equals("printQRCode")){
      String text = call.argument("text");
      int moduleSize = call.argument("moduleSize");
      int errorLevel = call.argument("errorLevel");
      this.printQRCode(text,moduleSize,errorLevel);
    }
    else if(call.method.equals("printBarcode")){
      String text = call.argument("text");
      int symbology = call.argument("symbology");
      int height = call.argument("height");
      int width = call.argument("width");
      int position = call.argument("textPosition");
      this.printBarcode(text,symbology,height,width,position);
    }
    else if(call.method.equals("printBitmap")){
      Bitmap bitmap = call.argument("bitmap");
      this.printBitmap(bitmap);
    }

    // NOT FOUND
    else { result.notImplemented(); }
  }

  /**
   * ================================== BINDING/UNBIND APPLICATION =================================
   */
  public void bindingService(){
    callback = new ICallback.Stub() {
      @Override
      public void onRunResult(boolean isSuccess) throws RemoteException {
        activity.runOnUiThread(new Runnable() {
          @Override
          public void run() {
            Toast.makeText(activity,"Printing...",Toast.LENGTH_LONG);
          }
        });
      }

      @Override
      public void onReturnString(final String result) throws RemoteException {
        activity.runOnUiThread(new Runnable() {
          @Override
          public void run() {
            Toast.makeText(activity,result,Toast.LENGTH_LONG);
          }
        });
      }

      @Override
      public void onRaiseException(int code, final String msg) throws RemoteException {
        activity.runOnUiThread(new Runnable() {
          @Override
          public void run() {
            Toast.makeText(activity,msg,Toast.LENGTH_LONG).show();
          }
        });
      }
    };

    Intent intent = new Intent();
    intent.setPackage("woyou.aidlservice.jiuiv5");
    intent.setAction("woyou.aidlservice.jiuiv5.IWoyouService");
    context.startService(intent);
    context.bindService(intent,connService,Context.BIND_AUTO_CREATE);
  }
  public void unBindService(){
    this.context.unbindService(connService);
    activity.runOnUiThread(new Runnable() {
      @Override
      public void run() {
        Toast.makeText(activity,"Service disconnected, success.",Toast.LENGTH_LONG).show();
      }
    });
  }

  /**
   * ========================================= SERVICE CONNECTION ==================================
   */
  private ServiceConnection connService = new ServiceConnection() {
    @Override
    public void onServiceDisconnected(ComponentName name) {
      Toast.makeText(activity,"Service disconnected, please try again.",Toast.LENGTH_LONG).show();
      woyouService = null;
      try {
        Thread.sleep(2000);
      } catch (InterruptedException e){
        e.printStackTrace();
      }
    }

    @Override
    public void onServiceConnected(ComponentName name, IBinder service) {
      woyouService = IWoyouService.Stub.asInterface(service);
      try {
        Toast.makeText(activity,"Service connected. (version "+ woyouService.getServiceVersion()+")",Toast.LENGTH_LONG).show();
      } catch (RemoteException e){
        e.printStackTrace();
      }
    }
  };

  /**
   * ========================================= SUNMI AIDL FUNCTION =================================
   */
  /**
   * Reset all configuration such as typography, bolding, etc
   * Don't clear cache, so the unfinished printing will continue after the reset
   */
  public void initPrinter(){
    ThreadPoolManager.getInstance().executeTask(new Runnable(){
      @Override
      public void run() {
        try {
          woyouService.printerInit(callback);
        } catch (RemoteException e) {
          e.printStackTrace();
        }
      }
    });
  }

  /**
   *
   */
  public void selfChecking(){
    ThreadPoolManager.getInstance().executeTask(new Runnable(){
      @Override
      public void run() {
        try {
          woyouService.printerSelfChecking(callback);
        } catch (RemoteException e) {
          e.printStackTrace();
        }
      }
    });
  }

  /**
   *
   * @param code 1,2,3,4
   * @return String
   */
  public String getInfo(int code){
    String output = null;
    try {
      if(code == 1){
        output = this.woyouService.getPrinterSerialNo();
      } else if(code == 2){
        output = this.woyouService.getPrinterModal();
      } else if(code == 3){
        output = this.woyouService.getPrinterVersion();
      } else if(code == 4){
        output = this.woyouService.getServiceVersion();
      } else {
        output = "No information found.";
      }
      return output;
    } catch (RemoteException e){
      e.printStackTrace();
      return output;
    }
  }

  /**
   *
   * @param bytes
   */
  public void sendRAWData(final byte[] bytes){
    ThreadPoolManager.getInstance().executeTask(new Runnable() {
      @Override
      public void run() {
        try {
          woyouService.sendRAWData(bytes,callback);
        } catch (RemoteException e){
          e.printStackTrace();
        }
      }
    });
  }

  /**
   *
   * @param alignment
   */
  public void setAlignment(final int alignment){
    ThreadPoolManager.getInstance().executeTask(new Runnable() {
      @Override
      public void run() {
        try {
          woyouService.setAlignment(alignment, callback);
        } catch (RemoteException e){
          e.printStackTrace();
        }
      }
    });
  }

  /**
   *
   * @param fontName
   */
  public void setFontName(final String fontName){
    ThreadPoolManager.getInstance().executeTask(new Runnable() {
      @Override
      public void run() {
        try {
          woyouService.setFontName(fontName,callback);
        } catch (RemoteException e){
          e.printStackTrace();
        }
      }
    });
  }

  /**
   *
   * @param fontSize
   */
  public void setFontSize(final float fontSize){
    ThreadPoolManager.getInstance().executeTask(new Runnable() {
      @Override
      public void run() {
        try {
          woyouService.setFontSize(fontSize,callback);
        } catch (final RemoteException e){
          activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
              e.printStackTrace();
            }
          });
        }
      }
    });
  }

  /**
   *
   * @param line
   */
  public void setLineWrap(final int line){
    ThreadPoolManager.getInstance().executeTask(new Runnable() {
      @Override
      public void run() {
        try {
          woyouService.lineWrap(line,callback);
        } catch (RemoteException e){
          e.printStackTrace();
        }
      }
    });
  }

  /**
   *
   * @param text
   */
  public void printText(final String text){
    ThreadPoolManager.getInstance().executeTask(new Runnable() {
      @Override
      public void run() {
        try {
          woyouService.printText(text,callback);
        } catch (RemoteException e){
          e.printStackTrace();
        }
      }
    });
  }

  /**
   *
   * @param text
   */
  public void printOriText(final String text){
    ThreadPoolManager.getInstance().executeTask(new Runnable() {
      @Override
      public void run() {
        try {
          woyouService.printOriginalText(text,callback);
        } catch (RemoteException e){
          e.printStackTrace();
        }
      }
    });
  }

  /**
   *
   * @param text
   * @param fontName
   * @param fontSize
   */
  public void printTextWithFont(final String text, final String fontName, final float fontSize){
    ThreadPoolManager.getInstance().executeTask(new Runnable() {
      @Override
      public void run() {
        try {
          woyouService.printTextWithFont(text,fontName,fontSize,callback);
        } catch (RemoteException e){
          e.printStackTrace();
        }
      }
    });
  }

  /**
   * Unsupported Arabic
   * @param textArray
   * @param widthArray
   * @param alignArray
   */
  public void printColumnText(final String[] textArray, final int[] widthArray, final int[] alignArray){
    ThreadPoolManager.getInstance().executeTask(new Runnable() {
      @Override
      public void run() {
        try {
          woyouService.printColumnsText(textArray,widthArray,alignArray,callback);
        } catch (RemoteException e){
          e.printStackTrace();
        }
      }
    });
  }

  /**
   *
   * @param bitmap
   */
  public void printBitmap(final Bitmap bitmap){
    ThreadPoolManager.getInstance().executeTask(new Runnable() {
      @Override
      public void run() {
        try {
          woyouService.printBitmap(bitmap,callback);
        } catch (RemoteException e){
          e.printStackTrace();
        }
      }
    });
  }

  /**
   *
   * @param data
   * @param size
   */
  public void printQRCodeWithZxing(final String data, final int size){
    ThreadPoolManager.getInstance().executeTask(new Runnable() {
      @Override
      public void run() {
        try {
          byte[] bytes = BytesUtil.getZXingQRCode(data,size);
          woyouService.sendRAWData(bytes,callback);
        } catch (RemoteException e){
          e.printStackTrace();
        }
      }
    });
  }

  /**
   *
   * @param data
   * @param moduleSize
   * @param errorLevel
   * Data →qr code content.
   * Modulesize →qr code block size, unit: dot, values 4 to 16.
   * Errorlevel qr code error correction level (0-3) :
   * 0→ error correction level L (7%)
   * 1→error correction level M (15%)
   * 2→ error correction level Q (25%)
   * 3→error correction level H (30%)
   */
  public void printQRCode(final String data, final int moduleSize, final int errorLevel){
    ThreadPoolManager.getInstance().executeTask(new Runnable() {
      @Override
      public void run() {
        try {
          woyouService.printQRCode(data,moduleSize,errorLevel,callback);
        } catch (RemoteException e){
          e.printStackTrace();
        }
      }
    });
  }

  /**
   *
   * @param data
   * @param symbology 0 -> 8
   * @param height 1 - 255, default 162
   * @param width 2 - 6, default 2
   * @param textpos 0 - 3 : 0 →no print text, 1→ above the barcode, 2→ below the barcode, 3→ both
   *                Data →one-dimensional code content.
   * 上海商米科技有限公司打印机开发者文档
   * - 13 -
   * Symbology→ barcode type (0-8) :
   * 0 → UPC-A
   * 1 → UPC-E
   * 2 → JAN13(EAN13)
   * 3 → JAN8(EAN8)
   * 4 → CODE39
   * 5 → ITF
   * 6 → CODABAR
   * 7 → CODE93
   * 8 → CODE128
   * Height →bar code height, value 1-255, default: 162.
   * Width →bar code width, value 2-6, default: 2.
   * TextPosition →text Position (0-3) :
   * 0 →no print text
   * 1→ above the barcode
   * 2→ below the barcode
   * 3→ both
   */
  public void printBarcode(final String data, final int symbology, final int height, final int width, final int textpos){
    ThreadPoolManager.getInstance().executeTask(new Runnable() {
      @Override
      public void run() {
        try {
          woyouService.printBarCode(data, symbology, height, width, textpos, callback);
        } catch (RemoteException e){
          e.printStackTrace();
        }
      }
    });
  }

}
