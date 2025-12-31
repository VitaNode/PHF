import Flutter
import UIKit
import Vision

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let ocrChannel = FlutterMethodChannel(name: "com.example.phf/ocr",
                                              binaryMessenger: controller.binaryMessenger)
    
    ocrChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "recognizeText" {
          guard let args = call.arguments as? [String: Any],
                let imagePath = args["imagePath"] as? String else {
              result(FlutterError(code: "INVALID_ARGUMENT", message: "imagePath is required", details: nil))
              return
          }
          
          let plugin = NativeOCRPlugin()
          plugin.analyzeImage(at: imagePath) { ocrResult in
              switch ocrResult {
              case .success(let data):
                  do {
                      // Serialize to JSON String to send back to Dart (cleaner type safety than raw Maps across channel)
                      let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                      let jsonString = String(data: jsonData, encoding: .utf8)
                      result(jsonString)
                  } catch {
                      result(FlutterError(code: "JSON_ERROR", message: "Failed to serialize OCR result", details: error.localizedDescription))
                  }
              case .failure(let error):
                  result(FlutterError(code: "OCR_ERROR", message: error.localizedDescription, details: nil))
              }
          }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

/// 负责调用 Vision Framework 进行文字识别的插件逻辑
class NativeOCRPlugin {
    
    /// 执行图片 OCR
    /// - Parameters:
    ///   - path: 图片物理路径
    ///   - completion: 结果回调 (JSON字典 或 错误)
    func analyzeImage(at path: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // 1. Load Image
        guard let image = UIImage(contentsOfFile: path),
              let cgImage = image.cgImage else {
            completion(.failure(NSError(domain: "OCRPlugin", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Could not load image at path: \(path)"])))
            return
        }
        
        // 2. Setup Request
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self.handleDetectionResults(results: request.results, completion: completion)
        }
        
        // Configuration: 优化中文识别与精确度
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["zh-Hans", "en-US"] // 优先简体中文，其次英文
        request.usesLanguageCorrection = true
        
        // 3. Perform Request
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func handleDetectionResults(results: [Any]?, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let observations = results as? [VNRecognizedTextObservation] else {
            completion(.success(["text": "", "blocks": []]))
            return
        }
        
        var fullText = ""
        var blocks: [[String: Any]] = []
        var totalConfidence: Float = 0.0
        
        for observation in observations {
            // 获取最佳候选
            guard let candidate = observation.topCandidates(1).first else { continue }
            
            fullText += candidate.string + "\n"
            totalConfidence += candidate.confidence
            
            // Vision BoundingBox: origin is bottom-left.
            // 为了让 Dart 端处理更轻松，尝试转为 Top-Left normalized (y = 1 - bottom - height)
            let box = observation.boundingBox
            let fixedTop = 1.0 - box.origin.y - box.height
            
            blocks.append([
                "text": candidate.string,
                "left": box.origin.x,
                "top": fixedTop, // Flip Y for Flutter Coordinate System
                "width": box.width,
                "height": box.height
            ])
        }
        
        let avgConfidence = observations.isEmpty ? 0.0 : totalConfidence / Float(observations.count)
        
        let result: [String: Any] = [
            "text": fullText.trimmingCharacters(in: .whitespacesAndNewlines),
            "blocks": blocks,
            "confidence": avgConfidence
        ]
        
        completion(.success(result))
    }
}
