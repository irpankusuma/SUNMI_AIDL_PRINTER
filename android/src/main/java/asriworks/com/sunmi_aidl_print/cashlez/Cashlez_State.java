package asriworks.com.sunmi_aidl_print.cashlez;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.util.Log;
//import android.support.multidex.MultiDex;

import com.cashlez.android.sdk.CLPayment;
import com.cashlez.android.sdk.CLPaymentCapability;
import com.cashlez.android.sdk.CLTransferDetail;
import com.cashlez.android.sdk.companion.reader.CLReaderCompanion;
import com.cashlez.android.sdk.payment.CLDimoResponse;
import com.cashlez.android.sdk.payment.CLMandiriPayResponse;
import com.cashlez.android.sdk.payment.CLPaymentResponse;
import com.cashlez.android.sdk.payment.CLTCashQRResponse;

import asriworks.com.sunmi_aidl_print.util.Util;

public class Cashlez_State {
    private static Cashlez_State instance;
//    private Util util;
    private boolean isGPN;
    private CLPayment clPayment;
    private CLPaymentCapability clPaymentCapability;
    private int statusCode;
    private String statusMessage;
    private CLPaymentResponse clPaymentResponse;
    private boolean isOvoReadyCheck = false;
    private boolean isOvoReadyPayment = false;
    private CLReaderCompanion clReaderCompanion;
    private CLTCashQRResponse cltCashQRResponse;
    private CLDimoResponse clDimoResponse;
    private CLMandiriPayResponse clMandiriPayResponse;
    private CLTransferDetail clTransferDetail;
    private static final String TAG = Cashlez_State.class.getSimpleName();
//    private Context context;
//    private Activity activity;

    public static synchronized Cashlez_State getInstance(){
        if(instance == null){
            instance = new Cashlez_State();
        }
        return instance;
    }
    private Cashlez_State(){}

//    public Cashlez_State(Context context, Activity activity){
//        this.context = context;
//        this.activity = activity;
//        this.isGPN = false;
//        this.clPayment = null;
//        this.clPaymentCapability = null;
//        this.statusCode = -1;
//        this.statusMessage = "";
//        this.clPaymentResponse = null;
//        this.isOvoReadyCheck = false;
//        this.isOvoReadyPayment = false;
//        this.clReaderCompanion = null;
//        this.cltCashQRResponse = null;
//        this.clDimoResponse = null;
//        this.clMandiriPayResponse = null;
//        this.clTransferDetail = null;
//    }

    // SETTER
    public void setIsGPN(boolean i){ this.isGPN = i; }
//    public void setContext(Context context){ this.context = context; }
    public void setClPayment(CLPayment clPayment){ this.clPayment = clPayment; }
    public void setClPaymentCapability(CLPaymentCapability clPaymentCapability){ this.clPaymentCapability = clPaymentCapability; }
    public void setStatusCode(int statusCode){ this.statusCode = statusCode; }
    public void setStatusMessage(String statusMessage){
        Log.d(TAG,"Status Message : "+statusMessage);
        this.statusMessage = statusMessage;
    }
    public void setClPaymentResponse(CLPaymentResponse clPaymentResponse){ this.clPaymentResponse = clPaymentResponse; }
    public void setIsOvoReadyCheck(boolean i){ this.isOvoReadyCheck = i; }
    public void setIsOvoReadyPayment(boolean i){ this.isOvoReadyPayment = i; }
    public void setClReaderCompanion(CLReaderCompanion clReaderCompanion){ this.clReaderCompanion = clReaderCompanion; }
    public void setCltCashQRResponse(CLTCashQRResponse cltCashQRResponse){ this.cltCashQRResponse = cltCashQRResponse; }
    public void setClDimoResponse(CLDimoResponse clDimoResponse){ this.clDimoResponse = clDimoResponse; }
    public void setClMandiriPayResponse(CLMandiriPayResponse clMandiriPayResponse){ this.clMandiriPayResponse = clMandiriPayResponse; }
    public void setClTransferDetail(CLTransferDetail clTransferDetail){ this.clTransferDetail = clTransferDetail; }

    // GETTER
    public boolean getIsGPN(){ return this.isGPN; }
//    public Context getContext(){ return this.context; }
    public CLPayment getClPayment() { return clPayment; }
    public CLPaymentCapability getClPaymentCapability(){ return this.clPaymentCapability; }
    public int getStatusCode(){ return this.statusCode; }
    public String getStatusMessage(){ return this.getStatusMessage(); }
    public CLPaymentResponse getClPaymentResponse(){ return this.clPaymentResponse; }
    public boolean getIsOvoReadyCheck(){ return this.isOvoReadyCheck; }
    public boolean getIsOvoReadyPayment(){ return this.isOvoReadyPayment; }
    public CLReaderCompanion getClReaderCompanion(){ return this.clReaderCompanion; }
    public CLTCashQRResponse getCltCashQRResponse() { return cltCashQRResponse; }
    public CLDimoResponse getClDimoResponse() { return clDimoResponse; }
    public CLMandiriPayResponse getClMandiriPayResponse() { return clMandiriPayResponse; }
    public CLTransferDetail getClTransferDetail() { return clTransferDetail; }
}
