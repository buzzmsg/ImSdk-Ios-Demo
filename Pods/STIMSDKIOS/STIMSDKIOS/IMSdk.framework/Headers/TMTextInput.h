//
//  TMTextInput.h
//  TMText <https://github.com/ibireme/TMText>
//
//  Created by ibireme on 15/4/17.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Text position affinity. For example, the offset appears after the last
 character on a line is backward affinity, before the first character on
 the following line is forward affinity.
 */
typedef NS_ENUM(NSInteger, TMTextAffinity) {
    TMTextAffinityForward  = 0, ///< offset appears before the character
    TMTextAffinityBackward = 1, ///< offset appears after the character
};


/**
 A TMTextPosition object represents a position in a text container; in other words, 
 it is an index into the backing string in a text-displaying view.
 
 TMTextPosition has the same API as Apple's implementation in UITextView/UITextField,
 so you can alse use it to interact with UITextView/UITextField.
 */
@interface TMTextPosition : UITextPosition <NSCopying>

@property (nonatomic, readonly) NSInteger offset;
@property (nonatomic, readonly) TMTextAffinity affinity;

+ (instancetype)positionWithOffset:(NSInteger)offset;
+ (instancetype)positionWithOffset:(NSInteger)offset affinity:(TMTextAffinity) affinity;

- (NSComparisonResult)compare:(id)otherPosition;

@end


/**
 A TMTextRange object represents a range of characters in a text container; in other words, 
 it identifies a starting index and an ending index in string backing a text-displaying view.
 
 TMTextRange has the same API as Apple's implementation in UITextView/UITextField,
 so you can alse use it to interact with UITextView/UITextField.
 */
@interface TMTextRange : UITextRange <NSCopying>

@property (nonatomic, readonly) TMTextPosition *start;
@property (nonatomic, readonly) TMTextPosition *end;
@property (nonatomic, readonly, getter=isEmpty) BOOL empty;

+ (instancetype)rangeWithRange:(NSRange)range;
+ (instancetype)rangeWithRange:(NSRange)range affinity:(TMTextAffinity) affinity;
+ (instancetype)rangeWithStart:(TMTextPosition *)start end:(TMTextPosition *)end;
+ (instancetype)defaultRange; ///< <{0,0} Forward>

- (NSRange)asRange;

@end


/**
 A TMTextSelectionRect object encapsulates information about a selected range of 
 text in a text-displaying view.
 
 TMTextSelectionRect has the same API as Apple's implementation in UITextView/UITextField,
 so you can alse use it to interact with UITextView/UITextField.
 */
@interface TMTextSelectionRect : UITextSelectionRect <NSCopying>

@property (nonatomic, readwrite) CGRect rect;
@property (nonatomic, readwrite) UITextWritingDirection writingDirection;
@property (nonatomic, readwrite) BOOL containsStart;
@property (nonatomic, readwrite) BOOL containsEnd;
@property (nonatomic, readwrite) BOOL isVertical;

@end

NS_ASSUME_NONNULL_END
