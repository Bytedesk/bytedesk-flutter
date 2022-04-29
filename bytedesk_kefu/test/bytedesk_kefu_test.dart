import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bytedesk_kefu/bytedesk_kefu.dart';

void main() {
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
    expect(await BytedeskKefu.platformVersion, '42');
  });
}
