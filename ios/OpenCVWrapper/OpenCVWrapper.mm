// OpenCV headers MUST be first to avoid conflicts with Apple's NO macro
#ifdef __cplusplus
// Undefine NO to prevent conflict with OpenCV's enum { NO }
#ifdef NO
#undef NO
#endif
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#endif

#import "OpenCVWrapper.h"

/// # OpenCVWrapper (iOS)
/// 
/// ## Hardening Features
/// - **Scoped Memory**: intermediate cv::Mat objects are released when they go out of scope.
/// - **Performance**: Downscales images to max 2000px to prevent OOM during Bilateral filtering.
/// - **Safety**: Explicit path validation.

@implementation OpenCVWrapper

+ (NSString * _Nullable)processImage:(NSString *)imagePath {
    if (!imagePath) return nil;
    
    std::string path = [imagePath UTF8String];
    cv::Mat src = cv::imread(path);
    
    if (src.empty()) {
        NSLog(@"OpenCVWrapper: Failed to load image at %@", imagePath);
        return nil;
    }
    
    try {
        const double MAX_DIMENSION = 2000.0;
        cv::Mat targetSrc;
        
        // 0. Downscale if too large
        double scale = std::min(1.0, std::min(MAX_DIMENSION / src.cols, MAX_DIMENSION / src.rows));
        if (scale < 1.0) {
            cv::resize(src, targetSrc, cv::Size(src.cols * scale, src.rows * scale));
        } else {
            targetSrc = src;
        }
        
        cv::Mat gray;
        if (targetSrc.channels() == 3 || targetSrc.channels() == 4) {
            cv::cvtColor(targetSrc, gray, cv::COLOR_BGR2GRAY);
        } else {
            gray = targetSrc;
        }
        
        // 1. CLAHE
        cv::Ptr<cv::CLAHE> clahe = cv::createCLAHE(2.0, cv::Size(8, 8));
        cv::Mat claheResult;
        clahe->apply(gray, claheResult);
        
        // 2. Bilateral Filter
        cv::Mat bilateral;
        cv::bilateralFilter(claheResult, bilateral, 9, 75, 75);
        
        // 3. Adaptive Threshold
        cv::Mat binary;
        int blockSize = targetSrc.cols / 30;
        if (blockSize % 2 == 0) blockSize++;
        if (blockSize < 3) blockSize = 3;
        
        cv::adaptiveThreshold(bilateral, binary, 255, 
                              cv::ADAPTIVE_THRESH_GAUSSIAN_C, 
                              cv::THRESH_BINARY, 
                              blockSize, 10);
        
        // 4. Save to temp
        NSString *fileName = [NSString stringWithFormat:@"processed_%@.jpg", [[NSUUID UUID] UUIDString]];
        NSString *tempDir = NSTemporaryDirectory();
        NSString *outPath = [tempDir stringByAppendingPathComponent:fileName];
        
        if (cv::imwrite([outPath UTF8String], binary)) {
            return outPath;
        }
        return nil;
        
    } catch (const cv::Exception& e) {
        NSLog(@"OpenCVWrapper: cv::Exception: %s", e.what());
        return nil;
    } catch (...) {
        NSLog(@"OpenCVWrapper: Unknown processing error");
        return nil;
    }
    // C++ Mat objects will be automatically released as they go out of scope
}

@end