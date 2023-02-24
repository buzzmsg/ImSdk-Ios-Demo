//
//  IMDefine+TM_API_Path.h
//  TMM
//
//  Created by  on 2019/11/19.
//  Copyright © 2019 TMM. All rights reserved.
//


#import "IMDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMDefine (TM_API_Path)

/// refresh Token
+ (NSString *)refresnTokenAPI;

/// get app configuration
+ (NSString *)appConfigAPI;

/// get verification code
+ (NSString *)getVerifyCode;

/// Verify that the verification code is correct
+ (NSString *)captchaValidCode;

/// Report
+ (NSString *)reportUserAPI;

/// log in
+ (NSString *)loginAPI;

/// Perfect user information after login
+ (NSString *)improveUserInfoAfterLoginAPI;

/// Get my personal information
+ (NSString *)getMyPersonalInfoAPI;

/// Get user information 【Discarded When V2.0.81】
+ (NSString *)getUserInfoAPI;

/// Get user information 【V2.0.81】
+ (NSString *)getUserInfoAPI_V_2_0_81;

/// Get account information
+ (NSString *)getAccountInfoAPI;

/// Precise search (tmm_id, mobile phone number)
+ (NSString *)contactsUserSearchAPI;

/// friend application list
+ (NSString *)contactsApplyListAPI;

/// friend application (blacklist to restore friend relationship)
+ (NSString *)contactsApplyAPI;

/// agree with friend application
+ (NSString *)contactsApplyAgreeAPI;

/// Friends List
+ (NSString *)contactsUserAPI;

/// Send one-on-one red envelope
+ (NSString *)envelopeSendOneToOneAPI;

/// Send group red packet
+ (NSString *)envelopeSendGroupAPI;

/// Grab red envelopes (red envelope details)
+ (NSString *)envelopeDetailAPI;

/// Remove the red envelope
+ (NSString *)envelopeOpenAPI;

/// Red envelope collection list
+ (NSString *)envelopeOpenUsersListAPI;

///translation
+ (NSString *)translateAPI;

///translateSpeech
+ (NSString *)translateSpeechAPI;

+ (NSString *)uploadPreSignedLinkAPI;

+ (NSString *)uploadFilesAPI;

#pragma mark Moments
/// post moments
+ (NSString *)postMomentsAPI;

/// Dynamic list, compatible with search
+ (NSString *)momentsListAPI;

/// moments detail
+ (NSString *)momentsDetailAPI;

/// Dynamic Like List
+ (NSString *)momentsLikeListAPI;

/// Dynamic comment list
+ (NSString *)momentsCommentListAPI;

/// Dynamic comments like
+ (NSString *)momentsCommentListApproveAPI;

/// Dynamic likes
+ (NSString *)momentsApproveAPI;

/// Dynamic collection
+ (NSString *)momentsCollectionAPI;

/// Dynamic comments
+ (NSString *)momentsCommentAPI;

/// Dynamic reply
+ (NSString *)momentsReplyAPI;

/// Dynamic forwarding list
+ (NSString *)momentsTransferListAPI;

/// Dynamic forwarding
+ (NSString *)momentsTransferAPI;

/// My Moments
+ (NSString *)myMomentsAPI;

/// Moments notification
+ (NSString *)momentsNotificationAPI;

/// Moments notification list
+ (NSString *)momentsNotificationListAPI;

/// Moments clear notification list
+ (NSString *)momentsNotificationListClearAPI;

/// moments comments detail
+ (NSString *)momentsCommentDetailAPI;

/// Reply list of comments
+ (NSString *)momentsCommentReplyListAPI;

/// Reply to like
+ (NSString *)momentsCommentReplyApproveAPI;

/// Moments deleted
+ (NSString *)momentsDeleteAPI;

/// Moments report
+ (NSString *)momentsReportAPI;



#pragma mark Red envelope, pay

/// Get copy configuration
+ (NSString *)getCopywritingAPI;

/// Get red envelope statistics
+ (NSString *)envelopeStatInfoAPI;

/// Get the list of red envelopes received
+ (NSString *)envelopeInListAPI;

/// Get the list of issued red envelopes
+ (NSString *)envelopeOutListAPI;

/// Initiate a transfer
+ (NSString *)transferOutAPI;

/// Payment transfer
+ (NSString *)transferPayAPI;

/// Get transfer details
+ (NSString *)transferChatDetailAPI;

/// Transfer payment
+ (NSString *)transferReceiveAPI;

/// Initiate scan code transfer
+ (NSString *)transOutAPI;

/// Payment scan code transfer
+ (NSString *)transPayOutAPI;

/// Get the scan code transfer receipt list
+ (NSString *)transPayOutListAPI;



#pragma mark User details of others

/// Friends default page
+ (NSString *)contactsFriendGetInfoAPI;

/// Get user details of others
+ (NSString *)contactsGetOtherInfoAPI;

/// Topic list
+ (NSString *)topicsListAPI;

/// Set friend information
+ (NSString *)contactsFriendSetAPI;

/// Get user tags
+ (NSString *)contactsUserGetTagAPI;

