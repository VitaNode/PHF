package com.example.phf

import android.content.IntentSender
import android.graphics.Rect
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions
import com.google.mlkit.vision.text.latin.TextRecognizerOptions
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions
import com.google.mlkit.vision.documentscanner.GmsDocumentScanning
import com.google.mlkit.vision.documentscanner.GmsDocumentScanningResult
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

class MainActivity: FlutterActivity() {
    private val OCR_CHANNEL = "com.example.phf/ocr"
    private val SCANNER_CHANNEL = "com.example.phf/scanner"
    private val PROCESSOR_CHANNEL = "com.example.phf/image_processor"
    
    private val SCAN_REQUEST_CODE = 1001
    private var scannerResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize OpenCV
        ImageProcessor.init()

        // OCR Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, OCR_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "recognizeText") {
                val imagePath = call.argument<String>("imagePath")
                val language = call.argument<String>("language") ?: "zh"
                if (imagePath != null) {
                    recognizeText(imagePath, language, result)
                } else {
                    result.error("INVALID_ARGUMENT", "Image path is null", null)
                }
            } else {
                result.notImplemented()
            }
        }

        // Scanner Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SCANNER_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "scanDocument") {
                startScanning(result)
            } else {
                result.notImplemented()
            }
        }

        // Image Processor Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PROCESSOR_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "processImage") {
                val path = call.argument<String>("path")
                if (path != null) {
                    Thread {
                        val processedPath = ImageProcessor.processImage(path)
                        runOnUiThread {
                            if (processedPath != null) {
                                result.success(processedPath)
                            } else {
                                result.error("PROCESSING_FAILED", "OpenCV processing failed", null)
                            }
                        }
                    }.start()
                } else {
                    result.error("INVALID_ARGUMENT", "Path is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun startScanning(result: MethodChannel.Result) {
        this.scannerResult = result
        val options = GmsDocumentScannerOptions.Builder()
            .setGalleryImportAllowed(true)
            .setResultFormats(GmsDocumentScannerOptions.RESULT_FORMAT_JPEG)
            .setScannerMode(GmsDocumentScannerOptions.SCANNER_MODE_FULL)
            .build()
        
        val scanner = GmsDocumentScanning.getClient(options)
        scanner.getStartScanIntent(this)
            .addOnSuccessListener { intentSender ->
                try {
                    startIntentSenderForResult(intentSender, SCAN_REQUEST_CODE, null, 0, 0, 0)
                } catch (e: IntentSender.SendIntentException) {
                    scannerResult?.error("START_FAILED", e.message, null)
                    scannerResult = null
                }
            }
            .addOnFailureListener { e ->
                scannerResult?.error("SETUP_FAILED", e.message, null)
                scannerResult = null
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: android.content.Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == SCAN_REQUEST_CODE) {
            if (resultCode == android.app.Activity.RESULT_OK) {
                val resultModel = GmsDocumentScanningResult.fromActivityResultIntent(data)
                resultModel?.pages?.let { pages ->
                    val paths = pages.mapNotNull { it.imageUri.path }
                    scannerResult?.success(paths)
                } ?: scannerResult?.error("NO_DATA", "No scan data found", null)
            } else if (resultCode == android.app.Activity.RESULT_CANCELED) {
                 scannerResult?.error("CANCELLED", "User cancelled", null)
            } else {
                 scannerResult?.error("ERROR", "Scan failed", null)
            }
            scannerResult = null
        }
    }

    private fun recognizeText(imagePath: String, language: String, result: MethodChannel.Result) {
        try {
            val file = File(imagePath)
            val image = InputImage.fromFilePath(this, Uri.fromFile(file))
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
                        blockJson.put("confidence", 1.0)
                        blocksArray.put(blockJson)
                    }

                    val pageJson = JSONObject()
                    pageJson.put("pageNumber", 0)
                    pageJson.put("blocks", blocksArray)
                    pageJson.put("confidence", 1.0)
                    pageJson.put("width", imageWidth)
                    pageJson.put("height", imageHeight)

                    val pagesArray = JSONArray()
                    pagesArray.put(pageJson)

                    jsonResult.put("pages", pagesArray)
                    jsonResult.put("confidence", 1.0)
                    jsonResult.put("source", "google_mlkit")
                    jsonResult.put("language", language)
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