import Flutter
import UIKit
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let visionChannel = FlutterMethodChannel(name: "com.kuroki.silhouettequiz/vision",
                                              binaryMessenger: controller.binaryMessenger)
    
    visionChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "generateSilhouette" {
        guard let args = call.arguments as? [String: Any],
              let imagePath = args["path"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Path is required", details: nil))
          return
        }
        
        if #available(iOS 17.0, *) {
          self.generateSilhouette(imagePath: imagePath, result: result)
        } else {
          // Explicitly signal fallback for older iOS
          result(FlutterError(code: "FALLBACK", message: "Vision API requires iOS 17+", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  @available(iOS 17.0, *)
  private func generateSilhouette(imagePath: String, result: @escaping FlutterResult) {
    let fileURL = URL(fileURLWithPath: imagePath)
    guard let inputImage = CIImage(contentsOf: fileURL) else {
      result(FlutterError(code: "LOAD_ERROR", message: "Failed to load image", details: nil))
      return
    }

    let request = VNGenerateForegroundInstanceMaskRequest()
    let handler = VNImageRequestHandler(ciImage: inputImage, options: [:])

    DispatchQueue.global(qos: .userInitiated).async {
      do {
        try handler.perform([request])
        guard let observation = request.results?.first else {
          DispatchQueue.main.async { result(FlutterError(code: "NO_RESULT", message: "No object found", details: nil)) }
          return
        }

        let allInstances = observation.allInstances
        guard let maskBuffer = try? observation.generateScaledMaskForImage(forInstances: allInstances, from: handler) else {
             DispatchQueue.main.async { result(FlutterError(code: "MASK_ERROR", message: "Failed to generate mask", details: nil)) }
             return
        }
        let maskImage = CIImage(cvPixelBuffer: maskBuffer)

        // Resize mask to match original image
        let scaleX = inputImage.extent.width / maskImage.extent.width
        let scaleY = inputImage.extent.height / maskImage.extent.height
        let scaledMask = maskImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        // Create a black image
        let blackImage = CIImage(color: CIColor.black).cropped(to: inputImage.extent)

        // Blend black image with mask (mask acts as alpha)
        let blendFilter = CIFilter.blendWithMask()
        blendFilter.inputImage = blackImage
        blendFilter.maskImage = scaledMask
        // Background should be transparent, so backgroundImage is clear
        // Actually blendWithMask puts inputImage where mask is white (1.0), and backgroundImage where mask is black (0.0).
        // VNGenerateForegroundInstanceMaskRequest returns 1.0 for subject.
        // We want subject to be Black (0,0,0,255) and background Transparent (0,0,0,0).
        
        // Let's use standard masking:
        // Output = Object (Black) * Mask + Background (Transparent) * (1-Mask)
        // Since Background is transparent, we just need Object * Mask.
        // CIImage(color: .black) is infinite black.
        
        // Use simpler approach:
        // 1. Create solid black image
        // 2. Apply the mask to the alpha channel of the black image
        
        // Using CIAttributeTypeImage as mask
        let maskFilter = CIFilter.maskToAlpha() // This converts grayscale to alpha, might not be exactly what we want if mask is already valid
        // Actually, core image masking:
        // output = input * mask
        
        // Let's keep it simple:
        // Use simpler approach compatible with CIImage
        let finalImage = blackImage.applyingFilter("CIBlendWithMask", parameters: [
            kCIInputMaskImageKey: scaledMask
        ])
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(finalImage, from: inputImage.extent) else {
             DispatchQueue.main.async { result(FlutterError(code: "RENDER_ERROR", message: "Failed to render image", details: nil))
             }
             return
        }
        
        let uiImage = UIImage(cgImage: cgImage)
        guard let data = uiImage.pngData() else {
             DispatchQueue.main.async { result(FlutterError(code: "ENCODE_ERROR", message: "Failed to encode PNG", details: nil))
             }
             return
        }
        
        let fileManager = FileManager.default
        let newPath = fileURL.deletingPathExtension().appendingPathExtension("silhouette.png").path
        
        if fileManager.fileExists(atPath: newPath) {
             try? fileManager.removeItem(atPath: newPath)
        }
        
        fileManager.createFile(atPath: newPath, contents: data, attributes: nil)
        
        DispatchQueue.main.async {
          result(newPath)
        }

      } catch {
        DispatchQueue.main.async {
          result(FlutterError(code: "VISION_ERROR", message: error.localizedDescription, details: nil))
        }
      }
    }
  }
}
