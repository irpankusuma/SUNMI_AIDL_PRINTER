package asriworks.com.sunmi_aidl_print;

import android.app.Activity;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import asriworks.com.sunmi_aidl_print.cashlez.Cashlez_State;
import asriworks.com.sunmi_aidl_print.cashlez.activation.Cashlez_Activation;
import asriworks.com.sunmi_aidl_print.cashlez.changepin.Cashlez_ChangePin;
import asriworks.com.sunmi_aidl_print.cashlez.device.Cashlez_Printer;
import asriworks.com.sunmi_aidl_print.cashlez.history.Cashlez_PaymentHistory;
import asriworks.com.sunmi_aidl_print.cashlez.login.Cashlez_Login;
import asriworks.com.sunmi_aidl_print.cashlez.ovo.Cashlez_Ovo;
import asriworks.com.sunmi_aidl_print.cashlez.payment.Cashlez_BasePayment;
import asriworks.com.sunmi_aidl_print.util.Util;
import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** WOYOU SUNMI **/
import android.content.Intent;
import woyou.aidlservice.jiuiv5.*;
import android.content.ComponentName;
import android.content.Context;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.os.RemoteException;

import com.cashlez.android.sdk.CLCardProcessingMode;
import com.cashlez.android.sdk.CLPayment;
import com.cashlez.android.sdk.CLPaymentCapability;
import com.cashlez.android.sdk.bean.TransactionType;
import com.cashlez.android.sdk.model.CLPrintObject;
import com.cashlez.android.sdk.payment.CLVerificationMode;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.HashMap;


/** SunmiAidlPrintPlugin */
public class SunmiAidlPrintPlugin implements MethodCallHandler {
  private static final String TAG = SunmiAidlPrintPlugin.class.getSimpleName();
  private final MethodChannel channel;
  private Activity activity;
  private Util util;

  private SharedPreferences sharedPreferences;
  protected static final String STATUS_CODE = "StatusCode";
  protected static final String STATUS_MESSAGE = "StatusMessage";
  protected static final String CLPAYMENT_CAPABILITY = "ClPaymentCapability";
  protected static final String CLPAYMENT_HISTORY_LIST = "ClPaymentHistoryList";
  protected static final String CLPAYMENT = "ClPayment";
  protected static final String CLPAYMENT_RESPONSE = "ClPaymentResponse";
  protected static final String CLREADER_COMPANION = "ClReaderCompanion";
  protected static final String CLTCASH_RESPONSE = "ClTCachResponse";
  protected static final String ClDIMO_RESPONSE = "ClDimoResponse";
  protected static final String CLMANDIRI_PAY_RESPONSE = "ClMandiriPayResponse";
  protected static final String CLTRANSFER_DETAIL = "ClTransferDetail";


