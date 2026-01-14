package com.example.phf

import org.opencv.android.OpenCVLoader
import org.opencv.core.Mat
import org.opencv.core.Size
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc
import java.io.File
import java.util.UUID

/// # ImageProcessor (Android)
/// 
/// ## Description
/// 基于原生 OpenCV 实现的图像增强处理器。
/// 
/// ## Pipeline
/// 1. Gray (灰度化)
/// 2. CLAHE (局部对比度增强)
/// 3. Bilateral Filter (保边去噪)
/// 4. Adaptive Threshold (二值化)
object ImageProcessor {
    private var isInitialized = false

    fun init() {
        if (!isInitialized) {
            isInitialized = OpenCVLoader.initDebug()
        }
    }

    fun processImage(imagePath: String): String? {
        if (!isInitialized) init()

        val src = Imgcodecs.imread(imagePath)
        if (src.empty()) return null

        val gray = Mat()
        Imgproc.cvtColor(src, gray, Imgproc.COLOR_BGR2GRAY)

        // 1. CLAHE
        val clahe = Imgproc.createCLAHE(2.0, Size(8.0, 8.0))
        val claheResult = Mat()
        clahe.apply(gray, claheResult)

        // 2. Bilateral Filter
        val bilateral = Mat()
        Imgproc.bilateralFilter(claheResult, bilateral, 9, 75.0, 75.0)

        // 3. Adaptive Threshold (Binarization)
        val binary = Mat()
        var blockSize = src.cols() / 30
        if (blockSize % 2 == 0) blockSize++
        if (blockSize < 3) blockSize = 3
        
        Imgproc.adaptiveThreshold(bilateral, binary, 255.0, 
            Imgproc.ADAPTIVE_THRESH_GAUSSIAN_C, 
            Imgproc.THRESH_BINARY, 
            blockSize, 10.0)

        // Save processed image
        val fileName = "processed_${UUID.randomUUID()}.jpg"
        val tempDir = File(imagePath).parent
        val outFile = File(tempDir, fileName)
        
        Imgcodecs.imwrite(outFile.absolutePath, binary)
        
        return outFile.absolutePath
    }
}
