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
                            blockJson.put("left", rect.left.toDouble())
                            blockJson.put("top", rect.top.toDouble())
                            blockJson.put("width", rect.width().toDouble())
                            blockJson.put("height", rect.height().toDouble())
                        }
                        blocksArray.put(blockJson)
                    }
                    jsonResult.put("blocks", blocksArray)
                    jsonResult.put("confidence", 1.0) // ML Kit doesn't provide global confidence easily

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