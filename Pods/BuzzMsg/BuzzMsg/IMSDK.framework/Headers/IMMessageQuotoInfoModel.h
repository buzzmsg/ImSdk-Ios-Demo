//
//  IMMessageQuotoInfoModel.h
//  TMM
//
//  Created by tmmtmm on 2020/8/3.
//  Copyright © 2020 TMM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMSDKMessageAttachmentModel.h"
#import "IMChatTextLayout.h"

NS_ASSUME_NONNULL_BEGIN

@class IMMessageInfoModel;
@interface IMMessageQuotoInfoModel : NSObject

@property (nonatomic,assign) int type;            //
@property (nonatomic,copy) NSString *name;        // name
@property (nonatomic,copy) NSString *messageBody; //
@property (nonatomic,copy) NSString * json;       //
@property (nonatomic,copy) NSString * sender;
@property (nonatomic,assign) NSInteger contentType;            //
@property (nonatomic,copy) NSString * msgContent;       //
@property (nonatomic, strong) NSAttributedString *attachTextStr;
@property (nonatomic,copy) NSString * nickName;       //
//@property (nonatomic,copy) NSString * imageOriginPath;       //
//@property (nonatomic,copy) NSString * imageNormalPath;       //
//@property (nonatomic,copy) NSString * videoPath;       //
@property (nonatomic,copy) NSString * mid;       //
@property (nonatomic,copy) NSString * chatId;       //
@property (nonatomic,copy) NSString * uuid;       //
@property (nonatomic,assign) CGSize quotoSize;            //
@property (nonatomic,assign) CGSize contentSize;            //
@property (nonatomic,assign) CGFloat nikenameWidth;            //
@property (nonatomic,copy) NSString * quotoName;       //

@property (nonatomic, strong) IMChatTextLayout *layout;
@property (nonatomic, strong) IMSDKMessageAttachmentModel *attachment;   //attachment content
@property (nonatomic, strong) TMMMessageLoactionModel *loactonModel;   //location content
@property (nonatomic, assign) long _id;
@property (nonatomic, strong) IMMessageInfoModel *quotoMsgModel;   //


@end
                     
NS_ASSUME_NONNULL_END
