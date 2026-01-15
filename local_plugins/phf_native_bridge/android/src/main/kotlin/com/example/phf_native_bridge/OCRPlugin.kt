package com.example.phf_native_bridge

import android.content.Context
import android.graphics.Rect
import android.net.Uri
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions
import com.google.mlkit.vision.text.latin.TextRecognizerOptions
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

class OCRPlugin: FlutterPlugin, MethodChannel.MethodCallHandler {
    private var channel: MethodChannel? = null
    private var context: Context? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.example.phf/ocr")
        channel?.setMethodCallHandler(this)
        context = binding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
        context = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "recognizeText") {
            val imagePath = call.argument<String>("imagePath")
            val language = call.argument<String>("language") ?: "zh"
            val currentContext = context
            if (imagePath != null && currentContext != null) {
                recognizeText(currentContext, imagePath, language, result)
            } else {
                result.error("INVALID_ARGUMENT", "Image path or Context is null", null)
            }
        } else {
            result.notImplemented()
        }
    }

    private fun recognizeText(ctx: Context, imagePath: String, language: String, result: MethodChannel.Result) {
        try {
            val file = File(imagePath)
            val image = InputImage.fromFilePath(ctx, Uri.fromFile(file))
            val imageWidth = image.width.toDouble()
            val imageHeight = image.height.toDouble()
            
            val options = if (language.startsWith("zh")) {
                ChineseTextRecognizerOptions.Builder().build()
            } else {
                TextRecognizerOptions.Builder().build()
            }
            val recognizer = TextRecognition.getClient(options)

            recognizer.process(image)
                .addOnSuccessListener { visionText ->
                    val jsonResult = JSONObject()
                    jsonResult.put("text", visionText.text)
                    
                    var totalConfidence = 0.0
                    var elementCount = 0

                    val blocksArray = JSONArray()
                    for (block in visionText.textBlocks) {
                        val blockJson = JSONObject()
                        blockJson.put("text", block.text)
                        
                        val rect: Rect? = block.boundingBox
                        if (rect != null) {
                            blockJson.put("x", rect.left.toDouble() / imageWidth)
                            blockJson.put("y", rect.top.toDouble() / imageHeight)
                            blockJson.put("w", rect.width().toDouble() / imageWidth)
                            blockJson.put("h", rect.height().toDouble() / imageHeight)
                        }
                        
                        val linesArray = JSONArray()
                        for (line in block.lines) {
                            val lineJson = JSONObject()
                            lineJson.put("text", line.text)
                            val lRect = line.boundingBox
                            if (lRect != null) {
                                lineJson.put("x", lRect.left.toDouble() / imageWidth)
                                lineJson.put("y", lRect.top.toDouble() / imageHeight)
                                lineJson.put("w", lRect.width().toDouble() / imageWidth)
                                lineJson.put("h", lRect.height().toDouble() / imageHeight)
                            }
                            
                            // ML Kit doesn't provide line-level confidence directly for all models, 
                            // we calculate it from elements
                            var lineConfSum = 0.0
                            val elementsArray = JSONArray()
                            for (element in line.elements) {
                                val elemJson = JSONObject()
                                elemJson.put("text", element.text)
                                val eRect = element.boundingBox
                                if (eRect != null) {
                                    elemJson.put("x", eRect.left.toDouble() / imageWidth)
                                    elemJson.put("y", eRect.top.toDouble() / imageHeight)
                                    elemJson.put("w", eRect.width().toDouble() / imageWidth)
                                    elemJson.put("h", eRect.height().toDouble() / imageHeight)
                                }
                                val conf = element.confidence ?: 1.0f
                                elemJson.put("confidence", conf.toDouble())
                                lineConfSum += conf
                                totalConfidence += conf
                                elementCount++
                                elementsArray.put(elemJson)
                            }
                            lineJson.put("elements", elementsArray)
                            lineJson.put("confidence", if (line.elements.isEmpty()) 1.0 else lineConfSum.toDouble() / line.elements.size)
                            linesArray.put(lineJson)
                        }
                        blockJson.put("lines", linesArray)
                        blockJson.put("confidence", 1.0) // Block level is aggregate
                        blocksArray.put(blockJson)
                    }

                    val pageJson = JSONObject()
                    pageJson.put("blocks", blocksArray)
                    pageJson.put("width", imageWidth)
                    pageJson.put("height", imageHeight)
                    pageJson.put("confidence", if (elementCount == 0) 1.0 else totalConfidence / elementCount)
                    
                    val pagesArray = JSONArray()
                    pagesArray.put(pageJson)
                    
                    jsonResult.put("pages", pagesArray)
                    jsonResult.put("confidence", if (elementCount == 0) 1.0 else totalConfidence / elementCount)
                    jsonResult.put("source", "google_mlkit")
                    jsonResult.put("version", 2)

                    result.success(jsonResult.toString())
                }
                .addOnFailureListener { e ->
                    result.error("OCR_FAILED", e.message, null)
                }
        } catch (e: Exception) {
            result.error("EXCEPTION", e.message, null)
        }
    }
}
