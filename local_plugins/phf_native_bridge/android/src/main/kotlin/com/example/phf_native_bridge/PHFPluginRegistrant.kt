package com.example.phf_native_bridge

import androidx.annotation.Keep
import io.flutter.embedding.engine.FlutterEngine

/**
 * PHFPluginRegistrant
 * 
 * 中央注册器：确保 OCR 和 ImageProcessor 插件在任何 FlutterEngine 中都能被正确加载。
 */
@Keep
object PHFPluginRegistrant {
    fun registerWith(flutterEngine: FlutterEngine) {
        // 检查是否已经注册，避免重复注册导致的异常
        val plugins = flutterEngine.plugins
        if (!plugins.has(OCRPlugin::class.java)) {
            plugins.add(OCRPlugin())
        }
        if (!plugins.has(ImageProcessorPlugin::class.java)) {
            plugins.add(ImageProcessorPlugin())
        }
    }
}