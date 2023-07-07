//
//  IMCompressPicManager.m
//  asfsdgfsdfhdfghd
//
//  Created by  on 2021/8/4.
//

#import "IMCompressPicManager.h"
#import <AVFoundation/AVFoundation.h>

@implementation IMCompressPicManager

+ (void)compressImageSize:(UIImage *)image toByte:(double)maxLength complationHandle:(void(^)(UIImage *resultImage, BOOL error))completed
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        double compression = 0.00000;
    //    NSData *data = UIImageJPEGRepresentation(image, compression);
        
        NSData *data = UIImagePNGRepresentation(image);

        
        if (data.length < maxLength) {
            completed(image, YES);
            return;
        }
        CGFloat max = 1;
        CGFloat min = 0;
        
        for (int i = 0; i < 6; ++i) {
            compression = (max + min) / 2;

            data = UIImagePNGRepresentation(image);

            if (data.length < maxLength) {
                min = compression;
            } else if (data.length > maxLength) {
                max = compression;
            } else {
                break;
            }
        }
        UIImage *resultImage = [UIImage imageWithData:data];
        if (data.length < maxLength)  {
            completed(resultImage, YES);
            return;
        }

        NSUInteger lastDataLength = 0;
        while (data.length > maxLength && data.length != lastDataLength) {
            lastDataLength = data.length;
            CGFloat ratio = (CGFloat)maxLength / data.length;
            CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                     (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
            UIGraphicsBeginImageContext(size);
            [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            data = UIImageJPEGRepresentation(resultImage, compression);
            resultImage = [UIImage imageWithData:data];
        }
        completed(resultImage, YES);
    });
}


+ (UIImage *)compressImageSize:(UIImage *)image toByte:(double)maxLength{
    double compression = 0.00000;
//    NSData *data = UIImageJPEGRepresentation(image, compression);
    
    NSData *data = UIImagePNGRepresentation(image);

    
    if (data.length < maxLength) return image;
    CGFloat max = 1;
    CGFloat min = 0;
    
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;

        data = UIImagePNGRepresentation(image);

//        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;

    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        resultImage = [UIImage imageWithData:data];

    }
    return resultImage;
}

+ (NSString *)lastPathComponent:(NSString *)filePath
{
    NSString *lastPath = [filePath lastPathComponent];//xx.png
    NSString *fileType = [[filePath lastPathComponent] pathExtension]; //png
    return [lastPath substringToIndex:lastPath.length - 1 - fileType.length];//xxx
}

+ (NSString *)getLastfourComponent:(NSString *)filename
{
    if (filename.length > 4) {
        return [filename substringFromIndex:filename.length - 4];
    }
    return filename;
}

+ (NSString *)getfirstfourComponent:(NSString *)filename {
    if (filename.length > 4) {
        return [filename substringToIndex:filename.length - 4];
    }
    return filename;
}

+ (NSString *)pathExtension:(NSString *)filePath{
    
    return [self getLastComponent:filePath];
}

+ (NSString *)deletingLastPathComponent:(NSString *)filePath
{
    return [filePath stringByDeletingLastPathComponent];
}

+ (BOOL)isPngOrJpg:(NSString *)name
{
    NSArray *arr = @[@"GIF",@"gif"];
    if ([arr containsObject:name]) {
        return NO;
    }
    return YES;
}

+ (NSString *)getLastComponent:(NSString *)filePath {
    NSString *filename = [[NSString alloc] init];
    NSArray *SeparatedArray = [[NSArray alloc] init];
    SeparatedArray = [filePath componentsSeparatedByString:@"."];
    filename = [SeparatedArray lastObject];
    return filename;
}

// get video cover
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generate.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 60);
    CGImageRef oneRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
    UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:oneRef];
  
    return thumbnailImage;
}

+ (void)imageUserToCompressForFilePath:(NSString *)filePath newSize:(CGSize)size complationHandle:(void(^)(UIImage *resultImage))completed
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        UIImage *newImage = [[UIImage alloc] initWithContentsOfFile:filePath];
        CGSize imageSize = newImage.size;//
        CGFloat originalWidth = imageSize.width;//
        CGFloat originalHeight = imageSize.height;//
        if ((originalWidth <= size.width) && (originalHeight <= size.height)) {
            completed(newImage);
        }
        else{
//            TMLog(@"---ratioW")

            CGFloat ratioW = size.width / imageSize.width;
            CGFloat ratioH = size.height / imageSize.height;
    //
            CGSize lastSize = CGSizeMake(0, 0);
            
            if (ratioW > ratioH) {
                lastSize.width = imageSize.width;
                lastSize.height = size.height / ratioW;
            }else if (ratioW == ratioH) {
                lastSize.height = imageSize.height;
                lastSize.width = imageSize.width;
            }else {
                lastSize.height = imageSize.height;
                lastSize.width = size.width / ratioH;
            }

            if (ratioW == ratioH) {
                UIImage *lastImage = [self scaleImage:newImage toScale:size.width/newImage.size.width];
                completed(lastImage);
                return;
            }
            CGImageRef sourceImageRef = [newImage CGImage];//
            CGRect rect1 = CGRectMake((imageSize.width - lastSize.width)/2-1, (imageSize.height - lastSize.height)/2-1, lastSize.width-2, lastSize.height-2);
            CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect1);//
            newImage = [UIImage imageWithCGImage:newImageRef];
            
            
            UIImage *lastImage = [self scaleImage:newImage toScale:size.width/newImage.size.width];

//            UIGraphicsBeginImageContext(lastSize);
//            [newImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
//            UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            TMLog(@"---ratioH")

    //        UIImage *result = [[TZImageManager manager] fixOrientation:newImage];
            completed(lastImage);
        }
        
    });
    

}

+ (void)imageUserToCompressForSizeImage:(UIImage *)sourceImage newSize:(CGSize)size complationHandle:(void(^)(UIImage *resultImage))completed
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{

        UIImage *newImage = nil;
        CGSize imageSize = sourceImage.size;//
        CGFloat originalWidth = imageSize.width;//
        CGFloat originalHeight = imageSize.height;//

        if ((originalWidth <= size.width) && (originalHeight <= size.height)) {
            newImage = sourceImage;//
            completed(newImage);
        }
        else{

            CGFloat ratioW = size.width / imageSize.width;
            CGFloat ratioH = size.height / imageSize.height;
            CGSize lastSize = CGSizeMake(0, 0);
            if (ratioW > ratioH) {
                lastSize.width = imageSize.width;
                lastSize.height = size.height / ratioW;
            }else {
                lastSize.height = imageSize.height;
                lastSize.width = size.width / ratioH;
            }


            CGImageRef sourceImageRef = [sourceImage CGImage];//
            CGRect rect1 = CGRectMake((imageSize.width - lastSize.width)/2, (imageSize.height - lastSize.height)/2, lastSize.width, lastSize.height);
            CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect1);//按照给定的矩形区域进行剪裁
            newImage = [UIImage imageWithCGImage:newImageRef];
            
            [newImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
            UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            completed(lastImage);
        }
    });

}

+ (UIImage *)imageUserToCompressForSizeImage:(UIImage *)image newSize:(CGSize)size{
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = image;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
    return newImage;
}

+ (UIImage*)imageCompressWithSimple:(UIImage*)image scale:(float)scale
{
    CGSize size = image.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIGraphicsBeginImageContext(size); // this will crop
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
//    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize), NO, 2);

    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize + 2, image.size.height * scaleSize + 2)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


@end
