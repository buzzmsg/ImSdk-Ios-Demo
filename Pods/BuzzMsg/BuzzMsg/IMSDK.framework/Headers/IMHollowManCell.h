//
//  IMHollowManCell.h
//  TMM
//
//  Created by  on 2021/8/10.
//  Copyright © 2021 TMM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class IMMessageInfoModel;
@class IMHollowManCell;
@protocol TMMHollowManCellDelegate <NSObject>

@optional
- (void)cell:(IMHollowManCell *)cell tempId:(NSString *)tempId clickText:(NSString *)textId;

@end

@interface IMHollowManCell : UITableViewCell

@property (nonatomic,strong) IMMessageInfoModel *model;
@property (nonatomic, weak) id<TMMHollowManCellDelegate> delegate;

- (void)setupModel:(IMMessageInfoModel *)model;
- (void)setUnknowText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
