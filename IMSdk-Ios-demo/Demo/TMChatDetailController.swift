//
//  TMChatDetailController.swift
//  IMSDK
//
//  Created by Joey on 2022/9/26.
//

import UIKit
import SnapKit
import IMSdk

class TMChatDetailController: UIViewController, ChatDelegate {

    var aChatId = ""

    deinit {
        print("TMChatDetailController - swift 灰飞烟灭")
        }
    
//    private var chatListView: ChatView = ChatView()
    
    private var chatListView: ChatView?

    private lazy var sendView: TMSendMessageFootView = {
        let sendView = TMSendMessageFootView(frame: .zero)
        sendView.sendMessageBtn.addTarget(self, action: #selector(sendMessageClick), for: .touchUpInside)
        sendView.editBtn.addTarget(self, action: #selector(subTitleClick), for: .touchUpInside)
        sendView.textBtn.addTarget(self, action: #selector(selectImageClick), for: .touchUpInside)
        return sendView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.aChatId
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.sendView)
        self.sendView.snp_makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(140)
        }
        
        
        if let loginInfo = TMUserUtil.getLogin() {
            self.chatListView = IMSdk.getInstance(ak: loginInfo.ak, env: .alpha, deviceId: "iOS").creatChatView(aChatId: self.aChatId)
            if let v = self.chatListView {
                v.backgroundColor = .red
                v.setDelegate(delegate: self)
                self.view.addSubview(v)
                v.snp_makeConstraints { make in
                    make.left.top.right.equalToSuperview()
                    make.bottom.equalTo(self.sendView.snp_top)
                }
            }


        }        
    }

    // MARK: -

    @objc private func sendMessageClick() {
        let vc = TMSendMessageViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.aChatId = self.aChatId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func subTitleClick() {
        
        
        let value = Int(arc4random()%47) + 1

        let image = UIImage.init(named: "head_" + String(value))
        
        if let data = image?.pngData() {
//            let userProfile = UserProfile(avatar: data, format: "jpg", name: "小胖子")
//            let model = UserInfoModel(aUid: aUids.first ?? "", profile: userProfile)
//            self.kit?.setUserInfo(userInfos: [model])
            if let loginInfo = TMUserUtil.getLogin() {
                
                let marker1 = ConversationMarker(aChatId: self.aChatId, icon: data, format: "jpg")
                IMSdk.getInstance(ak: loginInfo.ak, env: .alpha, deviceId: "iOS").setConversationMarker(markers: [marker1])
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
//        IMSDKMediaChooseUtil.shared.chooseMedia(viewController: self) { [weak self] (imgdata, format) in
//
//            guard let data: Data = imgdata else {
//                return
//            }
//            guard let self = self else {
//                return
//            }
//
//            if let loginInfo = TMUserUtil.getLogin() {
//
//                let marker1 = ConversationMarker(aChatId: self.aChatId, icon: data, format: format)
//                IMSdk.getInstance(ak: loginInfo.ak, env: .alpha, deviceId: "iOS").setConversationMarker(markers: [marker1])
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
    }
    
    @objc private func selectImageClick() {
        
        let vc: TMInputViewController = TMInputViewController()
        vc.doneBlock = { [weak self] text in
            guard let self = self else {
                return
            }
            
            if let loginInfo = TMUserUtil.getLogin() {
                
                let subTitle = ConversationSubTitle(aChatId: self.aChatId, subTitle: text)
                IMSdk.getInstance(ak: loginInfo.ak, env: .alpha, deviceId: "iOS").setConversationSubTitle(subTitles: [subTitle])
                self.navigationController?.popViewController(animated: true)
            }
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func onFileMessageClick(aMid: String, preView: FilePreView) {
        let vc: TMFilePreController = TMFilePreController()
        vc.preView = preView
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func onCardMessageClick(aMid: String, buttonId: String) {
        if let loginInfo = TMUserUtil.getLogin() {
            IMSdk.getInstance(ak: loginInfo.ak, env: .alpha, deviceId: "iOS").disableCardMessage(aMid: aMid, buttonIds: [buttonId])
        }
    }
    
    func onImageMessageClick(preView: TMImageBrowserView) {
        let vc = TMImageBrowserViewController()
        vc.imageBrowserView = preView
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func onMiddleMessageClick(aMid: String, tmpId: String, buttonId: String) {
        print("当前点击：\(buttonId)")
    }
    
    func getMessageUnReadCount(count: Int) {
        print("当前未读消息数量: \(count)")
    }
    
    func onNoticeMessageClick(aMid: String, buttonId: String) {
        print("当前点击通知消息：\(buttonId)")
    }
    
}
