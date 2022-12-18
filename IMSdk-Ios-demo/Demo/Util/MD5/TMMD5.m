//
//  TMMD5.m
//  TMM
//
//  Created by apple on 2019/11/15.
//  Copyright © 2019 TMM. All rights reserved.
//

#import "TMMD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation TMMD5

+ (NSString *)MD5:(NSString *)string{
    const char *concat_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, (unsigned int)strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for( int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return hash;
}

+ (NSString *)HashNumber:(NSString *)string {
//    const char *chars = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int sum = 0;
    for (int i = 0; i < string.length; i++) {
        int asciiCode = [string characterAtIndex:i];
        sum = sum * 31 + asciiCode;
    }
    sum = sum & 2147483647;
    return [NSString stringWithFormat:@"%d",sum];
}

@end
