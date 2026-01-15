package com.example.phf_native_bridge

import android.util.Log
import org.opencv.android.OpenCVLoader
import org.opencv.core.*
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc
import java.io.File
import java.util.UUID
import kotlin.math.max
import kotlin.math.abs

object ImageProcessor {
    private const val TAG = "ImageProcessor"
    private const val TARGET_LONG_EDGE = 2200.0
    private var isInitialized = false

    fun init(): Boolean {
        if (!isInitialized) {
            isInitialized = OpenCVLoader.initDebug()
        }
        return isInitialized
    }

    fun processImage(imagePath: String, outputDir: String, mode: String = "CAMERA"): String? {
        if (!init()) return null

        val src = Imgcodecs.imread(imagePath)
        if (src.empty()) return null

        val resized = Mat()
        val gray = Mat()
        val denoised = Mat()
        val deskewed = Mat()
        val claheResult = Mat()
        val finalResult = Mat()

        try {
            // 1. 缩放
            val width = src.cols().toDouble()
            val height = src.rows().toDouble()
            val scale = TARGET_LONG_EDGE / max(width, height)
            Imgproc.resize(src, resized, Size(width * scale, height * scale), 0.0, 0.0, Imgproc.INTER_AREA)

            // 2. 灰度化
            Imgproc.cvtColor(resized, gray, Imgproc.COLOR_BGR2GRAY)

            // 3. 倾斜校正 (HoughLines 方案)
            val angle = computeSkewAngle(gray)
            if (abs(angle) > 0.5 && abs(angle) < 20.0) {
                val center = Point(gray.cols() / 2.0, gray.rows() / 2.0)
                val rotMat = Imgproc.getRotationMatrix2D(center, angle, 1.0)
                Imgproc.warpAffine(gray, deskewed, rotMat, gray.size(), Imgproc.INTER_CUBIC, Core.BORDER_REPLICATE)
                rotMat.release()
            } else {
                gray.copyTo(deskewed)
            }

            // 4. 高级去噪 (非局部均值去噪) - 专门对付弱光下的黑点噪点
            // h=3 左右可以在保留文字细节的同时清除背景微波噪声
            Imgproc.GaussianBlur(deskewed, denoised, Size(3.0, 3.0), 0.0)

            // 5. 动态 C 值计算
            // 计算图像标准差
            val mean = MatOfDouble()
            val stddev = MatOfDouble()
            Core.meanStdDev(denoised, mean, stddev)
            val sd = stddev.toArray()[0]
            
            // 动态调整 C: 标准差越小(光线越暗/对比度越低)，C 越高以压制背景
            var dynamicC = 12.0
            if (sd < 30) {
                dynamicC = 22.0 // 极暗环境
            } else if (sd < 50) {
                dynamicC = 18.0 // 较暗环境
            }

            // 6. CLAHE
            val clahe = Imgproc.createCLAHE(1.2, Size(8.0, 8.0))
            clahe.apply(denoised, claheResult)

            if (mode == "UPLOAD") {
                claheResult.copyTo(finalResult)
            } else {
                // 7. 自适应二值化 (使用动态 C)
                var blockSize = claheResult.cols() / 10 
                if (blockSize % 2 == 0) blockSize++
                
                val binaryMask = Mat()
                Imgproc.adaptiveThreshold(
                    claheResult, binaryMask, 255.0, 
                    Imgproc.ADAPTIVE_THRESH_GAUSSIAN_C, 
                    Imgproc.THRESH_BINARY, 
                    blockSize, dynamicC
                )

                // 8. 中值滤波 (3x3) 去除孤立黑点
                val filteredMask = Mat()
                Imgproc.medianBlur(binaryMask, filteredMask, 3)

                finalResult.create(claheResult.size(), claheResult.type())
                finalResult.setTo(Scalar(255.0))
                
                val binaryInv = Mat()
                Core.bitwise_not(filteredMask, binaryInv) 
                claheResult.copyTo(finalResult, binaryInv) 
                
                binaryMask.release()
                filteredMask.release()
                binaryInv.release()
            }

            val outputColor = Mat()
            Imgproc.cvtColor(finalResult, outputColor, Imgproc.COLOR_GRAY2BGR)

            val params = MatOfInt(Imgcodecs.IMWRITE_JPEG_QUALITY, 100)
            val fileName = "enhanced_${UUID.randomUUID()}.jpg"
            val outFile = File(outputDir, fileName)
            
            if (Imgcodecs.imwrite(outFile.absolutePath, outputColor, params)) {
                outputColor.release()
                params.release()
                return outFile.absolutePath
            }
            return null
        } catch (e: Exception) {
            Log.e(TAG, "OpenCV Error: ${e.message}")
            return null
        } finally {
            src.release()
            resized.release()
            gray.release()
            denoised.release()
            deskewed.release()
            claheResult.release()
            finalResult.release()
        }
    }

    /**
     * 基于霍夫变换计算文本倾斜角 (更稳健)
     */
    private fun computeSkewAngle(gray: Mat): Double {
        val edges = Mat()
        Imgproc.Canny(gray, edges, 50.0, 150.0, 3, false)
        
        val lines = Mat()
        // 寻找长直线特征
        Imgproc.HoughLinesP(edges, lines, 1.0, Math.PI / 180, 100, 100.0, 20.0)
        
        var angleSum = 0.0
        var count = 0
        
        for (i in 0 until lines.rows()) {
            val l = lines.get(i, 0)
            val dx = l[2] - l[0]
            val dy = l[3] - l[1]
            val angle = Math.atan2(dy, dx) * 180.0 / Math.PI
            
            // 过滤掉垂直线和极端倾斜线，只看水平附近的线 (±15度)
            if (abs(angle) < 15.0) {
                angleSum += angle
                count++
            }
        }
        
        edges.release()
        lines.release()
        
        return if (count > 0) angleSum / count else 0.0
    }
}
