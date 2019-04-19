package nl.flyingkiwi.facebook_sdk;

import android.content.Intent;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.share.Sharer.Result;
import com.facebook.FacebookException;
import com.facebook.login.LoginResult;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

class FacebookShareResultDelegate implements FacebookCallback<Result>, PluginRegistry.ActivityResultListener {
    private static final String ERROR_SHARE_IN_PROGRESS = "share_in_progress";

    private final CallbackManager callbackManager;
    private MethodChannel.Result pendingResult;

    FacebookShareResultDelegate(CallbackManager callbackManager) {
        this.callbackManager = callbackManager;
    }

    void setPendingResult(String methodName, MethodChannel.Result result) {
        if (pendingResult != null) {
            result.error(
                    ERROR_SHARE_IN_PROGRESS,
                    methodName + " called while another Facebook " +
                            "share operation was in progress.",
                    null
            );
        }

        pendingResult = result;
    }

    @Override
    public void onSuccess(Result result) {
        finishWithResult(result.getPostId());
    }

    @Override
    public void onCancel() {
        finishWithResult("cancel");
    }

    @Override
    public void onError(FacebookException error) {
        finishWithResult(error.getMessage());
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        return callbackManager.onActivityResult(requestCode, resultCode, data);
    }

    private void finishWithResult(String result) {
        if (pendingResult != null) {
            pendingResult.success(result);
            pendingResult = null;
        }
    }
}
