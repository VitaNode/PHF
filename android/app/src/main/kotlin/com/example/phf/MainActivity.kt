package com.example.phf

import android.graphics.Rect
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.phf/ocr"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "recognizeText") {
                val imagePath = call.argument<String>("imagePath")
                if (imagePath != null) {
                    recognizeText(imagePath, result)
                } else {
                    result.error("INVALID_ARGUMENT", "Image path is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun recognizeText(imagePath: String, result: MethodChannel.Result) {
        try {
            val file = File(imagePath)
            val image = InputImage.fromFilePath(this, Uri.fromFile(file))
            val imageWidth = image.width.toDouble()
            val imageHeight = image.height.toDouble()
            val recognizer = TextRecognition.getClient(ChineseTextRecognizerOptions.Builder().build())

            recognizer.process(image)
                .addOnSuccessListener { visionText ->
                    val jsonResult = JSONObject()
                    jsonResult.put("text", visionText.text)
                    
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
                        
                        // Added Lines and Elements (V2)
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
                            lineJson.put("confidence", 1.0)
                            
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
                                elemJson.put("confidence", 1.0)
                                elementsArray.put(elemJson)
                            }
                            lineJson.put("elements", elementsArray)
                            linesArray.put(lineJson)
                        }
                        blockJson.put("lines", linesArray)
                        blocksArray.put(blockJson)
                    }
                    jsonResult.put("blocks", blocksArray)
                    jsonResult.put("confidence", 1.0)
                    jsonResult.put("source", "google_mlkit")
                    jsonResult.put("language", "zh")
                    jsonResult.put("version", 2)
                    jsonResult.put("timestamp", System.currentTimeMillis())

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
