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
    
    try {
        const double TARGET_LONG_EDGE = 2200.0;
        cv::Mat resized;
        
        // 1. Resizing
        double width = (double)src.cols;
        double height = (double)src.rows;
        double scale = TARGET_LONG_EDGE / std::max(width, height);
        cv::resize(src, resized, cv::Size(width * scale, height * scale), 0, 0, cv::INTER_AREA);
        
        // 2. Grayscale
        cv::Mat gray;
        cv::cvtColor(resized, gray, cv::COLOR_BGR2GRAY);
        
        // 3. Deskew (HoughLinesP)
        double angle = [self computeSkewAngle:gray];
        cv::Mat deskewed;
        if (std::abs(angle) > 0.5 && std::abs(angle) < 20.0) {
            cv::Point2f center(gray.cols / 2.0, gray.rows / 2.0);
            cv::Mat rotMat = cv::getRotationMatrix2D(center, angle, 1.0);
            cv::warpAffine(gray, deskewed, rotMat, gray.size(), cv::INTER_CUBIC, cv::BORDER_REPLICATE);
        } else {
            deskewed = gray;
        }
        
        // 4. Noise Reduction (Gaussian 3x3)
        cv::Mat blurred;
        cv::GaussianBlur(deskewed, blurred, cv::Size(3, 3), 0);
        
        // 5. Dynamic C Value
        cv::Scalar mean, stddev;
        cv::meanStdDev(blurred, mean, stddev);
        double sd = stddev[0];
        double dynamicC = 12.0;
        if (sd < 30) dynamicC = 22.0;
        else if (sd < 50) dynamicC = 18.0;
        
        // 6. CLAHE
        cv::Ptr<cv::CLAHE> clahe = cv::createCLAHE(1.2, cv::Size(8, 8));
        cv::Mat claheResult;
        clahe->apply(blurred, claheResult);
        
        // 7. Adaptive Threshold Mask (using dynamic C)
        cv::Mat binaryMask;
        int blockSize = claheResult.cols / 10;
        if (blockSize % 2 == 0) blockSize++;
        if (blockSize < 3) blockSize = 3;
        
        cv::adaptiveThreshold(claheResult, binaryMask, 255,
                              cv::ADAPTIVE_THRESH_GAUSSIAN_C,
                              cv::THRESH_BINARY,
                              blockSize, dynamicC);
        
        // 8. Median Blur
        cv::Mat filteredMask;
        cv::medianBlur(binaryMask, filteredMask, 3);
        
        // 9. Whitening
        cv::Mat finalResult(claheResult.size(), claheResult.type());
        finalResult.setTo(cv::Scalar(255));
        cv::Mat binaryInv;
        cv::bitwise_not(filteredMask, binaryInv);
        claheResult.copyTo(finalResult, binaryInv);
        
        // 10. Save
        NSString *fileName = [NSString stringWithFormat:@"enhanced_%@.jpg", [[NSUUID UUID] UUIDString]];
        NSString *tempDir = NSTemporaryDirectory();
        NSString *outPath = [tempDir stringByAppendingPathComponent:fileName];
        
        std::vector<int> params;
        params.push_back(cv::IMWRITE_JPEG_QUALITY);
        params.push_back(100);
        
        if (cv::imwrite([outPath UTF8String], finalResult, params)) {
            return outPath;
        }
        return nil;
        
    } catch (...) {
        return nil;
    }
}

+ (double)computeSkewAngle:(cv::Mat &)gray {
    cv::Mat edges;
    cv::Canny(gray, edges, 50, 150);
    std::vector<cv::Vec4i> lines;
    cv::HoughLinesP(edges, lines, 1, CV_PI/180, 100, 100, 20);
    
    double angleSum = 0;
    int count = 0;
    for (size_t i = 0; i < lines.size(); i++) {
        double dx = lines[i][2] - lines[i][0];
        double dy = lines[i][3] - lines[i][1];
        double angle = atan2(dy, dx) * 180.0 / CV_PI;
        if (std::abs(angle) < 15.0) {
            angleSum += angle;
            count++;
        }
    }
    return count > 0 ? (angleSum / count) : 0.0;
}

@end