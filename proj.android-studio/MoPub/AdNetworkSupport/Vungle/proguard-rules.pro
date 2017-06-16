# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in E:\developSoftware\Android\SDK/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

-keep public class com.mopub.mobileads.VungleInterstitial
-keepclassmembers public class com.mopub.mobileads.VungleInterstitial { public *; }
-keep public class com.mopub.mobileads.VungleRewardedVideo
-keepclassmembers public class com.mopub.mobileads.VungleRewardedVideo { public *; }

-dontwarn com.vungle.**
-keep class com.vungle.** { *; }
-keep class javax.inject.*