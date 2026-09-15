import Flutter
import Security
import UIKit

public class HgNativePlugin: NSObject, FlutterPlugin {
  private let store = KeychainSecureStore()
  private let ai = CoreMlStubEngine()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "hg_native", binaryMessenger: registrar.messenger())
    let instance = HgNativePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any]
    switch call.method {
    case "secureStore.write":
      store.write(key: args?["key"] as? String ?? "", value: args?["value"] as? String ?? "")
      result(nil)
    case "secureStore.read":
      result(store.read(key: args?["key"] as? String ?? ""))
    case "secureStore.delete":
      store.delete(key: args?["key"] as? String ?? "")
      result(nil)
    case "onDeviceAi.availability":
      result(ai.availability())
    case "onDeviceAi.load":
      result(nil)
    case "onDeviceAi.infer":
      result(ai.infer(id: args?["id"] as? String ?? "", prompt: args?["prompt"] as? String ?? ""))
    case "onDeviceAi.cancel", "onDeviceAi.unload":
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

private final class KeychainSecureStore {
  private let service = "hg_native"

  func write(key: String, value: String) {
    let data = Data(value.utf8)
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key,
    ]
    SecItemDelete(query as CFDictionary)
    var add = query
    add[kSecValueData as String] = data
    SecItemAdd(add as CFDictionary, nil)
  }

  func read(key: String) -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne,
    ]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess, let data = item as? Data else {
      return nil
    }
    return String(data: data, encoding: .utf8)
  }

  func delete(key: String) {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key,
    ]
    SecItemDelete(query as CFDictionary)
  }
}

/// Core ML adapter seam. Stub inference only — no model weights.
private final class CoreMlStubEngine {
  func availability() -> [String: Any] {
    ["ready": true, "backend": "coreml-stub"]
  }

  func infer(id: String, prompt: String) -> [String: Any] {
    [
      "requestId": id,
      "text": "On-device stub (Core ML): \(prompt)",
      "done": true,
    ]
  }
}
