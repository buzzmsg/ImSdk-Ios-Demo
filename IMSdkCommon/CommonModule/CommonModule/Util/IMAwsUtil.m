//
//  IMAwsUtil.m
//  CommonModule
//
//  Created by Joey on 2023/2/7.
//

#import "IMAwsUtil.h"

@implementation IMAwsUtil

+ (AWSRegionType)aws_regionTypeValue:(NSString *)region {
    if ([region isEqualToString:@"AWSRegionUSEast1"]
        || [region isEqualToString:@"USEast1"]
        || [region isEqualToString:@"us-east-1"]) {
        return AWSRegionUSEast1;
    }
    if ([region isEqualToString:@"AWSRegionUSEast2"]
        || [region isEqualToString:@"USEast2"]
        || [region isEqualToString:@"us-east-2"]) {
        return AWSRegionUSEast2;
    }
    if ([region isEqualToString:@"AWSRegionUSWest1"]
        || [region isEqualToString:@"USWest1"]
        || [region isEqualToString:@"us-west-1"]) {
        return AWSRegionUSWest1;
    }
    if ([region isEqualToString:@"AWSRegionUSWest2"]
        || [region isEqualToString:@"USWest2"]
        || [region isEqualToString:@"us-west-2"]) {
        return AWSRegionUSWest2;
    }
    if ([region isEqualToString:@"AWSRegionEUWest1"]
        || [region isEqualToString:@"EUWest1"]
        || [region isEqualToString:@"eu-west-1"]) {
        return AWSRegionEUWest1;
    }
    if ([region isEqualToString:@"AWSRegionEUWest2"]
        || [region isEqualToString:@"EUWest2"]
        || [region isEqualToString:@"eu-west-2"]) {
        return AWSRegionEUWest2;
    }
    if ([region isEqualToString:@"AWSRegionEUCentral1"]
        || [region isEqualToString:@"EUCentral1"]
        || [region isEqualToString:@"eu-central-1"]) {
        return AWSRegionEUCentral1;
    }
    if ([region isEqualToString:@"AWSRegionAPNortheast1"]
        || [region isEqualToString:@"APNortheast1"]
        || [region isEqualToString:@"ap-northeast-1"]) {
        return AWSRegionAPNortheast1;
    }
    if ([region isEqualToString:@"AWSRegionAPNortheast2"]
        || [region isEqualToString:@"APNortheast2"]
        || [region isEqualToString:@"ap-northeast-2"]) {
        return AWSRegionAPNortheast2;
    }
    if ([region isEqualToString:@"AWSRegionAPSoutheast1"]
        || [region isEqualToString:@"APSoutheast1"]
        || [region isEqualToString:@"ap-southeast-1"]) {
        return AWSRegionAPSoutheast1;
    }
    if ([region isEqualToString:@"AWSRegionAPSoutheast2"]
        || [region isEqualToString:@"APSoutheast2"]
        || [region isEqualToString:@"ap-southeast-2"]) {
        return AWSRegionAPSoutheast2;
    }
    if ([region isEqualToString:@"AWSRegionAPSouth1"]
        || [region isEqualToString:@"APSouth1"]
        || [region isEqualToString:@"ap-south-1"]) {
        return AWSRegionAPSouth1;
    }
    if ([region isEqualToString:@"AWSRegionSAEast1"]
        || [region isEqualToString:@"SAEast1"]
        || [region isEqualToString:@"sa-east-1"]) {
        return AWSRegionSAEast1;
    }
    if ([region isEqualToString:@"AWSRegionCACentral1"]
        || [region isEqualToString:@"CACentral1"]
        || [region isEqualToString:@"ca-central-1"]) {
        return AWSRegionCACentral1;
    }
    if ([region isEqualToString:@"AWSRegionUSGovWest1"]
        || [region isEqualToString:@"USGovWest1"]
        || [region isEqualToString:@"us-gov-west-1"]) {
        return AWSRegionUSGovWest1;
    }

    if ([region isEqualToString:@"AWSRegionCNNorth1"]
        || [region isEqualToString:@"CNNorth1"]
        || [region isEqualToString:@"cn-north-1"]) {
        return AWSRegionCNNorth1;
    }
    
    if ([region isEqualToString:@"AWSRegionCNNorthWest1"]
        || [region isEqualToString:@"CNNorthWest1"]
        || [region isEqualToString:@"cn-northwest-1"]) {
        return AWSRegionCNNorthWest1;
    }
    
    if ([region isEqualToString:@"AWSRegionEUWest3"]
        || [region isEqualToString:@"EUWest3"]
        || [region isEqualToString:@"eu-west-3"]) {
        return AWSRegionEUWest3;
    }
    
    if ([region isEqualToString:@"AWSRegionUSGovEast1"]
        || [region isEqualToString:@"USGovEast1"]
        || [region isEqualToString:@"us-gov-east-1"]) {
        return AWSRegionUSGovEast1;
    }
    
    if ([region isEqualToString:@"AWSRegionEUNorth1"]
        || [region isEqualToString:@"EUNorth1"]
        || [region isEqualToString:@"eu-north-1"]) {
        return AWSRegionEUNorth1;
    }

    if ([region isEqualToString:@"AWSRegionAPEast1"]
        || [region isEqualToString:@"APEast1"]
        || [region isEqualToString:@"ap-east-1"]) {
        return AWSRegionAPEast1;
    }
    
    if ([region isEqualToString:@"AWSRegionMESouth1"]
        || [region isEqualToString:@"MESouth1"]
        || [region isEqualToString:@"me-south-1"]) {
        return AWSRegionMESouth1;
    }

    if ([region isEqualToString:@"AWSRegionAFSouth1"]
        || [region isEqualToString:@"AFSouth1"]
        || [region isEqualToString:@"af-south-1"]) {
        return AWSRegionAFSouth1;
    }

    if ([region isEqualToString:@"AWSRegionEUSouth1"]
        || [region isEqualToString:@"EUSouth1"]
        || [region isEqualToString:@"eu-south-1"]) {
        return AWSRegionEUSouth1;
    }

    return AWSRegionUnknown;
}

+ (NSString*)get_ONLYID{

    CFUUIDRef uuidRef =CFUUIDCreate(NULL);

    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);

    NSString *uniqueId = (__bridge_transfer NSString *)(uuidStringRef);

    return uniqueId;

}

@end
