package asriworks.com.sunmi_aidl_print.cashlez.login;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import asriworks.com.sunmi_aidl_print.util.Util;

import com.cashlez.android.sdk.CLErrorResponse;
import com.cashlez.android.sdk.CLPaymentCapability;
import com.cashlez.android.sdk.login.CLLoginHandler;
import com.cashlez.android.sdk.login.CLLoginResponse;
import com.cashlez.android.sdk.login.ICLLoginService;
import com.google.gson.Gson;

public class Cashlez_Login implements ICLLoginService{
    protected CLLoginHandler loginHandler;
    protected Util util;

    protected SharedPreferences sharedPreferences;
    protected static final String STATUS_CODE = "StatusCode";
    protected static final String STATUS_MESSAGE = "StatusMessage";
    protected static final String PAYMENT_CAPABILITY = "PaymentCapability";
    String TAG = "-- CLZ - LOGIN PRESENTER -- ";

    public Cashlez_Login(Context context,Activity activity) {
        loginHandler = new CLLoginHandler(context, this);
        this.util = new Util(activity,context);
        this.sharedPreferences = activity.getSharedPreferences("GWK_EKIOS",Context.MODE_PRIVATE);
    }

    private void setResult(int code,String msg){
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putInt(STATUS_CODE,code);
        editor.putString(STATUS_MESSAGE,msg);
        editor.apply();
    }

    private void setCLPaymentCapability(CLPaymentCapability paymentCapability){
        Gson gson = new Gson();
        String json = gson.toJson(paymentCapability);
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putString(PAYMENT_CAPABILITY,json);
        editor.apply();
    }

    public void doLoginAggregator(String publicKey, String privateKey, String username, String aggregatorId){
        loginHandler.doLogin(publicKey,privateKey,username,aggregatorId);
    }

    public void doLogin(String username, String pin){
        loginHandler.doLogin(username,pin);
    }

    @Override
    public void onStartActivation(String mobileUpdateURL) {
        this.util.displayInfo(mobileUpdateURL);
    }

    @Override
    public void onNewVersionAvailable(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    @Override
    public void onApplicationExpired(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    @Override
    public void onLoginSuccess(CLLoginResponse clLoginResponse){
        CLPaymentCapability paymentCapability = clLoginResponse.getPaymentCapability();
        this.setCLPaymentCapability(paymentCapability);
        this.setResult(0,clLoginResponse.getMessage());
    }

    @Override
    public void onLoginError(CLErrorResponse errorResponse){
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }
}
