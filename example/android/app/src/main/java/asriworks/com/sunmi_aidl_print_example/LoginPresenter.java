package asriworks.com.sunmi_aidl_print_example;

import com.cashlez.android.sdk.CLErrorResponse;
import com.cashlez.android.sdk.login.CLLoginHandler;
import com.cashlez.android.sdk.login.CLLoginResponse;
import com.cashlez.android.sdk.login.ICLLoginService;

public class LoginPresenter implements ICLLoginService {

    private CLLoginHandler loginHandler;

    void doLoginAggregator() {

    }

    @Override
    public void onStartActivation(String mobileUpdateURL) {

    }

    @Override
    public void onLoginSuccess(CLLoginResponse clLoginResponse) {

    }

    @Override
    public void onLoginError(CLErrorResponse errorResponse) {

    }

    @Override
    public void onNewVersionAvailable(CLErrorResponse errorResponse) {

    }

    @Override
    public void onApplicationExpired(CLErrorResponse errorResponse) {

    }

}
