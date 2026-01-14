package com.example.phf

import android.util.Log
import org.opencv.android.OpenCVLoader
import org.opencv.core.Mat
import org.opencv.core.Size
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc
import java.io.File
import java.util.UUID
import kotlin.math.min

/// # ImageProcessor (Android)
/// 
/// ## Hardening Features
/// - **Native Memory Safety**: Explicitly calls .release() on all intermediate Mat objects.
/// - **Stability**: Validates OpenCV initialization before processing.
/// - **Performance**: Downscales images to max 2000px to prevent OOM.
/// - **Path Safety**: Saves to app-specific cache directory.
object ImageProcessor {
    private const val TAG = "ImageProcessor"
    private const val MAX_DIMENSION = 2000.0
    private var isInitialized = false

    fun init(): Boolean {
        if (!isInitialized) {
            isInitialized = OpenCVLoader.initDebug()
            if (!isInitialized) {
                Log.e(TAG, "OpenCV initialization failed.")
            }
        }
        return isInitialized
    }

    fun processImage(imagePath: String, outputDir: String): String? {
        if (!init()) return null

        val src = Imgcodecs.imread(imagePath)
        if (src.empty()) {
            Log.e(TAG, "Failed to load image: $imagePath")
            return null
        }

        // Intermediate objects to release
        var resized: Mat? = null
        var gray: Mat? = null
        var claheResult: Mat? = null
        var bilateral: Mat? = null
        var binary: Mat? = null

        try {
            // 0. Resize if too large (OOM Prevention)
            val scale = min(1.0, min(MAX_DIMENSION / src.cols(), MAX_DIMENSION / src.rows()))
            val targetSrc = if (scale < 1.0) {
                resized = Mat()
                Imgproc.resize(src, resized, Size(src.cols() * scale, src.rows() * scale))
                resized
            } else {
                src
            }

            // 1. Gray
            gray = Mat()
            Imgproc.cvtColor(targetSrc, gray, Imgproc.COLOR_BGR2GRAY)

            // 2. CLAHE (Local Contrast Enhancement)
            val clahe = Imgproc.createCLAHE(2.0, Size(8.0, 8.0))
            claheResult = Mat()
            clahe.apply(gray, claheResult)

            // 3. Bilateral Filter (Smooth background, keep edges)
            bilateral = Mat()
            Imgproc.bilateralFilter(claheResult, bilateral, 9, 75.0, 75.0)

            // 4. Adaptive Threshold (Dynamic Binarization)
            binary = Mat()
            var blockSize = targetSrc.cols() / 30
            if (blockSize % 2 == 0) blockSize++
            if (blockSize < 3) blockSize = 3
            
            Imgproc.adaptiveThreshold(bilateral, binary, 255.0, 
                Imgproc.ADAPTIVE_THRESH_GAUSSIAN_C, 
                Imgproc.THRESH_BINARY, 
                blockSize, 10.0)

            // 5. Save to safe output directory
            val fileName = "processed_${UUID.randomUUID()}.jpg"
            val outFile = File(outputDir, fileName)
            
            if (Imgcodecs.imwrite(outFile.absolutePath, binary)) {
                return outFile.absolutePath
            }
            return null
        } catch (e: Exception) {
            Log.e(TAG, "OpenCV Processing Error: ${e.message}")
            return null
        } finally {
            // CRITICAL: Prevent Native Memory Leak
            src.release()
            resized?.release()
            gray?.release()
            claheResult?.release()
            bilateral?.release()
            binary?.release()
        }
    }
}