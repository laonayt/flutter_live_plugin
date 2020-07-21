package com.flutter_live_plugin;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterLivePlugin */
public class FlutterLivePlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    FlutterLivePlugin plugin = new FlutterLivePlugin();
    plugin.context = flutterPluginBinding.getApplicationContext();

    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_live_plugin");
    channel.setMethodCallHandler(plugin);

    Log.e("AndroidPlugin","onAttachedToEngine");
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    FlutterLivePlugin plugin = new FlutterLivePlugin();
    plugin.context = registrar.context();

    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_live_plugin");
    channel.setMethodCallHandler(plugin);

    Log.e("AndroidPlugin","registerWith");
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if(call.method.equals("startLive")){
      Intent intent = new Intent(context,LivingActivity.class);
      String url = call.argument("url");
      intent.putExtra("url",url);
      intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK );
      context.startActivity(intent);

    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}