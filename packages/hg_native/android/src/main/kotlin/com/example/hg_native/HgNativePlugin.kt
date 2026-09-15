package com.example.hg_native

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class HgNativePlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var store: SecureStoreEngine
    private val ai = LiteRtStubEngine()

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        store = SecureStoreEngine(binding.applicationContext)
        channel = MethodChannel(binding.binaryMessenger, "hg_native")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "secureStore.write" -> {
                store.write(call.argument<String>("key")!!, call.argument<String>("value")!!)
                result.success(null)
            }
            "secureStore.read" -> result.success(store.read(call.argument<String>("key")!!))
            "secureStore.delete" -> {
                store.delete(call.argument<String>("key")!!)
                result.success(null)
            }
            "onDeviceAi.availability" -> result.success(ai.availability())
            "onDeviceAi.load" -> {
                ai.load()
                result.success(null)
            }
            "onDeviceAi.infer" -> result.success(
                ai.infer(
                    call.argument<String>("id") ?: "",
                    call.argument<String>("prompt") ?: "",
                ),
            )
            "onDeviceAi.cancel" -> result.success(null)
            "onDeviceAi.unload" -> result.success(null)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

/// v1: private prefs. Replace with EncryptedSharedPreferences / Keystore wrap.
private class SecureStoreEngine(context: Context) {
    private val prefs = context.getSharedPreferences("hg_native_secure", Context.MODE_PRIVATE)

    fun write(key: String, value: String) {
        prefs.edit().putString(key, value).apply()
    }

    fun read(key: String): String? = prefs.getString(key, null)

    fun delete(key: String) {
        prefs.edit().remove(key).apply()
    }
}

/** LiteRT / Gemini Nano adapter seam. Stub inference only. */
private class LiteRtStubEngine {
    fun availability(): Map<String, Any> = mapOf("ready" to true, "backend" to "litert-stub")

    fun load() {}

    fun infer(id: String, prompt: String): Map<String, Any> = mapOf(
        "requestId" to id,
        "text" to "On-device stub (LiteRT): $prompt",
        "done" to true,
    )
}