/// Add user tag
+ (NSString *)contactsUserAddTagAPI;

/// Add blacklist
+ (NSString *)contactsUserAddBlackAPI;

/// Remove blacklist
+ (NSString *)contactsUserDeleteBlackAPI;

/// Blacklist
+ (NSString *)contactsUserGetBlackAPI;

/// Whether it was blacked by the other party
+ (NSString *)contactsUserIsBeBlockAPI;

/// delete friend
+ (NSString *)contactsFriendDeleteAPI;

/// Get users registered in the platform through the address book
+ (NSString *)contactsInviteAPI;

/// Create a group
+ (NSString *)contactsCreateGroupAPI;

#pragma mark - Discover
/// Discover list of outermost categories
+ (NSString *)discoverCategoryListAPI;

/// Nearby filter attribute list
+ (NSString *)nearbyFilterPropertyLsitAPI;

/// Whether the data in Discover has been set
+ (NSString *)isSetProfileInDiscoverAPI;

/// Profile in Discover
+ (NSString *)myProfileInDiscoverAPI;

/// Save Discover's personal information
+ (NSString *)saveDiscoverProfileAPI;

/// List of people nearby
+ (NSString *)nearbyPeopleListAPI;

/// shake
+ (NSString *)shakeAPI;

/// shake history
+ (NSString *)shakeHistoryAPI;

/// clear shake history
+ (NSString *)clearShakeHistoryAPI;

/// nearby business list
+ (NSString *)nearbyBusinessListAPI;

/// clear location
+ (NSString *)discoverClearLocationAPI;

/// business detail
+ (NSString *)businessDetailInfoAPI;

/// business detail comment list
+ (NSString *)businessDetailCommentListAPI;

/// business detail comment list approve
+ (NSString *)businessDetailCommentLikeAPI;

/// comment business
+ (NSString *)businessCommentAPI;

/// ..
+ (NSString *)getfMListAPI;

/// get Discover partner api
+ (NSString *)getDicsoverPartnerAPI;

#pragma mark Me
/// Payment information
+ (NSString *)receiveMoneyInfoAPI;

/// Update user information
+ (NSString *)updateUserInfoAPI;

/// My Albums List
+ (NSString *)myAlbumsListAPI;

/// Initiated payment list
+ (NSString *)myInitiatedReceiveMoneyListAPI;

/// List of payments received
+ (NSString *)myPaiedReceiveMoneyListAPI;

/// Generate a payment code based on the amount
+ (NSString *)generateReceiveMoneyQrCodeAPI;

///Set up payment password
+ (NSString *)userSetPayPwdAPI;

/// Modify payment password
+ (NSString *)userChangePayPwdAPI;

///Retrieve payment password
+ (NSString *)userResetPayPwdAPI;

/// Verify that the payment password is correct
+ (NSString *)userValidPayPwdAPI;

/// Wallet billing list
+ (NSString *)walletBillListAPI;

/// Statistics of wallet bill list
+ (NSString *)walletBillListStatisticsDataAPI;

/// balance list
+ (NSString *)balanceBillListAPI;

/// Wallet billing details
+ (NSString *)walletBillDetailAPI;

/// Apply for withdrawal
+ (NSString *)walletWithdrawAPI;

/// Get cost information
+ (NSString *)withdrawFeeAPI;

/// initiate recharge
+ (NSString *)walletRechargeAPI;

/// Check recharge details
+ (NSString *)walletRechargeDetailAPI;

/// Receive Money unread historical message count
+ (NSString *)receiveMoneyUnreadHistoryCountAPI;

#pragma mark Card

/// Get bank card list
+ (NSString *)getBankCardListAPI;

/// Get bank card details
+ (NSString *)getBankCardDetailAPI;

/// Add bank card
+ (NSString *)addBankCardAPI;

/// Unlock the bank card
+ (NSString *)deleteBankCardAPI;

/// Verify that the bank card is correct
+ (NSString *)validBankCardAPI;

// Transfer to bank card
+ (NSString *)transTobankAPI;


#pragma mark Public
/// File Upload
+ (NSString *)fileUploadAPI;

/// List of all countries
+ (NSString *)allCountryListAPI;

/// Get the list of regions
+ (NSString *)getRegionListAPI;


/// uploadUnreadNum
+ (NSString *)uploadUnreadNumAPI;

/// pushToken
+ (NSString *)uploadPushTokenAPI;





/// Initiate group collection
+ (NSString *)createRecmoneyAPI;

/// Stop group collection
+ (NSString *)stopRecmoneyAPI;

/// Get group collection details
+ (NSString *)getRecmoneyDetailAPI;

/// Pay the group collection initiated by others
+ (NSString *)recmoneyPayAPI;

/// Acquire group basic information based on group id
+ (NSString *)contactsGroupGetInfoAPI;

/// Group settings
+ (NSString *)contactsGroupSetAPI;

/// into the group
+ (NSString *)contactsGroupEnterAPI;

/// Quit the group (kick people)
+ (NSString *)contactsGroupAbortAPI;


