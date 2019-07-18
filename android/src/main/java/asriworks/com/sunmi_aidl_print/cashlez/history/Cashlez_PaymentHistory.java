package asriworks.com.sunmi_aidl_print.cashlez.history;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;

import com.cashlez.android.sdk.CLErrorResponse;
import com.cashlez.android.sdk.payment.CLPaymentResponse;
import com.cashlez.android.sdk.paymenthistory.CLPaymentHistoryHandler;
import com.cashlez.android.sdk.paymenthistory.CLPaymentHistoryResponse;
import com.cashlez.android.sdk.paymenthistory.ICLPaymentHistoryHandler;
import com.cashlez.android.sdk.paymenthistory.ICLPaymentHistoryService;
import com.google.gson.Gson;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import asriworks.com.sunmi_aidl_print.util.Util;

public class Cashlez_PaymentHistory implements ICLPaymentHistoryService {
    private ICLPaymentHistoryHandler historyHandler;
    private SharedPreferences sharedPreferences;
    private Util util;
    protected static final String STATUS_CODE = "StatusCode";
    protected static final String STATUS_MESSAGE = "StatusMessage";
    protected static final String PAYMENT_HISTORY_LIST = "PaymentHistoryList";
    private List<CLPaymentResponse> paymentList = new ArrayList<>();
    private boolean isSearch;

    public Cashlez_PaymentHistory(Context context, Activity activity){
        this.util = new Util(activity,context);
        this.sharedPreferences = activity.getSharedPreferences("GWK_EKIOS",Context.MODE_PRIVATE);
        this.historyHandler = new CLPaymentHistoryHandler(context,this);
    }

    private void setResult(int code,String msg,List<CLPaymentResponse> data){
        Gson gson = new Gson();
        String json = gson.toJson(data);

        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putInt(STATUS_CODE,code);
        editor.putString(STATUS_MESSAGE,msg);
        editor.putString(PAYMENT_HISTORY_LIST,json);
        editor.apply();
    }

    private void setResultPaymentList(List<CLPaymentResponse> data){
        Gson gson = new Gson();
        String json = gson.toJson(data);
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putString(PAYMENT_HISTORY_LIST,json);
        editor.apply();
    }

    public HashMap getPaymentList(){
        HashMap<String,Object> output = new HashMap<String,Object>();
        output.put(STATUS_CODE,this.sharedPreferences.getInt(STATUS_CODE,-1));
        output.put(STATUS_MESSAGE,this.sharedPreferences.getString(STATUS_MESSAGE,""));
        output.put(PAYMENT_HISTORY_LIST,this.sharedPreferences.getString(PAYMENT_HISTORY_LIST,""));

        return output;
    }

    private void clearPaymentList(){
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.remove(PAYMENT_HISTORY_LIST);
        editor.apply();
    }

    public void doGetPaymentList(int page){
        this.historyHandler.doGetSalesHistory(page,"","");
    }
    public void doGetPaymentList(int page, String invoiceNo, String approvalCode){
        this.isSearch = true;
        this.historyHandler.doGetSalesHistory(page,"","");
    }

    public void doGetPaymentByInvoiceAndApprovalCode(String invoiceNo, String approvalCode) {
        this.isSearch = true;
        this.historyHandler.doGetPaymentByInvoiceAndApprovalCode(1, invoiceNo, approvalCode);
    }

    public void doGetPaymentByDate(String date) {
        this.isSearch = true;
        this.historyHandler.doGetPaymentByDate(1, date); //yyyy-MM-dd ->2017-11-23
    }

    public void doGetPaymentByMerchantTransactionId(String merchantTrxId) {
        this.isSearch = true;
        this.historyHandler.doGetPaymentByMerchantTransactionId(1, merchantTrxId);
    }

    public void doGetPaymentByTransactionId(String trxId) {
        this.isSearch = true;
        this.historyHandler.doGetPaymentByTransactionId(1, trxId);
    }

    @Override
    public void onSalesHistorySuccess(CLPaymentHistoryResponse response) {
        List<CLPaymentResponse> paymentLists = new ArrayList<>();
        if(response.getPaymentList() == null){
            this.setResult(0,response.getMessage(),response.getPaymentList());
            return;
        }

        if(response.getPaymentList().size() > 0){
            if(this.isSearch){
                this.paymentList.clear();
                this.clearPaymentList();
            }
            this.paymentList.addAll(response.getPaymentList());
//            this.setResultPaymentList(response.getPaymentList());
            this.setResult(0,response.getMessage(),response.getPaymentList());
        } else {
            this.setResult(0,response.getMessage(),response.getPaymentList());
        }
    }

    @Override
    public void onSalesHistoryError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage(),this.paymentList);
    }
}
