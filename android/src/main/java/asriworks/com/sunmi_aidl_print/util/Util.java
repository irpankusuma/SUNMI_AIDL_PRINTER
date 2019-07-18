package asriworks.com.sunmi_aidl_print.util;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.widget.Toast;
import android.util.Log;

import java.util.HashMap;
import com.cashlez.android.sdk.CLMerchant;
import com.cashlez.android.sdk.CLPayment;
import com.cashlez.android.sdk.CLPaymentCapability;

public class Util {
    private static final String TAG = "[CLASS UTIL]";
    protected Activity activity;
    private CLPayment payment;
    private CLPaymentCapability paymentCapability;
    private CLMerchant merchant;
    private boolean isGpn;
    public int statusCode;
    public String statusMessage = "";

    public Util(Activity activity,Context context){
        this.activity = activity;
    }

    public void displayInfo(final String msg){
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Log.d(TAG,msg);
                Toast.makeText(activity,msg,Toast.LENGTH_LONG).show();
            }
        });
    }

    public HashMap sendResult(final int code, final String msg, final String model){
        HashMap<String,Object> output = new HashMap<String, Object>();
        output.put("code",code);
        output.put("msg",msg);
        output.put("model",model);

        return output;
    }

    public CLPayment getPayment() { return payment; }
    public void setPayment(CLPayment payment) { this.payment = payment; }
    public CLPaymentCapability getPaymentCapability() { return paymentCapability; }
    public void setPaymentCapability(CLPaymentCapability paymentCapability) { this.paymentCapability = paymentCapability; }
    public boolean isGpn() { return isGpn; }
    public void setGpn(boolean gpn) { this.isGpn = gpn; }
    public CLMerchant getMerchant() { return merchant; }
    public void setMerchant(CLMerchant merchant){ this.merchant = merchant; }
    public void setStatus(int status,String statusMessage){

    }
    public int getStatusCode(){ return this.statusCode; }
    public HashMap getStatus(){
        HashMap<String,Object> output = new HashMap<String,Object>();
        Log.d(TAG,"GET CODE : "+Integer.toString(this.statusCode));
        Log.d(TAG,"GET MESSAGE "+this.statusMessage);
        return output;
    }
}
