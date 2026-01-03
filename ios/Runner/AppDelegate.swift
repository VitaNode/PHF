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
    
    // 现代方式获取 Registrar
    let registrar = self.registrar(forPlugin: "OCRPlugin")
    let ocrChannel = FlutterMethodChannel(name: "com.example.phf/ocr",
                                              binaryMessenger: registrar!.messenger())
    
    ocrChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "recognizeText" {
          guard let args = call.arguments as? [String: Any],
                let imagePath = args["imagePath"] as? String else {
              result(FlutterError(code: "INVALID_ARGUMENT", message: "imagePath is missing", details: nil))
              return
          }
          self.performOCR(imagePath: imagePath, result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    
    // Workmanager 注册
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
        GeneratedPluginRegistrant.register(with: registry)
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func performOCR(imagePath: String, result: @escaping FlutterResult) {
      let imageUrl = URL(fileURLWithPath: imagePath)
      guard let imageData = try? Data(contentsOf: imageUrl),
            let image = UIImage(data: imageData),
            let cgImage = image.cgImage else {
          result(FlutterError(code: "IMAGE_LOAD_FAILED", message: "Could not load image at path", details: nil))
          return
      }

      let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
      let request = VNRecognizeTextRequest { (request, error) in
          if let error = error {
              result(FlutterError(code: "OCR_ERROR", message: error.localizedDescription, details: nil))
              return
          }

          guard let observations = request.results as? [VNRecognizedTextObservation] else {
              result("{\"text\":\"\", \"blocks\":[]}")
              return
          }

          var fullText = ""
          var blocks: [[String: Any]] = []

          for observation in observations {
              guard let topCandidate = observation.topCandidates(1).first else { continue }
              fullText += topCandidate.string + "\n"

              let boundingBox = observation.boundingBox
              let block: [String: Any] = [
                  "text": topCandidate.string,
                  "left": boundingBox.origin.x,
                  "top": 1 - boundingBox.origin.y - boundingBox.height,
                  "width": boundingBox.width,
                  "height": boundingBox.height
              ]
              blocks.append(block)
          }

          let responseData: [String: Any] = [
              "text": fullText,
              "blocks": blocks,
              "confidence": 1.0
          ]

          if let jsonData = try? JSONSerialization.data(withJSONObject: responseData, options: []),
             let jsonString = String(data: jsonData, encoding: .utf8) {
              result(jsonString)
          } else {
              result(FlutterError(code: "SERIALIZATION_ERROR", message: "Failed to serialize OCR result", details: nil))
          }
      }

      request.recognitionLanguages = ["zh-Hans", "en-US"]
      request.usesLanguageCorrection = true

      DispatchQueue.global(qos: .userInitiated).async {
          do {
              try requestHandler.perform([request])
          } catch {
              result(FlutterError(code: "VN_HANDLER_ERROR", message: error.localizedDescription, details: nil))
          }
      }
  }
}
