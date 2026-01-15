package com.example.phf

import android.content.IntentSender
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions
import com.google.mlkit.vision.documentscanner.GmsDocumentScanning
import com.google.mlkit.vision.documentscanner.GmsDocumentScanningResult

class MainActivity: FlutterActivity() {
    private val SCANNER_CHANNEL = "com.example.phf/scanner"
    private val SCAN_REQUEST_CODE = 1001
    private var scannerResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Local plugins (OCR, ImageProcessor) are now auto-registered via PhfNativeBridgePlugin

        // Scanner Channel (Maintains Activity dependency)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SCANNER_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "scanDocument") {
                startScanning(result)
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
            .setScannerMode(GmsDocumentScannerOptions.SCANNER_MODE_BASE) // Manual mode: Capture and crop manually
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
}