  /** SUNMI WOYOU **/
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
    this.context = context;         // not used when using onCreate
    this.util = new Util(activity,context); // data callback ditampung di util buat diambil
    this.sharedPreferences = activity.getSharedPreferences("GWK_EKIOS",Context.MODE_PRIVATE);
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
    else if(call.method.equals("printQRCode")){
      String text = call.argument("text");
      int moduleSize = call.argument("moduleSize");
      int errorLevel = call.argument("errorLevel");
      byte[] bytes = BytesUtil.getPrintQRCode(text,moduleSize,errorLevel);
      try {
        woyouService.sendRAWData(bytes,callback);
      } catch (Exception e){
        e.printStackTrace();
      }
    }
    else if(call.method.equals("printBarcode")){
      String text = call.argument("text");
      int symbology = call.argument("symbology");
      int height = call.argument("height");
      int width = call.argument("width");
      int position = call.argument("textPosition");
      byte[] bytes = BytesUtil.getPrintBarCode(text,symbology,height,width,position);
      try {
        woyouService.sendRAWData(bytes,callback);
      } catch (Exception e){
        e.printStackTrace();
      }
    }
    else if(call.method.equals("printBitmap")){
      byte[] bytes = call.argument("bitmap");
      Bitmap bitmap = BitmapFactory.decodeByteArray(bytes,0,bytes.length);
      this.printBitmap(bitmap);
    }
    else if(call.method.equals("nextLine")){
        int line = call.argument("line");
        try {
            byte[] bytes = BytesUtil.nextLine(line);
            woyouService.sendRAWData(bytes,callback);
        } catch (Exception e){
            e.printStackTrace();
        }
    }
    else if(call.method.equals("initBlackBox")){
        int w = call.argument("width");
        int h = call.argument("height");
        try {
            byte[] bytes = BytesUtil.initBlackBlock(w,h);
            woyouService.sendRAWData(bytes,callback);
        } catch (Exception e){
            e.printStackTrace();
        }
    }
    else if(call.method.equals("initGrayBox")){
        int w = call.argument("width");
        int h = call.argument("height");
        try {
            byte[] bytes = BytesUtil.initGrayBlock(w,h);
            woyouService.sendRAWData(bytes,callback);
        } catch (Exception e){
            e.printStackTrace();
        }
    }
    else if(call.method.equals("initTable")){
        int w = call.argument("width");
        int h = call.argument("height");
        try {
            byte[] bytes = BytesUtil.initTable(w,h);
            woyouService.sendRAWData(bytes,callback);
        } catch (Exception e){
            e.printStackTrace();
        }
    }
    else if(call.method.equals("underline1Dot")){
        try {
            byte[] bytes = BytesUtil.underlineWithOneDotWidthOn();
            woyouService.sendRAWData(bytes,callback);
        } catch (Exception e){
            e.printStackTrace();
        }
    }
    else if(call.method.equals("underline2Dot")){
        try {
            byte[] bytes = BytesUtil.underlineWithTwoDotWidthOn();
            woyouService.sendRAWData(bytes,callback);
        } catch (Exception e){
            e.printStackTrace();
        }
    }
    else if(call.method.equals("underlineOff")){
        try {
            byte[] bytes = BytesUtil.underlineOff();
            woyouService.sendRAWData(bytes,callback);
        } catch (Exception e){
            e.printStackTrace();
        }
    }
    else if(call.method.equals("boldOn")){
        try {
            byte[] bytes = BytesUtil.boldOn();
            woyouService.sendRAWData(bytes,callback);
        } catch (Exception e){
            e.printStackTrace();
        }
    }
    else if(call.method.equals("boldOff")){
        try {
            byte[] bytes = BytesUtil.boldOff();
            woyouService.sendRAWData(bytes,callback);
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    /** CASHLEZ **/
    else if(call.method.equals("clz_doLogin")){
      String username = call.argument("username");
      String pin = call.argument("pin");

      Cashlez_Login cashlez_login = new Cashlez_Login(activity,activity);
      cashlez_login.doLogin(username,pin);
      Log.d(TAG,this.getSharedPreferences().toString());
      result.success(this.getStatus());
    }
    else if(call.method.equals("clz_clearSharedPreferences")){
      this.clearSharedPreferences();
      result.success("Clear localstorage success.");
    }
    else if(call.method.equals("clz_activated")){
      String code = call.argument("code");
      Cashlez_Activation cashlez_activation = new Cashlez_Activation(activity,activity);
      cashlez_activation.doActivate(code);
      result.success(this.getStatus());
    }
    else if(call.method.equals("clz_getPaymentList")){
      int page = call.argument("page");
      String invoiceNo = call.argument("invoiceNo");
      String approvalCode = call.argument("approvalCode");

      Cashlez_PaymentHistory cashlez_paymentHistory = new Cashlez_PaymentHistory(activity,activity);
      cashlez_paymentHistory.doGetPaymentList(page,invoiceNo,approvalCode);
      result.success(cashlez_paymentHistory.getPaymentList());
    }
    else if(call.method.equals("clz_getPaymentList_ByDate")){
      String date = call.argument("date");

      Cashlez_PaymentHistory cashlez_paymentHistory = new Cashlez_PaymentHistory(activity,activity);
      cashlez_paymentHistory.doGetPaymentByDate(date);
      result.success(cashlez_paymentHistory.getPaymentList());
    }
    else if(call.method.equals("clz_getPaymentList_ByMerchantTransactionId")){
      String id = call.argument("id");

      Cashlez_PaymentHistory cashlez_paymentHistory = new Cashlez_PaymentHistory(activity,activity);
      cashlez_paymentHistory.doGetPaymentByMerchantTransactionId(id);
      result.success(cashlez_paymentHistory.getPaymentList());
    }
    else if(call.method.equals("clz_getPaymentList_ByTransactionId")){
      String id = call.argument("id");

      Cashlez_PaymentHistory cashlez_paymentHistory = new Cashlez_PaymentHistory(activity,activity);
      cashlez_paymentHistory.doGetPaymentByTransactionId(id);
      result.success(cashlez_paymentHistory.getPaymentList());
    }
    else if(call.method.equals("clz_changePin")){
        String username = call.argument("username");

        Cashlez_ChangePin cashlez_changePin = new Cashlez_ChangePin(activity,activity);
        cashlez_changePin.doChangePin(username);
        result.success(this.getStatus());
    }
    else if(call.method.equals("clz_doStartOvoHandler")){
      Cashlez_Ovo cashlez_ovo = new Cashlez_Ovo(activity,activity);
      cashlez_ovo.doStartOvoHandler();
      result.success(this.getStatus());
    }
    else if(call.method.equals("clz_doResumOvoHandler")){
      Cashlez_Ovo cashlez_ovo = new Cashlez_Ovo(activity,activity);
      cashlez_ovo.doResumeOvoHandler();
      result.success(this.getStatus());
    }
    else if(call.method.equals("clz_doStopOvoHandler")){
      Cashlez_Ovo cashlez_ovo = new Cashlez_Ovo(activity,activity);
      cashlez_ovo.doStopOvoHandler();
      result.success(this.getStatus());
    }
    else if(call.method.equals("clz_doCheckOvo")){
      Cashlez_Ovo cashlez_ovo = new Cashlez_Ovo(activity,activity);
      cashlez_ovo.doCheckOvo();
      result.success(this.getStatus());
    }
    else if(call.method.equals("clz_doPayOvo")){

      Cashlez_Ovo cashlez_ovo = new Cashlez_Ovo(activity,activity);
//      cashlez_ovo.doPayOvo();
    }

    //CASHLEZ PRINTER
    else if(call.method.equals("clz_doInitPrinter")){
      Cashlez_Printer cashlez_printer = new Cashlez_Printer(activity,activity);
      cashlez_printer.doInitPrinter();
      result.success(this.getStatus());
    }
    else if(call.method.equals("clz_doPrintText")){
      Cashlez_Printer cashlez_printer = new Cashlez_Printer(activity,activity);
      ArrayList<CLPrintObject> obj = null;

      cashlez_printer.doPrintFreeText(obj);
      result.success(this.getStatus());
    }
    else if(call.method.equals("clz_doPrintQR")){
      byte[] bytes = call.argument("bitmap");
      Bitmap bitmap = BitmapFactory.decodeByteArray(bytes,0,bytes.length);

      Cashlez_Printer cashlez_printer = new Cashlez_Printer(activity,activity);
      cashlez_printer.doPrintQR(bitmap);
      result.success(this.getStatus());
    }
    else if(call.method.equals("clz_doCheckPrint")){
      Cashlez_Printer cashlez_printer = new Cashlez_Printer(activity,activity);
      cashlez_printer.doCheckPrint();
      result.success(this.getStatus());
    }
    else if(call.method.equals("clz_doUnregisterPrinterReceiver")){
      Cashlez_Printer cashlez_printer = new Cashlez_Printer(activity,activity);
      cashlez_printer.doUnregisterPrinterReceiver();
      result.success(this.getStatus());
    }
    else if(call.method.equals("clz_doClosePrinterConnection")){
      Cashlez_Printer cashlez_printer = new Cashlez_Printer(activity,activity);
      cashlez_printer.doClosePrinterConnection();
      result.success(this.getStatus());
    }

    // PAYMENT
    else if(call.method.equals("clz_doPayment")){
        int code = call.argument("type");
        String amount = call.argument("amount");
        String remarks = call.argument("remarks");
        byte[] image = call.argument("image");

        Bundle bundle = new Bundle(); // gak ngerti di Bundle
        Cashlez_BasePayment cashlez_basePayment = new Cashlez_BasePayment(activity,activity,bundle);

        CLPayment clPayment = new CLPayment();
        clPayment.setAmount(amount);
        clPayment.setDescription(remarks);

        if(code ==  0){
            clPayment.setTransactionType(TransactionType.CASH);
            cashlez_basePayment.doPayCash(clPayment);
        } else if(code == 1){
            clPayment.setTransactionType(TransactionType.DEBIT);
            clPayment.setVerificationMode(CLVerificationMode.PIN);
            cashlez_basePayment.doPayDebitPin(clPayment);
        } else if(code == 2){
            clPayment.setTransactionType(TransactionType.DEBIT);
            clPayment.setVerificationMode(CLVerificationMode.SIGNATURE);
            cashlez_basePayment.doPayDebitSign(clPayment);
        } else if(code == 3){
            clPayment.setTransactionType(TransactionType.CREDIT);
            clPayment.setVerificationMode(CLVerificationMode.PIN);
            cashlez_basePayment.doPayCreditPin(clPayment);
        } else if(code == 4){
            clPayment.setTransactionType(TransactionType.CREDIT);
            clPayment.setVerificationMode(CLVerificationMode.SIGNATURE);
            cashlez_basePayment.doPayCreditSign(clPayment);
        } else if(code == 5){
            clPayment.setCardProcessingMode(CLCardProcessingMode.LOCAL_CARD);
            clPayment.setVerificationMode(CLVerificationMode.PIN);
            cashlez_basePayment.doPayLocalPin(clPayment);
        } else if(code == 6){
            clPayment.setCardProcessingMode(CLCardProcessingMode.LOCAL_CARD);
            clPayment.setVerificationMode(CLVerificationMode.NO_PIN);
            cashlez_basePayment.doPayLocalNonPin(clPayment);
        } else if(code == 5){
            clPayment.setCardProcessingMode(CLCardProcessingMode.INTERNATIONAL_CARD);
            cashlez_basePayment.doPayInternationalCard(clPayment);
        } else {
            clPayment.setTransactionType(TransactionType.CASH);
            cashlez_basePayment.doPayCash(clPayment);
        }

        result.success(this.getStatus());
    }

    // NOT FOUND
    else { result.notImplemented(); }
  }

  private HashMap getSharedPreferences(){
    HashMap<String,Object> output = new HashMap<String,Object>();
    output.put(STATUS_CODE,this.sharedPreferences.getInt(STATUS_CODE,-1));
    output.put(STATUS_MESSAGE,this.sharedPreferences.getString(STATUS_MESSAGE,""));
    output.put(CLPAYMENT_CAPABILITY,this.sharedPreferences.getString(CLPAYMENT_CAPABILITY,""));
    output.put(CLPAYMENT_HISTORY_LIST,this.sharedPreferences.getString(CLPAYMENT_HISTORY_LIST,""));
    output.put(CLPAYMENT,this.sharedPreferences.getString(CLPAYMENT,""));
    output.put(CLPAYMENT_RESPONSE,this.sharedPreferences.getString(CLPAYMENT_RESPONSE,""));
    output.put(CLREADER_COMPANION,this.sharedPreferences.getString(CLREADER_COMPANION,""));
    output.put(CLTCASH_RESPONSE,this.sharedPreferences.getString(CLTCASH_RESPONSE,""));
    output.put(ClDIMO_RESPONSE,this.sharedPreferences.getString(ClDIMO_RESPONSE,""));
    output.put(CLMANDIRI_PAY_RESPONSE,this.sharedPreferences.getString(CLMANDIRI_PAY_RESPONSE,""));
    output.put(CLTRANSFER_DETAIL,this.sharedPreferences.getString(CLTRANSFER_DETAIL,""));
    return output;
  }

  public HashMap getStatus(){
    HashMap<String,Object> output = new HashMap<String,Object>();
    output.put(STATUS_CODE,this.sharedPreferences.getInt(STATUS_CODE,-1));
    output.put(STATUS_MESSAGE,this.sharedPreferences.getString(STATUS_MESSAGE,""));
    return output;
  }

  private CLPaymentCapability getPaymentCapability(){
    Gson gson = new Gson();
    return gson.fromJson(this.sharedPreferences.getString(CLPAYMENT_CAPABILITY,null),CLPaymentCapability.class);
  }

  private void clearSharedPreferences(){
    SharedPreferences.Editor editor = this.sharedPreferences.edit();
    editor.remove(CLPAYMENT_CAPABILITY);
    editor.remove(STATUS_CODE);
    editor.remove(STATUS_MESSAGE);
    editor.remove(CLPAYMENT_HISTORY_LIST);
    editor.remove(CLPAYMENT);
    editor.remove(CLPAYMENT_RESPONSE);
    editor.remove(CLREADER_COMPANION);
    editor.remove(CLTCASH_RESPONSE);
    editor.remove(ClDIMO_RESPONSE);
    editor.remove(CLMANDIRI_PAY_RESPONSE);
    editor.remove(CLTRANSFER_DETAIL);
    editor.apply();
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
          woyouService.lineWrap(3,callback);
        } catch (RemoteException e){
          e.printStackTrace();
        }
      }
    });
  }

//  /**
//   *
//   * @param data
//   * @param size
//   */
//  public void printQRCodeWithZxing(final String data, final int size){
//    ThreadPoolManager.getInstance().executeTask(new Runnable() {
//      @Override
//      public void run() {
//        try {
//          byte[] bytes = BytesUtil.getZXingQRCode(data,size);
//          woyouService.sendRAWData(bytes,callback);
//        } catch (RemoteException e){
//          e.printStackTrace();
//        }
//      }
//    });
//  }

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
