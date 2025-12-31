import Flutter
import UIKit
import Vision
import workmanager

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    
    // Register Workmanager Plugin
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
        GeneratedPluginRegistrant.register(with: registry)
    }
    
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

