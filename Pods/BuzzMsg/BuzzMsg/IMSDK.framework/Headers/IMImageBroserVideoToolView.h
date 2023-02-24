//
//  IMImageBroserVideoToolView.h
//  TMM
//
//  Created by    on 2022/1/18.
//  Copyright © 2022 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMCLGCDTimerManager.h"
#import "IMCLSlider.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMImageBroserVideoToolView : UIView

@property (nonatomic, strong) UIButton *playBtn;


- (void) changeStatu:(AVPlayer *)player playerItem:(AVPlayerItem *)playerItem;

/*进度条定时器*/
@property (nonatomic, strong) TMCLGCDTimer       *sliderTimer;
/*点击定时器*/
@property (nonatomic, strong) TMCLGCDTimer       *tapTimer;
@property (nonatomic,strong) IMCLSlider *slider;

-(void)cl_progressSliderValueChanged:(AVPlayer *)player playerItem:(AVPlayerItem *)playerItem dragedSeconds:(CGFloat)dragedSeconds;



@end

NS_ASSUME_NONNULL_END
