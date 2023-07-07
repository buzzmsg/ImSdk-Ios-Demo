//
//  IMAwsUtil.h
//  CommonModule
//
//  Created by Joey on 2023/2/7.
//

#import <Foundation/Foundation.h>
#import <AWSS3/AWSS3.h>
NS_ASSUME_NONNULL_BEGIN

@interface IMAwsUtil : NSObject
+ (AWSRegionType)aws_regionTypeValue:(NSString *)region;
+ (NSString*)get_ONLYID;
@end

NS_ASSUME_NONNULL_END
