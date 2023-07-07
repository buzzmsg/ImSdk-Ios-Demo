//
//  IMCompressPicManager.h
//  asfsdgfsdfhdfghd
//
//  Created by  on 2021/8/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMCompressPicManager : NSObject

+ (UIImage *)compressImageSize:(UIImage *)image toByte:(double)maxLength;

+ (NSString *)lastPathComponent:(NSString *)filePath;
+ (NSString *)pathExtension:(NSString *)filePath;
+ (BOOL)isPngOrJpg:(NSString *)name;
+ (NSString *)deletingLastPathComponent:(NSString *)filePath;
// get video cover
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL;

+ (UIImage *)imageUserToCompressForSizeImage:(UIImage *)image newSize:(CGSize)size;

+ (void)imageUserToCompressForSizeImage:(UIImage *)sourceImage newSize:(CGSize)size complationHandle:(void(^)(UIImage *resultImage))completed;

+ (void)imageUserToCompressForFilePath:(NSString *)filePath newSize:(CGSize)size complationHandle:(void(^)(UIImage *resultImage))completed;

+ (NSString *)getLastComponent:(NSString *)filePath;

+ (void)compressImageSize:(UIImage *)image toByte:(double)maxLength complationHandle:(void(^)(UIImage *resultImage, BOOL error))completed;

//last 4b
+ (NSString *)getLastfourComponent:(NSString *)filename;

+ (NSString *)getfirstfourComponent:(NSString *)filename;

@end

NS_ASSUME_NONNULL_END
