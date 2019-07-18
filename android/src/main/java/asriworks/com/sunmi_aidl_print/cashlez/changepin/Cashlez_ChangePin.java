package asriworks.com.sunmi_aidl_print.cashlez.changepin;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;

import com.cashlez.android.sdk.CLErrorResponse;
import com.cashlez.android.sdk.managepassword.CLManagePasswordHandler;
import com.cashlez.android.sdk.managepassword.CLManagePasswordResponse;
import com.cashlez.android.sdk.managepassword.ICLManagePasswordHandler;
import com.cashlez.android.sdk.managepassword.ICLManagePasswordService;

import asriworks.com.sunmi_aidl_print.util.Util;

public class Cashlez_ChangePin implements ICLManagePasswordService {
    private CLManagePasswordHandler managePasswordHandler;
    private SharedPreferences sharedPreferences;
    private Util util;
    protected static final String STATUS_CODE = "StatusCode";
    protected static final String STATUS_MESSAGE = "StatusMessage";

    public Cashlez_ChangePin(Context context, Activity activity){
        this.util = new Util(activity,context);
        this.sharedPreferences = activity.getSharedPreferences("GWK_EKIOS",Context.MODE_PRIVATE);
        this.managePasswordHandler = new CLManagePasswordHandler(context,this);
    }

    private void setResult(int code,String msg){
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putInt(STATUS_CODE,code);
        editor.putString(STATUS_MESSAGE,msg);
        editor.apply();
    }

    public void doChangePin(String userName) {
        this.managePasswordHandler.doChangePassword(userName);
    }

    @Override
    public void onManagePasswordSuccess(CLManagePasswordResponse response) {
        this.setResult(0,response.getMessage());
    }

    @Override
    public void onManagePasswordError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }
}
