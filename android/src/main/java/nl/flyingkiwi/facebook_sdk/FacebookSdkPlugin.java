package nl.flyingkiwi.facebook_sdk;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;

import android.app.Activity;
import android.net.Uri;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FacebookSdkPlugin */
public class FacebookSdkPlugin implements MethodCallHandler {
  private final FacebookShareDelegate delegate;

  private FacebookSdkPlugin(Registrar registrar) {
    delegate = new FacebookShareDelegate(registrar);
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "facebook_sdk");
    channel.setMethodCallHandler(new FacebookSdkPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("shareLinkContent")) {
      String link = call.argument("link");
      delegate.shareLinkContent(link, result);
    } else {
      result.notImplemented();
    }
  }

  public static final class FacebookShareDelegate {
    private final Registrar registrar;
    private final CallbackManager callbackManager;
    private final FacebookShareResultDelegate resultDelegate;
    private final ShareDialog shareDialog;

    public FacebookShareDelegate(Registrar registrar) {
      this.registrar = registrar;
      this.callbackManager = CallbackManager.Factory.create();
      this.shareDialog = new ShareDialog(registrar.activity());
      this.resultDelegate = new FacebookShareResultDelegate(callbackManager);

      this.shareDialog.registerCallback(callbackManager, this.resultDelegate);
      registrar.addActivityResultListener(resultDelegate);
    }

    private void shareLinkContent(String link, Result result) {
      resultDelegate.setPendingResult("shareLinkContent", result);

      ShareLinkContent content = new ShareLinkContent.Builder()
              .setContentUrl(Uri.parse(link))
              .build();
      shareDialog.show(content);
    }

//    public void logInWithReadPermissions(
//            LoginBehavior loginBehavior, List<String> permissions, Result result) {
//      resultDelegate.setPendingResult(METHOD_LOG_IN_WITH_READ_PERMISSIONS, result);
//
//      loginManager.setLoginBehavior(loginBehavior);
//      loginManager.logInWithReadPermissions(registrar.activity(), permissions);
//    }
//
//    public void logInWithPublishPermissions(
//            LoginBehavior loginBehavior, List<String> permissions, Result result) {
//      resultDelegate.setPendingResult(METHOD_LOG_IN_WITH_PUBLISH_PERMISSIONS, result);
//
//      loginManager.setLoginBehavior(loginBehavior);
//      loginManager.logInWithPublishPermissions(registrar.activity(), permissions);
//    }
//
//    public void logOut(Result result) {
//      loginManager.logOut();
//      result.success(null);
//    }
//
//    public void getCurrentAccessToken(Result result) {
//      AccessToken accessToken = AccessToken.getCurrentAccessToken();
//      Map<String, Object> tokenMap = FacebookLoginResults.accessToken(accessToken);
//
//      result.success(tokenMap);
//    }
  }
}
