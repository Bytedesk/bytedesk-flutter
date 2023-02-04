import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bytedesk_kefu/bytedesk_kefu_method_channel.dart';

void main() {
  MethodChannelBytedeskKefu platform = MethodChannelBytedeskKefu();
  const MethodChannel channel = MethodChannel('bytedesk_kefu');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
