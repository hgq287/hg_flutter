import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hg_native/hg_native.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('hg_native');
  final store = <String, String>{};

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          final args = call.arguments as Map<dynamic, dynamic>? ?? {};
          switch (call.method) {
            case 'secureStore.write':
              store[args['key'] as String] = args['value'] as String;
              return null;
            case 'secureStore.read':
              return store[args['key'] as String];
            case 'secureStore.delete':
              store.remove(args['key'] as String);
              return null;
            case 'onDeviceAi.availability':
              return {'ready': true, 'backend': 'test'};
            case 'onDeviceAi.infer':
              return {'requestId': args['id'], 'text': 'ok', 'done': true};
            default:
              return null;
          }
        });
  });

  tearDown(() {
    store.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('secure store write/read/delete', () async {
    await HgNative.secureStore.write('k', 'v');
    expect(await HgNative.secureStore.read('k'), 'v');
    await HgNative.secureStore.delete('k');
    expect(await HgNative.secureStore.read('k'), isNull);
  });

  test('on-device ai stub infer', () async {
    final availability = await HgNative.onDeviceAi.availability();
    expect(availability.ready, isTrue);
    final event = await HgNative.onDeviceAi.infer(
      const NativeInferenceRequest(id: '1', modality: 'text', prompt: 'hi'),
    );
    expect(event.done, isTrue);
    expect(event.text, 'ok');
  });

  test('fake implementations satisfy contracts', () async {
    final fakeStore = FakeHgNativeSecureStore();
    await fakeStore.write('a', 'b');
    expect(await fakeStore.read('a'), 'b');
    final fakeAi = FakeHgNativeOnDeviceAi();
    expect((await fakeAi.availability()).backend, 'fake');
  });
}
