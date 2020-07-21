import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_live_plugin/flutter_live_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_live_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('startLive', () async {
    expect(await FlutterLivePlugin.startLive, '42');
  });
}
