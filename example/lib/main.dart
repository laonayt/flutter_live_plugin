import 'package:flutter/material.dart';
import 'package:flutter_live_plugin/flutter_live_plugin.dart';
import 'package:flutter_live_plugin_example/mqtt_tool.dart';
import 'package:permission_handler/permission_handler.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    MqttTool.getInstance().initMqtt('laona');
//    MqttTool.getInstance().msgCallBack = (msg){
//      FlutterLivePlugin.sendBarrage(msg);
//      print("哈哈哈:" + msg);
//    };

    FlutterLivePlugin.eventChannele.receiveBroadcastStream().listen((event) {
      print('_eventChannel 收到：' + event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: RaisedButton(
          child: Text("开始直播"),
          onPressed: () async {
            var camera = await Permission.camera.status;
            var mic = await Permission.microphone.status;
            if (camera.isUndetermined && mic.isUndetermined) {
              await Permission.camera.request();
              await Permission.microphone.request();
            } else {
              var url = "rtmp://192.168.101.164/rtmplive/test";
              FlutterLivePlugin.startLive(url);
            }
          },
        ),
      ),
    );
  }
}
