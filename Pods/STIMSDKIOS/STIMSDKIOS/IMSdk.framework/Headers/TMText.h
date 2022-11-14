//
//  TMText.h
//  TMText <https://github.com/ibireme/TMText>
//
//  Created by ibireme on 15/2/25.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<TMText/TMText.h>)
FOUNDATION_EXPORT double TMTextVersionNumber;
FOUNDATION_EXPORT const unsigned char TMTextVersionString[];
#import <TMText/TMLabel.h>
#import <TMText/TMTextView.h>
#import <TMText/TMTextAttribute.h>
#import <TMText/TMTextArchiver.h>
#import <TMText/TMTextParser.h>
#import <TMText/TMTextRunDelegate.h>
#import <TMText/TMTextRubyAnnotation.h>
#import <TMText/TMTextLayout.h>
#import <TMText/TMTextLine.h>
#import <TMText/TMTextInput.h>
#import <TMText/TMTextDebugOption.h>
#import <TMText/TMTextKeyboardManager.h>
#import <TMText/TMTextUtilities.h>
#import <TMText/NSAttributedString+TMText.h>
#import <TMText/NSParagraphStyle+TMText.h>
#import <TMText/UIPasteboard+TMText.h>
#else
#import "TMLabel.h"
#import "TMTextView.h"
#import "TMTextAttribute.h"
#import "TMTextArchiver.h"
#import "TMTextParser.h"
#import "TMTextRunDelegate.h"
#import "TMTextRubyAnnotation.h"
#import "TMTextLayout.h"
#import "TMTextLine.h"
#import "TMTextInput.h"
#import "TMTextDebugOption.h"
#import "TMTextKeyboardManager.h"
#import "TMTextUtilities.h"
#import "NSAttributedString+TMText.h"
#import "NSParagraphStyle+TMText.h"
#import "UIPasteboard+TMText.h"
#endif
