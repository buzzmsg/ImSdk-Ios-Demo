//
//  HollowManCell.h
//  TMM
//
//  Created by  on 2021/8/10.
//  Copyright © 2021 TMM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TMMessageModel;
@class HollowManCell;
@protocol HollowManCellDelegate <NSObject>

@optional
- (void)cell:(HollowManCell *)cell tempId:(NSString *)tempId clickText:(NSString *)textId;

@end

@interface HollowManCell : UITableViewCell

@property (nonatomic,strong) TMMessageModel *model;
@property (nonatomic, weak) id<HollowManCellDelegate> delegate;

- (void)setupModel:(TMMessageModel *)model;
- (void)setUnknowText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
