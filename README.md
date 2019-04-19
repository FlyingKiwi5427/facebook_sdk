# facebook_sdk

A Flutter Plugin for integrating the Facebook SDK. For now only ShareLinkContent is implemented.
For now only Android. iOS will be next. When everything works as expected i might integrate more sharing options....

## Getting Started

### Android
Add the following to AndroidManifest.xml and replace {FB_APP_ID} with your Facebook App ID
```
<meta-data android:name="com.facebook.sdk.ApplicationId" android:value="@string/facebook_app_id"/>
<activity android:name="com.facebook.FacebookActivity" android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation" android:label="@string/app_name" />
<provider android:authorities="com.facebook.app.FacebookContentProvider{FB_APP_ID}" android:name="com.facebook.FacebookContentProvider" android:exported="true"/>
```

Add the following to android/app/src/main/res/values/strings.xml
```
    <string name="app_name">Your App Name</string>
    <string name="facebook_app_id">{FB_APP_ID}</string>
    <string name="fb_login_protocol_scheme">fb{FB_APP_ID}</string>
```