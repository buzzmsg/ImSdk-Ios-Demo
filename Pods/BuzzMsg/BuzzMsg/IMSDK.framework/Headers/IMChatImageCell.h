//
//  IMChatImageCell.h
//  TMM
//
//  Created by tmm on 2019/11/11.
//  Copyright © 2019 TMM. All rights reserved.
//

#import "IMChatBaseCell.h"
#import "IMCircleProgressView.h"
#import "IMCallHeadImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMChatImageCell : IMChatBaseCell

@property (nonatomic, strong) IMCallHeadImageView *thumImageView; //ThumImageView

@end

NS_ASSUME_NONNULL_END
