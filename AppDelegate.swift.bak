import Flutter
import UIKit
import Vision
import workmanager_apple

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // 1. Register Workmanager Plugin and custom plugins for background execution (Headless)
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
        GeneratedPluginRegistrant.register(with: registry)
        if let registrar = registry.registrar(forPlugin: "NativeOCRPlugin") {
            NativeOCRPlugin.register(with: registrar)
        }
    }
    
    // 2. Register Plugins for Main App
    GeneratedPluginRegistrant.register(with: self)
    if let registrar = self.registrar(forPlugin: "NativeOCRPlugin") {
        NativeOCRPlugin.register(with: registrar)
    }
    
    // 3. Register Background Task Identifier
    // Handled by WorkmanagerPlugin to route BGTask to Dart callback
    WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "com.example.phf.ocr.processing_task")
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

/// 负责调用 Vision Framework 进行文字识别的插件逻辑
/// 
/// Ref: Constitution#II. Local-First (Native Vision Framework)
public class NativeOCRPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.example.phf/ocr", binaryMessenger: registrar.messenger())
        let instance = NativeOCRPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "recognizeText" {
            guard let args = call.arguments as? [String: Any],
                  let imagePath = args["imagePath"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "imagePath is required", details: nil))
                return
            }
            
            self.analyzeImage(at: imagePath) { ocrResult in
                switch ocrResult {
                case .success(let data):
                    do {
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
    }
    
    /// 执行图片 OCR
    /// - Parameters:
    ///   - path: 图片物理路径
    ///   - completion: 结果回调 (JSON字典 或 错误)。保证在 Main Thread 调用。
    func analyzeImage(at path: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // 1. Load Image
        guard let image = UIImage(contentsOfFile: path),
              let cgImage = image.cgImage else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "OCRPlugin", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Could not load image at path: \(path)"])))
            }
            return
        }
        
        let width = Double(cgImage.width)
        let height = Double(cgImage.height)
        
        // 2. Setup Request
        let request = VNRecognizeTextRequest { (request, error) in
            // Vision completion handler calls back on an arbitrary queue
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            self.handleDetectionResults(results: request.results, width: width, height: height) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
        
        // Configuration: 优化中文识别与精确度
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["zh-Hans", "en-US"] // 优先简体中文，其次英文
        request.usesLanguageCorrection = true
        
        // 3. Perform Request (Async on Global Queue)
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func handleDetectionResults(results: [Any]?, width: Double, height: Double, completion: @escaping (Result<[String: Any], Error>) -> Void) {
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
            
            // Vision BoundingBox: origin is bottom-left (0,0). Normalized (0-1).
            // Flutter Canvas: origin is top-left (0,0). Absolute pixels.
            // Need to flip Y and denormalize.
            
            let box = observation.boundingBox
            
            // Vision Y is from bottom. 
            // y_top = 1.0 - y_bottom - height_norm
            let yBottom = box.origin.y
            let hNorm = box.height
            let yTopNorm = 1.0 - yBottom - hNorm
            
            blocks.append([
                "text": candidate.string,
                "left": box.origin.x * width,
                "top": yTopNorm * height, 
                "width": box.width * width,
                "height": box.height * height
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
