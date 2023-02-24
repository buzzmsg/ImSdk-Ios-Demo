//
//  MKAnnotationView+TMWebImage.h
//  TMWebImage <https://github.com/ibireme/TMWebImage>
//
//  Created by ibireme on 15/2/23.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#if __has_include(<TMWebImage/TMWebImage.h>)
#import <TMWebImage/IMWebImageManager.h>
#else
#import "IMWebImageManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 Web image methods for MKAnnotationView.
 */
@interface MKAnnotationView (TMWebImage)

/**
 Current image URL.
 
 @discussion Set a new value to this property will cancel the previous request
 operation and create a new request operation to fetch image. Set nil to clear
 the image and image URL.
 */
@property (nullable, nonatomic, strong) NSURL *tm_imageURL;

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder The image to be set initially, until the image request finishes.
 */
- (void)tm_setImageWithURL:(nullable NSURL *)imageURL placeholder:(nullable UIImage *)placeholder;

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL The image url (remote or local file path).
 @param options  The options to use when request the image.
 */
- (void)tm_setImageWithURL:(nullable NSURL *)imageURL options:(TMWebImageOptions)options;

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)tm_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(TMWebImageOptions)options
                completion:(nullable TMWebImageCompletionBlock)completion;

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param progress    The block invoked (on main thread) during image request.
 @param transform   The block invoked (on background thread) to do additional image process.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)tm_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(TMWebImageOptions)options
                  progress:(nullable TMWebImageProgressBlock)progress
                 transform:(nullable TMWebImageTransformBlock)transform
                completion:(nullable TMWebImageCompletionBlock)completion;

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder he image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param manager     The manager to create image request operation.
 @param progress    The block invoked (on main thread) during image request.
 @param transform   The block invoked (on background thread) to do additional image process.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)tm_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(TMWebImageOptions)options
                   manager:(nullable IMWebImageManager *)manager
                  progress:(nullable TMWebImageProgressBlock)progress
                 transform:(nullable TMWebImageTransformBlock)transform
                completion:(nullable TMWebImageCompletionBlock)completion;

/**
 Cancel the current image request.
 */
- (void)tm_cancelCurrentImageRequest;

@end

NS_ASSUME_NONNULL_END
