//
//  IMChatCallCell.h
//  TMM
//
//  Created by    on 2021/8/27.
//  Copyright © 2021 TMM. All rights reserved.
//

#import "IMChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMChatCallCell : IMChatBaseCell

@property (nonatomic,strong) IMMessageInfoModel *model;
@property (nonatomic, copy) void(^tapCallBlock)(IMMessageInfoModel *);

- (void)setupModel:(IMMessageInfoModel *)model;

- (void)layoutUI;

@end

NS_ASSUME_NONNULL_END
