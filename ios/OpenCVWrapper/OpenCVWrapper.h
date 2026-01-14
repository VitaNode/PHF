#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (NSString * _Nullable)processImage:(NSString *)imagePath;

@end

NS_ASSUME_NONNULL_END
