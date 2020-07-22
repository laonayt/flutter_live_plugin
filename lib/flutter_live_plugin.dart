import 'package:flutter/services.dart';

class FlutterLivePlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_live_plugin');

  static startLive(String url) async {
    await _channel.invokeMethod('startLive', {"url" : url});
  }

  static sendBarrage(String msg) async {
    await _channel.invokeMethod('sendBarrage', {"msg" : msg});
  }

}
