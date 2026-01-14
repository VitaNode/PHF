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

@implementation OpenCVWrapper

+ (NSString * _Nullable)processImage:(NSString *)imagePath {
    if (!imagePath) return nil;
    
    std::string path = [imagePath UTF8String];
    cv::Mat src = cv::imread(path);
    
    if (src.empty()) {
        NSLog(@"OpenCVWrapper: Failed to load image at %@", imagePath);
        return nil;
    }
    
    cv::Mat gray;
    if (src.channels() == 3 || src.channels() == 4) {
        cv::cvtColor(src, gray, cv::COLOR_BGR2GRAY);
    } else {
        gray = src;
    }
    
    // 1. CLAHE (Contrast Limited Adaptive Histogram Equalization)
    cv::Ptr<cv::CLAHE> clahe = cv::createCLAHE(2.0, cv::Size(8, 8));
    cv::Mat claheResult;
    clahe->apply(gray, claheResult);
    
    // 2. Bilateral Filter (Edge-preserving smoothing)
    cv::Mat bilateral;
    cv::bilateralFilter(claheResult, bilateral, 9, 75, 75);
    
    // 3. Adaptive Threshold (Binarization)
    cv::Mat binary;
    int blockSize = src.cols / 30;
    if (blockSize % 2 == 0) blockSize++;
    if (blockSize < 3) blockSize = 3;
    
    cv::adaptiveThreshold(bilateral, binary, 255, 
                          cv::ADAPTIVE_THRESH_GAUSSIAN_C, 
                          cv::THRESH_BINARY, 
                          blockSize, 10);
    
    // Save to temp directory
    NSString *fileName = [NSString stringWithFormat:@"processed_%@.jpg", [[NSUUID UUID] UUIDString]];
    NSString *tempDir = NSTemporaryDirectory();
    NSString *outPath = [tempDir stringByAppendingPathComponent:fileName];
    
    cv::imwrite([outPath UTF8String], binary);
    
    return outPath;
}

@end
