package com.example.phf_native_bridge

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ImageProcessorPlugin: FlutterPlugin, MethodChannel.MethodCallHandler {
    private var channel: MethodChannel? = null
    private var context: Context? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.example.phf/image_processor")
        channel?.setMethodCallHandler(this)
        context = binding.applicationContext
        ImageProcessor.init()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
        context = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "processImage") {
            val path = call.argument<String>("path")
            val mode = call.argument<String>("mode") ?: "CAMERA"
            val currentContext = context
            if (path != null && currentContext != null) {
                val cacheDir = currentContext.cacheDir.absolutePath
                Thread {
                    val processedPath = ImageProcessor.processImage(path, cacheDir, mode)
                    mainHandler.post {
                        if (processedPath != null) {
                            result.success(processedPath)
                        } else {
                            result.error("PROCESSING_FAILED", "OpenCV processing failed", null)
                        }
                    }
                }.start()
            } else {
                result.error("INVALID_ARGUMENT", "Path or Context is null", null)
            }
        } else {
            result.notImplemented()
        }
    }
}