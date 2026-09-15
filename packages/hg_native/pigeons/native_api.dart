import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/generated/native_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/src/main/kotlin/com/example/hg_native/NativeApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.example.hg_native'),
    swiftOut: 'ios/Classes/NativeApi.g.swift',
    swiftOptions: SwiftOptions(),
  ),
)
class NativeModelSpec {
  late String id;
  late String source;
  String? preferredBackend;
}

class NativeInferenceRequest {
  late String id;
  late String modality;
  late String prompt;
}

class NativeInferenceEvent {
  late String requestId;
  late String text;
  late bool done;
}

class NativeAiAvailability {
  late bool ready;
  late String backend;
}

@HostApi()
abstract class SecureStoreHost {
  void write(String key, String value);
  String? read(String key);
  void delete(String key);
}

@HostApi()
abstract class OnDeviceAiHost {
  NativeAiAvailability availability();
  void load(NativeModelSpec spec);
  NativeInferenceEvent infer(NativeInferenceRequest request);
  void cancel(String requestId);
  void unload();
}
