//
//  TMChatCellConst.h
//  TMM
//
//  Created by Rain on 2021/1/22.
//  Copyright © 2021 TMM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN const float TMChatCellConstAvatarWidth;     // Header image width / height
UIKIT_EXTERN const float TMChatCellConstAvatarSideSpace; // Header image side space
UIKIT_EXTERN const float TMChatCellConstCheckBoxWidth;   // Check box width and height

UIKIT_EXTERN const int TMChatCellConstRecalInMinutes;     // x minutes can recall message;
UIKIT_EXTERN const int TMChatCellConstRecalInSeconds;     // x seconds can recall message;


//card cell
UIKIT_EXTERN const int TMChatCardCellConstLeftSapce;     //
UIKIT_EXTERN const int TMChatCardCellConstAvatarWidth;     //
UIKIT_EXTERN const int TMChatCardCellConstAvatarTopSapce;     //
UIKIT_EXTERN const int TMChatCardCellConstAvatarLeftSpace;     //
UIKIT_EXTERN const int TMChatCardCellConstTextLeftSpace;     //
UIKIT_EXTERN const int TMChatCardCellConstTextRightSpace;     //
UIKIT_EXTERN const int TMChatCardCellConstTextBottomSpace;     //
UIKIT_EXTERN const int TMChatCardCellConstButtonHeight;     //
UIKIT_EXTERN const int TMChatCardCellConstTimeHeight;     //

//#define TMChatCellTextMaxWidth (YH__ScreenWidth - TMChatCellConstAvatarSideSpace*2 - TMChatCellConstAvatarWidth*2 - 12*2)
//#define TMChatCellTextMaxWidth 274


NS_ASSUME_NONNULL_BEGIN

@interface TMChatCellConst : NSObject

@end

NS_ASSUME_NONNULL_END
