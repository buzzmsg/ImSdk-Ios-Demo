//
//  IMDALabeledCircularProgressView.h
//  DACircularProgressExample
//
//  Created by Josh Sklar on 4/8/14.
//  Copyright (c) 2014 Shout Messenger. All rights reserved.
//

#import "IMDACircularProgressView.h"

/**
 @class IMDALabeledCircularProgressView
 
 @brief Subclass of IMDACircularProgressView that adds a UILabel.
 */
@interface IMDALabeledCircularProgressView : IMDACircularProgressView

/**
 UILabel placed right on the IMDACircularProgressView.
 */
@property (strong, nonatomic) UILabel *progressLabel;

@end