/// Disband Group
+ (NSString *)groupDisbandAPI;

/// Disband Group V 2.0.110
+ (NSString *)groupDismissAPI;

/// Get group list
+ (NSString *)contactsGetGroupListAPI;

/// Get friends who don't see him (not let him see) in the circle of friends
+ (NSString *)userGetHideCommentListAPI;

/// Change the dynamic permissions of multiple people
+ (NSString *)userSetHideCommentListAPI;

/// Personal center access settings
+ (NSString *)userGetConfAPI;

/// Personal center setting page switch
+ (NSString *)userSetConfAPI;

/// Get the configuration for viewing moments period
+ (NSString *)userDurationAPI;


#pragma mark - Map
+ (NSString *)dynamicMapAPI;
+ (NSString *)googleMapAPI;
+ (NSString *)gaoDeMapAPI;
+ (NSString *)mapSnapshotAPIWithLa:(NSString *)la lo:(NSString *)lo zoom:(NSString *)zoom;


#pragma mark - Coin
/// My coin type
+ (NSString *)myCoinListAPI;

/// My coin details
+ (NSString *)myCoinDetailInfoAPI;

/// List of platform currency types
+ (NSString *)allCoinListAPI;

+ (NSString *)coinTransactionsinfoAPI;

/// Add a list of currency types
+ (NSString *)addCoinAPI;

/// Withdrawal currency
+ (NSString *)coinWithdrawAPI;

/// Transaction records of coins
+ (NSString *)coinTransactionAPI;

/// Coin Adress List API
+ (NSString *)coinAdressListAPI;

/// Coin Service Fee
+ (NSString *)getCoinServiceFeeAPI;

/// currency list
+ (NSString *)getCurrencyListAPI;

/// Add Coin Adress
+ (NSString *)addCoinAdressAPI;

///
+ (NSString *)deepLinkQueryCoinWithdrawInfoAPI;
+ (NSString *)deepLinkCoinWithdrawAPI;


/// Coin Other Adress List API
+ (NSString *)coinOtherListAPI;

+ (NSString *)coinScanAPI;

#pragma mark coin  Red envelope, pay

+ (NSString *)coinEnvelopeSendOneToOneAPI;

+ (NSString *)coinEnvelopeSendGroupAPI;

+ (NSString *)coinEnvelopeDetailAPI;

+ (NSString *)coinEnvelopeOpenAPI;

+ (NSString *)coinEnvelopeListAPI;

+ (NSString *)coinEnvelopeInListAPI;

+ (NSString *)coinEnvelopeOutListAPI;

+ (NSString *)coinEnvelopeStatInfoAPI;





+ (NSString *)versionUpdateAPI;


+ (NSString *)userconfigLanguage;

+ (NSString *)pcLoginAPI;

+ (NSString *)miniProgramsListAPI;
+ (NSString *)myMiniProgramsListAPI;
+ (NSString *)myMiniProgramsListWithoutLaypageAPI;
+ (NSString *)addToMyMiniProgramsAPI;
+ (NSString *)cancelAddToMyMiniProgramsAPI;
+ (NSString *)cancelAddToMyMiniProgramsAPI2;

+ (NSString *)momentsNotInterestedAPI;

+ (NSString *)miniProgramsGetCodeAPI;
+ (NSString *)miniProgramsAuthorizeInfoAPI;
+ (NSString *)miniProgramsCheckSessionAPI;


+ (NSString *)payVerifyPwdAPI;

+ (NSString *)updateDeviceInfoAPI;

+ (NSString *)dirtyConversationListAPI;

+ (NSString *)contactsGroupDisableSendMsgAPI;

+ (NSString *)appletDetailAPI;

+ (NSString *)miniProgramsBannerAPI;

+ (NSString *)recentUsedMiniprogramAPI;

+ (NSString *)miniProgramsCategoryAPI;

+ (NSString *)miniProgramsCategoryAPI_V_2_0_81;

+ (NSString *)miniProgramsRankAPI;

+ (NSString *)contactsUserSearchAPI_V_2_0_80;

+ (NSString *)getOfficialAccountListAPI;

+ (NSString *)getOfficialAccountInfoAPI;

+ (NSString *)searchBizCustomerAppAPI;

+ (NSString *)getOfficialAccountMessageListAPI;

+ (NSString *)removeOfficialAccountAPI;

+ (NSString *)followOfficialAccountAPI;

+ (NSString *)discoveryCitysAPI;

+ (NSString *)discoveryCategoryListByPidAPI;

+ (NSString *)discoveryCityByLocation;

+ (NSString *)contactsChannelV2;

+ (NSString *)contactsInviteReadAPI;

//group voice call service
//+ (NSString *)noticeCreateVoiceCallAChannelAPI;
//
//+ (NSString *)noticaJoinVoiceCallChannelAPI;
//
//+ (NSString *)noticaLeaveVoiceCallChannelAPI;
//
//+ (NSString *)noticaCloseVoiceCallChannelAPI;
//
//+ (NSString *)getGroupVoiceCallChannelAndMembersAPI;

@end

NS_ASSUME_NONNULL_END
