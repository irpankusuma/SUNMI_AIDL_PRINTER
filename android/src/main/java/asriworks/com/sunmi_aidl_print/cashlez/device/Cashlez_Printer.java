package asriworks.com.sunmi_aidl_print.cashlez.device;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;

import com.cashlez.android.sdk.CLErrorResponse;
import com.cashlez.android.sdk.companion.printer.CLPrinterCompanion;
import com.cashlez.android.sdk.model.CLPrintObject;
import com.cashlez.android.sdk.payment.CLPaymentResponse;
import com.cashlez.android.sdk.printing.CLPrinterHandler;
import com.cashlez.android.sdk.printing.ICLPrinterService;
import com.cashlez.android.sdk.printing.ICLPrintingHandler;

import java.util.ArrayList;

import asriworks.com.sunmi_aidl_print.util.Util;

public class Cashlez_Printer implements ICLPrinterService {
    protected Util util;
    private ICLPrintingHandler printingHandler;
    protected SharedPreferences sharedPreferences;
    protected static final String STATUS_CODE = "StatusCode";
    protected static final String STATUS_MESSAGE = "StatusMessage";

    public Cashlez_Printer(Context context, Activity activity){
        this.util = new Util(activity,context);
        this.sharedPreferences = activity.getSharedPreferences("GWK_EKIOS",Context.MODE_PRIVATE);
        this.printingHandler = new CLPrinterHandler(context);
    }

    private void setResult(int code,String msg){
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putInt(STATUS_CODE,code);
        editor.putString(STATUS_MESSAGE,msg);
        editor.apply();
    }

    public void doInitPrinter(){
        this.printingHandler.doInitPrinterConnection(this);
    }
    public void doPrintFreeText(ArrayList<CLPrintObject> text){ this.printingHandler.doPrintFreeText(text); }
    public void doCheckPrint(){ this.printingHandler.doCheckPrinterCompanion(); }
    public void doPrint(CLPaymentResponse clPaymentResponse){ this.printingHandler.doPrint(clPaymentResponse); }
    public void doPrintQR(Bitmap bitmap){ this.printingHandler.doPrintQR(bitmap); }
    public void doUnregisterPrinterReceiver(){ this.printingHandler.doUnregisterPrinterReceiver(); }
    public void doClosePrinterConnection(){ this.printingHandler.doClosePrinterConnection(); }

    @Override
    public void onPrintingSuccess(CLPrinterCompanion printerCompanion) {
        this.setResult(0,printerCompanion.getMessage());
    }

    @Override
    public void onPrintingError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }
}
