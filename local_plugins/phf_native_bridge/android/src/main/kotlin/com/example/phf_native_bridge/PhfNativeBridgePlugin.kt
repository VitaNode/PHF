package com.example.phf_native_bridge

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin

class PhfNativeBridgePlugin: FlutterPlugin {
    private val ocrPlugin = OCRPlugin()
    private val imageProcessorPlugin = ImageProcessorPlugin()

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        ocrPlugin.onAttachedToEngine(binding)
        imageProcessorPlugin.onAttachedToEngine(binding)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        ocrPlugin.onDetachedFromEngine(binding)
        imageProcessorPlugin.onDetachedFromEngine(binding)
    }
}