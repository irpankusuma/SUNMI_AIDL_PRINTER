package asriworks.com.sunmi_aidl_print.util;

import android.app.Activity;
import android.content.Context;
import android.widget.Toast;
import android.util.Log;

public class Util {
    private static final String TAG = Util.class.getSimpleName();
    protected Activity activity;

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
}
