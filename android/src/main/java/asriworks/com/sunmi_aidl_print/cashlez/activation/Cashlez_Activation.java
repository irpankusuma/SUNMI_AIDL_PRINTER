package asriworks.com.sunmi_aidl_print.cashlez.activation;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;

import com.cashlez.android.sdk.CLErrorResponse;
import com.cashlez.android.sdk.CLResponse;
import com.cashlez.android.sdk.activation.CLActivationHandler;
import com.cashlez.android.sdk.activation.ICLActivationService;

import asriworks.com.sunmi_aidl_print.util.Util;

public class Cashlez_Activation implements ICLActivationService {
    private CLActivationHandler managePasswordFlow;
    private SharedPreferences sharedPreferences;
    private Util util;
    protected static final String STATUS_CODE = "StatusCode";
    protected static final String STATUS_MESSAGE = "StatusMessage";

    public Cashlez_Activation(Context context, Activity activity){
        this.util = new Util(activity,context);
        this.managePasswordFlow = new CLActivationHandler(context,this);
        this.sharedPreferences = activity.getSharedPreferences("GWK_EKIOS",Context.MODE_PRIVATE);
    }

    private void setResult(int code,String msg){
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putInt(STATUS_CODE,code);
        editor.putString(STATUS_MESSAGE,msg);
        editor.apply();
    }

    public void doActivate(String code){
        this.managePasswordFlow.doActivate(code);
    }

    public void onActivationSuccess(CLResponse response) {
        this.setResult(0,response.getMessage());
    }

    public void onActivationError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

}
