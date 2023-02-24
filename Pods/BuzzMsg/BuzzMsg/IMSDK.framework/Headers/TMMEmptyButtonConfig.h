//
//  TMMEmptyButtonConfig.h
//  IMSDK
//
//  Created by oceanMAC on 2022/11/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMMEmptyButtonConfig : NSObject

@property (nonatomic, strong) UIColor *backGroudColor;
@property (nonatomic, strong) UIColor *titleTextColor;
@property (nonatomic, strong) UIFont *titleTextFont;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, assign) CGFloat buttonHeight;

@end

NS_ASSUME_NONNULL_END
