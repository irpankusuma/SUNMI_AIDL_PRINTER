package asriworks.com.sunmi_aidl_print.cashlez.payment;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.util.Log;

import com.cashlez.android.sdk.CLPayment;
import com.cashlez.android.sdk.bean.ApprovalStatus;
import com.cashlez.android.sdk.CLErrorResponse;
import com.cashlez.android.sdk.CLTransferDetail;
import com.cashlez.android.sdk.checkcompanion.CLCompanionResponse;
import com.cashlez.android.sdk.checkcompanion.ICLCheckCompanionService;
import com.cashlez.android.sdk.companion.printer.CLPrinterCompanion;
import com.cashlez.android.sdk.companion.reader.CLReaderCompanion;
import com.cashlez.android.sdk.help.CLHelpResponse;
import com.cashlez.android.sdk.help.ICLHelpHandler;
import com.cashlez.android.sdk.help.ICLHelpMessageService;
import com.cashlez.android.sdk.model.CLPrintObject;
import com.cashlez.android.sdk.payment.CLMandiriPayResponse;
import com.cashlez.android.sdk.payment.CLPaymentResponse;
import com.cashlez.android.sdk.payment.CLTCashQRResponse;
import com.cashlez.android.sdk.payment.CLDimoResponse;
import com.cashlez.android.sdk.payment.noncash.CLPaymentHandler;
import com.cashlez.android.sdk.payment.noncash.ICLPaymentHandler;
import com.cashlez.android.sdk.payment.noncash.ICLPaymentService;
import com.cashlez.android.sdk.sendreceipt.CLSendReceiptResponse;
import com.cashlez.android.sdk.sendreceipt.ICLSendReceiptHandler;
import com.cashlez.android.sdk.sendreceipt.ICLSendReceiptService;
import com.google.gson.Gson;

import java.util.ArrayList;

import asriworks.com.sunmi_aidl_print.util.Util;

