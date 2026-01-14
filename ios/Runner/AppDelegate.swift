import Flutter
import UIKit
import Vision
import VisionKit

#if canImport(workmanager_apple)
import workmanager_apple
#elseif canImport(workmanager)
import workmanager
#endif

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  var scannerResult: FlutterResult?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // 获取 Registrar
    let registrar = self.registrar(forPlugin: "OCRPlugin")
    
    // 1. OCR Channel
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
          let language = args["language"] as? String ?? "zh-Hans"
          self.performOCR(imagePath: imagePath, language: language, result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    // 2. Scanner Channel
    let scannerChannel = FlutterMethodChannel(name: "com.example.phf/scanner",
                                              binaryMessenger: registrar!.messenger())
    scannerChannel.setMethodCallHandler { [weak self] (call, result) in
        guard let self = self else { return }
        if call.method == "scanDocument" {
            self.startScanning(result: result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    // 3. Image Processor Channel (OpenCV)
    let processorChannel = FlutterMethodChannel(name: "com.example.phf/image_processor",
                                                binaryMessenger: registrar!.messenger())
    processorChannel.setMethodCallHandler { (call, result) in
        if call.method == "processImage" {
            guard let args = call.arguments as? [String: Any],
                  let path = args["path"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Path is missing", details: nil))
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                if let processedPath = OpenCVWrapper.processImage(path) {
                    DispatchQueue.main.async {
                        result(processedPath)
                    }
                } else {
                    DispatchQueue.main.async {
                        result(FlutterError(code: "PROCESSING_FAILED", message: "OpenCV processing failed", details: nil))
                    }
                }
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    GeneratedPluginRegistrant.register(with: self)
    
    // Workmanager 注册
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
        GeneratedPluginRegistrant.register(with: registry)
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func startScanning(result: @escaping FlutterResult) {
      guard VNDocumentCameraViewController.isSupported else {
          result(FlutterError(code: "UNSUPPORTED", message: "Document scanning is not supported on this device", details: nil))
          return
      }

      self.scannerResult = result
      let scanner = VNDocumentCameraViewController()
      scanner.delegate = self
      
      if let controller = self.window?.rootViewController {
          controller.present(scanner, animated: true, completion: nil)
      } else {
          result(FlutterError(code: "UI_ERROR", message: "Root view controller not found", details: nil))
      }
  }

  private func performOCR(imagePath: String, language: String, result: @escaping FlutterResult) {
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
              
              let line: [String: Any] = [
                  "text": topCandidate.string,
                  "x": boundingBox.origin.x,
                  "y": 1 - boundingBox.origin.y - boundingBox.height,
                  "w": boundingBox.width,
                  "h": boundingBox.height,
                  "confidence": topCandidate.confidence,
                  "elements": []
              ]

              let block: [String: Any] = [
                  "text": topCandidate.string,
                  "x": boundingBox.origin.x,
                  "y": 1 - boundingBox.origin.y - boundingBox.height,
                  "w": boundingBox.width,
                  "h": boundingBox.height,
                  "lines": [line],
                  "confidence": topCandidate.confidence
              ]
              blocks.append(block)
          }

          let page: [String: Any] = [
              "pageNumber": 0,
              "blocks": blocks,
              "confidence": 1.0,
              "width": Double(cgImage.width),
              "height": Double(cgImage.height)
          ]

          let responseData: [String: Any] = [
              "text": fullText,
              "pages": [page],
              "confidence": 1.0,
              "source": "ios_vision",
              "language": language,
              "version": 2,
              "timestamp": Int64(Date().timeIntervalSince1970 * 1000)
          ]

          if let jsonData = try? JSONSerialization.data(withJSONObject: responseData, options: []),
             let jsonString = String(data: jsonData, encoding: .utf8) {
              result(jsonString)
          } else {
              result(FlutterError(code: "SERIALIZATION_ERROR", message: "Failed to serialize OCR result", details: nil))
          }
      }

      request.recognitionLanguages = [language, "en-US"]
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

extension AppDelegate: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        var scannedPages: [String] = []
        let tempDir = FileManager.default.temporaryDirectory
        
        for i in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: i)
            let uuid = UUID().uuidString
            let fileUrl = tempDir.appendingPathComponent("scan_\(uuid).jpg")
            
            if let data = image.jpegData(compressionQuality: 0.8) {
                try? data.write(to: fileUrl)
                scannedPages.append(fileUrl.path)
            }
        }
        
        controller.dismiss(animated: true) {
            self.scannerResult?(scannedPages)
            self.scannerResult = nil
        }
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true) {
            self.scannerResult?(FlutterError(code: "CANCELLED", message: "User cancelled scanning", details: nil))
            self.scannerResult = nil
        }
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true) {
            self.scannerResult?(FlutterError(code: "SCAN_ERROR", message: error.localizedDescription, details: nil))
            self.scannerResult = nil
        }
    }
}
