package asriworks.com.sunmi_aidl_print.cashlez.ovo;


import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import asriworks.com.sunmi_aidl_print.util.Util;
import com.cashlez.android.sdk.CLErrorResponse;
import com.cashlez.android.sdk.CLPayment;
import com.cashlez.android.sdk.payment.CLPaymentResponse;
import com.cashlez.android.sdk.payment.ovo.CLOvoHandler;
import com.cashlez.android.sdk.payment.ovo.ICLOvoHandler;
import com.cashlez.android.sdk.payment.ovo.ICLOvoService;
import com.cashlez.android.sdk.payment.voidpayment.CLVoidResponse;
import com.cashlez.android.sdk.bean.ApprovalStatus;
import com.google.gson.Gson;


public class Cashlez_Ovo implements ICLOvoService {
    private ICLOvoHandler ovoHandler;
    private CLPaymentResponse paymentResponse;
    private SharedPreferences sharedPreferences;
    private Util util;
    protected static final String STATUS_CODE = "StatusCode";
    protected static final String STATUS_MESSAGE = "StatusMessage";
    protected static final String PAYMENT_CAPABILITY = "PaymentCapability";
    protected static final String PAYMENT_RESPONSE = "PaymentResponse";
    protected static final String OVO_PAY = "OvoPay";
    protected static final String OVO_CHECK = "OvoCheck";

    public Cashlez_Ovo(Context context, Activity activity){
        this.util = new Util(activity,context);
        this.sharedPreferences = activity.getSharedPreferences("GWK_EKIOS",Context.MODE_PRIVATE);

    }

    private void setResult(int code,String msg){
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putInt(STATUS_CODE,code);
        editor.putString(STATUS_MESSAGE,msg);
        editor.apply();
    }

    private void setPaymentResponse(CLPaymentResponse paymentResponse){
        Gson gson = new Gson();
        String json = gson.toJson(paymentResponse);
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putString(PAYMENT_RESPONSE,json);
        editor.apply();
    }

    private void setResultOvoPayment(boolean pay, boolean check){
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putBoolean(OVO_CHECK,check);
        editor.putBoolean(OVO_PAY,pay);
        editor.apply();
    }

//    public void doCreateHandler(OvoActivity ovoActivity )


    @Override
    public void onOvoPaymentSuccess(CLPaymentResponse response) {
        this.setResult(0,"Please proceed on the OVO app");
        this.setResultOvoPayment(false,true);
    }

    @Override
    public void onOvoPaymentError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    @Override
    public void onOvoInquirySuccess(CLPaymentResponse response) {
        int transactionStatus = response.getTransactionStatus();

        String msg = ApprovalStatus.getStatus(transactionStatus).getMessage();
        this.setResult(0,msg);
        if(transactionStatus != ApprovalStatus.APPROVED.getCode()
            && transactionStatus != ApprovalStatus.PENDING.getCode()){
            this.setResultOvoPayment(true,false);
        }
    }

    @Override
    public void onOvoInquiryError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    @Override
    public void onOvoVoidPaymentSuccess(CLVoidResponse response) {
        this.setResult(response.getErrorCode(),response.getMessage());
        this.setPaymentResponse(response.getClPaymentResponse());
    }

    @Override
    public void onOvoVoidPaymentError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }
}