public class Cashlez_BasePayment
        implements ICLPaymentService, ICLSendReceiptService, ICLHelpMessageService, ICLCheckCompanionService {
    protected Util util;
    protected Context context;
    protected Activity activity;
    protected SharedPreferences sharedPreferences;
    protected ICLPaymentHandler paymentHandler;
    protected static final String STATUS_CODE = "StatusCode";
    protected static final String STATUS_MESSAGE = "StatusMessage";
    protected static final String CLPAYMENT_CAPABILITY = "ClPaymentCapability";
    protected static final String CLPAYMENT_HISTORY_LIST = "ClPaymentHistoryList";
    protected static final String CLPAYMENT = "ClPayment";
    protected static final String CLPAYMENT_RESPONSE = "ClPaymentResponse";
    protected static final String CLREADER_COMPANION = "ClReaderCompanion";
    protected static final String CLPRINTER_COMPANION = "ClPrinterCompanion";
    protected static final String CLTCASH_RESPONSE = "ClTCachResponse";
    protected static final String CLDIMO_RESPONSE = "ClDimoResponse";
    protected static final String CLMANDIRI_PAY_RESPONSE = "ClMandiriPayResponse";
    protected static final String CLTRANSFER_DETAIL = "ClTransferDetail";
    private static final String TAG = Cashlez_BasePayment.class.getSimpleName();

    protected Cashlez_BasePayment(){}
    public Cashlez_BasePayment(Context context, Activity activity, Bundle extras){
        this.util = new Util(activity,context);
        this.sharedPreferences = activity.getSharedPreferences("GWK_EKIOS", Context.MODE_PRIVATE);
        this.paymentHandler = new CLPaymentHandler(activity,extras);
        this.activity = activity;
        this.context = context;
    }

    private void doConnectLocationProvider(){ this.paymentHandler.doConnectLocationProvider(); }
    private void doUnRegisterReceiver() { this.paymentHandler.doUnregisterReceiver(); }
    private void doCloseConnection() { this.paymentHandler.doCloseCompanionConnection(); }
    private void doStartPayment() { this.paymentHandler.doStartPayment(this); }
    private void doStopLocationProvider() { this.paymentHandler.doStopUpdateLocation(); }
    private void doProceedSignature(String svg){ this.paymentHandler.doProceedSignature(svg); }

    // -- PUBLIC
    public void doPayCash(CLPayment clPayment){ this.paymentHandler.doProceedPayment(clPayment); }
    public void doPayDebitPin(CLPayment clPayment){ this.paymentHandler.doProceedPayment(clPayment); }
    public void doPayDebitSign(CLPayment clPayment){ this.paymentHandler.doProceedPayment(clPayment); }
    public void doPayCreditPin(CLPayment clPayment){ this.paymentHandler.doProceedPayment(clPayment); }
    public void doPayCreditSign(CLPayment clPayment){ this.paymentHandler.doProceedPayment(clPayment); }
    public void doPayLocalPin(CLPayment clPayment){ this.paymentHandler.doProceedPayment(clPayment); }
    public void doPayLocalNonPin(CLPayment clPayment){ this.paymentHandler.doProceedPayment(clPayment); }
    public void doPayInternationalCard(CLPayment clPayment){ this.paymentHandler.doProceedPayment(clPayment); }
    public void doPrintFreeText(ArrayList<CLPrintObject> lists){ this.paymentHandler.doPrintFreeText(lists); }
    public void doCheckReader(){ this.paymentHandler.doCheckReaderCompanion(); }
    public void doPrintPayment(CLPaymentResponse clPaymentResponse){ this.paymentHandler.doPrint(clPaymentResponse); }
    public void doCheckPrinter() {
        this.paymentHandler.doCheckPrinterCompanion();
    }
    public void doPayQR(CLPayment clPayment){ this.paymentHandler.doProceedTCashQRPayment(clPayment); }
    public void doPrintQR(Bitmap bitmap){ this.paymentHandler.doPrintTCashQr(bitmap); }
    public void doCheckStatusQR(CLTCashQRResponse qrResponse){ this.paymentHandler.doCheckTCashQRStatus(qrResponse); }
    public void doProceedDimo(CLPayment clPayment){ this.paymentHandler.doProceedDimoPayment(clPayment); }
    public void doCheckDimoStatus(CLDimoResponse clDimoResponse){ this.paymentHandler.doCheckDimoStatus(clDimoResponse); }
    public void doCancelDimo(CLDimoResponse clDimoResponse){ this.paymentHandler.doCancelDimo(clDimoResponse); }
    public void doProceedMandiriPay(CLPayment clPayment){ this.paymentHandler.doProceedMandiriPayPayment(clPayment); }
    public void doCheckMandiriPayStatus(CLMandiriPayResponse clMandiriPayResponse){ this.paymentHandler.doCheckMandiriPayStatus(clMandiriPayResponse); }

    // -- GAK NGERTI
    public void doSendReceive(CLPaymentResponse clPaymentResponse){

    }
    public void doSendHelpMessage(String msg){

    }
    void doCheckValidReader() {
//        if (isViewAttached()) {
//            getView().onShowLoading();
//
//            ICLCheckCompanionHandler checkReader = new CLCheckCompanionHandler(applicationState.getContext(), this);
//            CLReaderCompanion reader = new CLReaderCompanion();
//            reader.setBtAddress("54:7F:54:68:79:4B");
//            reader.setDeviceTypeEnum(CLDeviceTypeEnum.INGENICO_ICMP_122);
//            reader.setSerialNumber("14076PP20188406");
//            reader.setCompanionName("ICMP-Ingenico");
//            checkReader.doCheckCompanion(reader);
//        }
    }



    protected void setResult(int code,String msg){
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putInt(STATUS_CODE,code);
        editor.putString(STATUS_MESSAGE,msg);
        editor.apply();
    }

    private void setCLReaderCompanion(CLReaderCompanion readerCompanion){
        Gson gson = new Gson();
        String json = gson.toJson(readerCompanion);
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putString(CLREADER_COMPANION,json);
        editor.apply();
    }

    private void setClPrinterCompanion(CLPrinterCompanion clPrinterCompanion){
        Gson gson = new Gson();
        String json = gson.toJson(clPrinterCompanion);
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putString(CLPRINTER_COMPANION,json);
        editor.apply();
    }

    private void setClPaymentResponse(CLPaymentResponse clPaymentResponse){
        Gson gson = new Gson();
        String json = gson.toJson(clPaymentResponse);
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putString(CLPAYMENT_RESPONSE,json);
        editor.apply();
    }

    private void setClTCashResponse(CLTCashQRResponse clTCashResponse){
        Gson gson = new Gson();
        String json = gson.toJson(clTCashResponse);
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putString(CLTCASH_RESPONSE,json);
        editor.apply();
    }

    private void setClDimoResponse(CLDimoResponse clDimoResponse){
        Gson gson = new Gson();
        String json = gson.toJson(clDimoResponse);
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putString(CLDIMO_RESPONSE,json);
        editor.apply();
    }

    private void setClMandiriPayResponse(CLMandiriPayResponse clMandiriPayResponse){
        Gson gson = new Gson();
        String json = gson.toJson(clMandiriPayResponse);
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putString(CLMANDIRI_PAY_RESPONSE,json);
        editor.apply();
    }

    private void setClTransferDetail(CLTransferDetail clTransferDetail){
        Gson gson = new Gson();
        String json = gson.toJson(clTransferDetail);
        SharedPreferences.Editor editor = this.sharedPreferences.edit();
        editor.putString(CLTRANSFER_DETAIL,json);
        editor.apply();
    }

    @Override
    public void onReaderSuccess(CLReaderCompanion readerCompanion) {
        this.setCLReaderCompanion(readerCompanion);
    }

    @Override
    public void onReaderError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    @Override
    public void onPrinterSuccess(CLPrinterCompanion printerCompanion) {
        this.setClPrinterCompanion(printerCompanion);
    }

    @Override
    public void onPrinterError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    @Override
    public void onInsertCreditCard(CLPaymentResponse paymentResponse) {
        this.setClPaymentResponse(paymentResponse);
        this.setResult(0,paymentResponse.getMessage());
    }

    @Override
    public void onInsertOrSwipeDebitCard(CLPaymentResponse paymentResponse) {
        this.setClPaymentResponse(paymentResponse);
        this.setResult(0,paymentResponse.getMessage());
    }

    @Override
    public void onSwipeDebitCard(CLPaymentResponse paymentResponse) {
        this.setClPaymentResponse(paymentResponse);
        this.setResult(0,paymentResponse.getMessage());
    }

    @Override
    public void onCashPaymentSuccess(CLPaymentResponse paymentResponse) {
        this.setClPaymentResponse(paymentResponse);
        this.setResult(0,paymentResponse.getMessage());
    }

    @Override
    public void onCashPaymentError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    @Override
    public void onPaymentSuccess(CLPaymentResponse paymentResponse) {
        this.setClPaymentResponse(paymentResponse);
        this.setResult(0,paymentResponse.getMessage());
    }

    @Override
    public void onRemoveCard(String removeCard) {
        this.setResult(0,removeCard);
    }

    @Override
    public void onProvideSignatureRequest(CLPaymentResponse paymentResponse) {
        // ada kiriman signature
        this.setResult(0,paymentResponse.getMessage());
//        if (isViewAttached()) {
//            getView().onHideLoading();
//            getView().onProvideSignatureRequest(paymentResponse);
//        }
    }

    @Override
    public void onPaymentError(CLErrorResponse errorResponse, String trxId) {
        Log.d(TAG, errorResponse.toString());
        String msg = "Transaction ID : "+trxId+" "+errorResponse.getErrorMessage();
        this.setResult(errorResponse.getErrorCode(),msg);
    }

    @Override
    public void onProvideSignatureError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
        // capture signature
    }

    @Override
    public void onTCashQRSuccess(CLTCashQRResponse qrResponse) {
        // generate QR & send to Flutter
        this.setClTCashResponse(qrResponse);
    }

    @Override
    public void onTCashQRError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    @Override
    public void onCheckTCashQRStatusError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    @Override
    public void onCheckTCashQRStatusSuccess(CLTCashQRResponse qrResponse) {
        this.setResult(0,qrResponse.getMessage());
    }

    /* -DIMO PAY- */
    @Override
    public void onDimoSuccess(CLDimoResponse dimoResponse) {
        this.setClDimoResponse(dimoResponse);
    }

    @Override
    public void onDimoError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    @Override
    public void onCheckDimoStatusSuccess(CLDimoResponse dimoResponse) {
        this.setClDimoResponse(dimoResponse);
        this.setResult(0,dimoResponse.getInvoiceStatus());
    }

    @Override
    public void onCheckDimoStatusError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    @Override
    public void onCancelDimoSuccess(CLDimoResponse dimoResponse) {
        this.setClDimoResponse(dimoResponse);
        this.setResult(0,dimoResponse.getInvoiceStatus());
    }

    @Override
    public void onCancelDimoError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    /* -MANDIRI PAY- */
    @Override
    public void onMandiriPaySuccess(CLMandiriPayResponse mandiriPayResponse) {
        // generate QR & send to Flutter
        this.setClMandiriPayResponse(mandiriPayResponse);
    }

    @Override
    public void onMandiriPayError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    @Override
    public void onCheckMandiriPayStatusSuccess(CLMandiriPayResponse mandiriPayResponse) {
        this.setClMandiriPayResponse(mandiriPayResponse);
        this.setResult(mandiriPayResponse.getTransactionStatus(),mandiriPayResponse.getInvoiceStatus());
    }

    @Override
    public void onCheckMandiriPayStatusError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    @Override
    public void onPaymentDebitTransferRequestConfirmation(CLTransferDetail transferDetail) {
        this.setClTransferDetail(transferDetail);
    }

    // -- EXCEPTION
    // EXCEPTION
    @Override
    public void onSendReceiptSuccess(CLSendReceiptResponse receiptResponse) {
        this.setResult(0,receiptResponse.getMessage());
    }

    @Override
    public void onSendReceiptError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    @Override
    public void onSendHelpSuccess(CLHelpResponse response) {
        this.setResult(0,response.getMessage());
    }

    @Override
    public void onSendHelpError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }

    @Override
    public void onCompanionSuccess(CLCompanionResponse companionResponse) {
        this.setResult(0,companionResponse.getCompanion().getCompanionName());
    }

    @Override
    public void onCompanionError(CLErrorResponse errorResponse) {
        this.setResult(errorResponse.getErrorCode(),errorResponse.getErrorMessage());
    }
}
