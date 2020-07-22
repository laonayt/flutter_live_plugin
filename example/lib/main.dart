import 'package:flutter/material.dart';
import 'package:flutter_live_plugin/flutter_live_plugin.dart';
import 'package:flutter_live_plugin_example/mqtt_tool.dart';

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

    MqttTool.getInstance().initMqtt('laona');
    MqttTool.getInstance().msgCallBack = (msg){
      FlutterLivePlugin.sendBarrage(msg);
    };
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
          onPressed: () {
            var url = "rtmp://192.168.101.240/rtmplive/test";
            FlutterLivePlugin.startLive(url);
          },
        ),
      ),
    );
  }
}
