import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttTool {
  static MqttTool _instance;

  static MqttTool getInstance(){
    if (_instance == null) {
      _instance = MqttTool();
    }
    return _instance;
  }

  final pubTopic = 'Dart/Mqtt_client/testtopic';
  MqttServerClient _client;
  Function msgCallBack;

  initMqtt(String userName) async {
    _client = MqttServerClient.withPort('111.229.126.115', userName, 1883);

    _client.logging(on: true);
    _client.keepAlivePeriod = 20;
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;
    _client.onDisconnected = onDisconnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_user')
        .keepAliveFor(20) // Must agree with the keep alive set above or not set
        .withWillTopic('willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce)
        .authenticateAs('mosquitto', 'mosquitto');
    _client.connectionMessage = connMess;

    try {
      await _client.connect();
    } on Exception catch (e) {
      _client.disconnect();
    }

    _client.subscribe(pubTopic, MqttQos.exactlyOnce);

    if (_client.connectionStatus.state == MqttConnectionState.connected) {
      print('mqtt connected');
    } else {
      print('mqtt err disconnect');
      _client.disconnect();
    }

    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('Received: topic is <${c[0].topic}>, payload is <-- $pt -->');
      msgCallBack(pt);
    });

    _client.published.listen((MqttPublishMessage message) {
      print('Published: topic is ${message.variableHeader.topicName}, with Qos ${message.header.qos}');
    });

  }

  publishMqtt(String msg) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    _client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);
  }

  disconnectMqtt() {
    _client.unsubscribe(pubTopic);
    _client.disconnect();
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
  }

  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The successful connect callback
  void onConnected() {
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }

}