import UIKit
import Vision

/// 负责调用 Vision Framework 进行文字识别的插件逻辑
/// 
/// Ref: Constitution#II. Local-First (Native Vision Framework)
class NativeOCRPlugin {
    
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
        
        // 2. Setup Request
        let request = VNRecognizeTextRequest { (request, error) in
            // Vision completion handler calls back on an arbitrary queue
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            self.handleDetectionResults(results: request.results) { result in
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
            
            // Vision BoundingBox: origin is bottom-left (0,0).
            // Flutter Canvas: origin is top-left (0,0).
            // Need to flip Y: fixedTop = 1.0 - bottomY - height
            let box = observation.boundingBox
            let fixedTop = 1.0 - box.origin.y - box.height
            
            blocks.append([
                "text": candidate.string,
                "left": box.origin.x,
                "top": fixedTop, 
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
