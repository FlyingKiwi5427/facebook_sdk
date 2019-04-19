package nl.flyingkiwi.facebook_sdk;

import com.facebook.CallbackManager;
import com.facebook.login.LoginBehavior;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;

import android.net.Uri;

import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FacebookSdkPlugin */
public class FacebookSdkPlugin implements MethodCallHandler {
  private static final String LOGIN = "login";
  private static final String SHARE_LINK = "shareLinkContent";

  private final FacebookDelegate delegate;

  private FacebookSdkPlugin(Registrar registrar) {
    delegate = new FacebookDelegate(registrar);
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "facebook_sdk");
    channel.setMethodCallHandler(new FacebookSdkPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case LOGIN:
        List<String> readPermissions = call.argument("permissions");
        delegate.logInWithReadPermissions(readPermissions, result);
        break;
      case SHARE_LINK:
        String link = call.argument("link");
        delegate.shareLinkContent(link, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  public static final class FacebookDelegate {
    private final Registrar registrar;
    private final CallbackManager callbackManager;
    private final FacebookLoginResultDelegate loginResultDelegate;
    private final FacebookShareResultDelegate shareResultDelegate;
    private final LoginManager loginManager;
    private final ShareDialog shareDialog;

    public FacebookDelegate(Registrar registrar) {
      this.registrar = registrar;
      this.callbackManager = CallbackManager.Factory.create();
      this.loginManager = LoginManager.getInstance();
      this.shareDialog = new ShareDialog(registrar.activity());
      this.loginResultDelegate = new FacebookLoginResultDelegate(callbackManager);
      this.shareResultDelegate = new FacebookShareResultDelegate(callbackManager);

      this.shareDialog.registerCallback(callbackManager, this.shareResultDelegate);
      this.loginManager.registerCallback(callbackManager, this.loginResultDelegate);
      registrar.addActivityResultListener(this.shareResultDelegate);
      registrar.addActivityResultListener(this.loginResultDelegate);
    }

    private void shareLinkContent(String link, Result result) {
      shareResultDelegate.setPendingResult("shareLinkContent", result);

      ShareLinkContent content = new ShareLinkContent.Builder()
              .setContentUrl(Uri.parse(link))
              .build();
      shareDialog.show(content);
    }

    public void logInWithReadPermissions(List<String> permissions, Result result) {
      loginResultDelegate.setPendingResult("logInWithReadPermissions", result);

      loginManager.setLoginBehavior(LoginBehavior.NATIVE_WITH_FALLBACK);
      loginManager.logInWithReadPermissions(registrar.activity(), permissions);
    }
  }
}
