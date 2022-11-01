//
//  TMMessageQuotoModel.h
//  TMM
//
//  Created by tmmtmm on 2020/8/3.
//  Copyright © 2020 TMM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMMessageAttachmentModel.h"
#import "TMChatTextLayout.h"

NS_ASSUME_NONNULL_BEGIN

@class TMMessageModel;
@interface TMMessageQuotoModel : NSObject

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
@property (nonatomic, strong) TMChatTextLayout *layout;
@property (nonatomic, strong) TMMessageAttachmentModel *attachment;   //attachment content
@property (nonatomic, strong) TMMessageLoactionModel *loactonModel;   //location content
@property (nonatomic, assign) long _id;
@property (nonatomic, strong) TMMessageModel *quotoMsgModel;   //


@end
                     
NS_ASSUME_NONNULL_END
