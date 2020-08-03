import 'package:flutter/services.dart';

class FlutterLivePlugin {
  static const MethodChannel _methodChannel = MethodChannel('flutter/live/methodChannel');
  static const EventChannel eventChannele = EventChannel("flutter/live/eventChannel");

  static startLive(String url) async {
    await _methodChannel.invokeMethod('startLive', {"url" : url});
  }

  static sendBarrage(String msg) async {
    await _methodChannel.invokeMethod('sendBarrage', {"msg" : msg});
  }

}
