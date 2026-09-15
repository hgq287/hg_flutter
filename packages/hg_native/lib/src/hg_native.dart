import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hg_native/src/method_channel_ai.dart';
import 'package:hg_native/src/method_channel_secure_store.dart';
import 'package:hg_native/src/models.dart';

/// Entry point matching the Pigeon IDL in `pigeons/native_api.dart`.
///
/// Regenerate bindings with:
/// `dart run pigeon --input pigeons/native_api.dart`
class HgNative {
  static const MethodChannel channel = MethodChannel('hg_native');

  static final HgNativeSecureStore secureStore = MethodChannelSecureStore(
    channel,
  );
  static final HgNativeOnDeviceAi onDeviceAi = MethodChannelOnDeviceAi(channel);

  static bool get isPlatformSupported {
    if (kIsWeb) {
      return false;
    }
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }
}
