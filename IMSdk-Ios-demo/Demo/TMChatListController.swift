//
//  TMChatListController.swift
//  IMSDK
//
//  Created by Joey on 2022/9/26.
//

import UIKit
import SVProgressHUD
import IMSDK


class TMChatListController: UIViewController, IMDelegate, IMConversationDelegate, IMConversionSelector {
    func onShowConversationInfo(aChatIds: [String]) {
        
    }
    
    
    
    func onUnReadCountChange(count: Int) {
        print("当前未读数\(count)")
    }

    var loginInfo: TMDemoLoginResponse? {
        return TMUserUtil.shared.loginInfo
    }
    var imSdk: IMSdk? {
        return TMUserUtil.shared.imSdk
    }
    var conversionViewModel: IMConversationViewModel?
    private var chatView: IMConversationView?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "聊天"

        let btn1=UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        btn1.setTitle("发消息", for: .normal)
        let item2=UIBarButtonItem(customView: btn1)
        self.navigationItem.rightBarButtonItem = item2
        
        
        
        if var imSdk = self.imSdk, let loginInfo = loginInfo {

            self.title = loginInfo.phone

            imSdk.setIMDelegate(delegate: self)
            
            imSdk.setAuthCode(auth: loginInfo.authcode)
            imSdk.initUser(aUid: loginInfo.auid)
            imSdk.setLanguage(language: IMLanguageType.Indonesia)
            
            self.conversionViewModel = imSdk.createConversationViewModel(selector: IMChatViewModelFactory.ofAll())
//            self.conversionViewModel = imSdk.createConversationViewModel(selector: IMChatViewModelFactory.ofPart(ids: ["14714710_14714711"]))
//            self.conversionViewModel = imSdk.createConversationViewModel(selector: IMChatViewModelFactory.ofUnPart(ids: ["147100_1471000"]))

            self.conversionViewModel?.setDelegate(delegate: self)
            
//            let value = Int(arc4random()%47) + 1
//            let image = UIImage.init(named: "head_" + String(value))
//            if let data = image?.pngData() {
//                // auid = 04c82e2f89f20837
//                let userInfo = IMUserInfoModel(aUid: loginInfo.auid, profile: UserProfile(avatar: IMAvatar(data: data, format: "png"), name1: "testUser", name3: ""))
//                imSdk.setUserInfo(userInfos: [userInfo])
//            }

            if let viewModel = self.conversionViewModel {
                viewModel.setDelegate(delegate: self)

                viewModel.setSort(sortCalsure: { t1, t2 in
                    if (t1.topTimeStamp != t2.topTimeStamp) {
                        return t1.topTimeStamp > t2.topTimeStamp
                    }
                    return t1.timeStamp > t2.timeStamp
                })
                self.chatView = viewModel.getConversionView()
                if let chatView = self.chatView {
                    chatView.setDelegate(delegate: self)
                    self.view.addSubview(chatView)
                }
            }
        }98

    }
    
    func authCodeExpire(aUid: String, errorCode: IMSDK.IMSdkError) {
        print("登录失败来了, errorCode: \(errorCode)")

        if let loginInfo = loginInfo {
            TMDemoGetAuth.execute(token: loginInfo.token).then { authRespon -> Promise<Void> in
                self.imSdk?.setAuthCode(auth: authRespon.authcode)
                return Promise<Void>.resolve()
            }

        }
    }
    
    func onShowUserInfo(datas: [IMShowUserInfo]) {
        
        let value = Int(arc4random()%47) + 1
        let image = UIImage.init(named: "head_" + String(value))
        
        if let data = image?.pngData() {
            let userProfile = IMUserInfoItem(avatar: IMAvatar(data: data, format: "jpg"), name1: "小胖子", name3: "")
            if let aUid = datas.first?.aUid {
                let model = IMUserinfo(aUid: aUid, profile: userProfile)
                self.imSdk?.setUserInfo(userInfos: [model])
            }
        }
    }
    
    func onShowConversationSubTitle(aChatIds: [String]) {
        print("会话子标题回调")
//        let value = Int(arc4random()%47) + 1
//
//        let image = UIImage.init(named: "head_" + String(value))
//
//        if let data = image?.pngData() {
//            //let marker1 = ConversationMarker(aChatId: "1471471479_18522221111", icon: data, format: "jpg")
//            let subTitle = ConversationSubTitle(aChatId: "1471471479_18522221111", subTitle: "开发工程师")
//            self.kit?.setConversationSubTitle(subTitles: [subTitle])
//        }
//        let value = Int(arc4random()%47) + 1
//        let image = UIImage.init(named: "head_" + String(value))
//        
//        if let data = image?.pngData() {
////            let userProfile = UserProfile(avatar: data, format: "jpg", name: "小胖子")
////            let model = UserInfoModel(aUid: aUids.first ?? "", profile: userProfile)
////            self.kit?.setUserInfo(userInfos: [model])
//            var markers: [IMConversationMarker] = []
//            
//            for item in aChatIds {
//                markers.append(IMConversationMarker(aChatId: item, icon: IMAvatar(data: data, format: "jpg")))
//            }
//            self.conversionViewModel?.setConversationMarker(markers: markers)
//
//        }
    }
    
    func onShowConversationMarker(aChatIds: [String]) {
        print("会话标识回调")
//        let value = Int(arc4random()%47) + 1
//
//        let image = UIImage.init(named: "head_" + String(value))
//
//        if let data = image?.pngData() {
//            let marker1 = ConversationMarker(aChatId: "1471471479_18522221111", icon: data, format: "jpg")
//            self.kit?.setConversationMarker(markers: [marker1])
//        }
        
    }
     
    func onReceiveMessage(receiveMessageList: [IMReceiveMessageInfo]) {
        for item in receiveMessageList {
            print("receive new messages amid: \(item.amid), aChatId: \(item.aChatId)")
        }
    }
    
    func onSendMessageFailed(aMid: String, aChatId: String, error: IMMessaageSendError) {
        print("消息发送失败，aMid：\(aMid),aChatId:\(aChatId),error:\(error)")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let btn1=UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        btn1.setTitle("创建chat", for: .normal)
        btn1.addTarget(self, action: #selector(sendMassageClick), for: .touchUpInside)
        btn1.setTitleColor(UIColor.blue, for: .normal)
        let item2=UIBarButtonItem(customView: btn1)

        let btn4 = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        btn4.setTitle("设置", for: .normal)
        btn4.addTarget(self, action: #selector(settingMassageClick), for: .touchUpInside)
        btn4.setTitleColor(UIColor.blue, for: .normal)
        let item5=UIBarButtonItem(customView: btn4)
        
        self.navigationItem.rightBarButtonItems = [item2];

        self.navigationItem.leftBarButtonItems = [item5]
        
        let originY: CGFloat = 0.0
        let tabbarH: CGFloat = self.tabBarController?.tabBar.frame.height ?? 0.0
        let height: CGFloat = self.view.frame.height - originY - tabbarH
        self.chatView?.frame = CGRect(x: 0, y: originY, width: screenWidth, height: height)
    }
    
    @objc private func folderMassageClick() {

        let alertController = UIAlertController(title: "tip",
                        message: "请输入aChatId", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            let textField: UITextField = (alertController.textFields?[0])!;
            if let str = textField.text, str.count > 1 {
                let value = Int(arc4random()%47) + 1
                let image = UIImage.init(named: "head_" + String(value))

                if let viewModel = self.conversionViewModel {

                    if let data = image?.pngData() {
                        viewModel.setFolder(aChatId: "_not-interested-folder_", content: "1 contacts", name: "Not 1 contacts", folderIcon: IMAvatar(data: data, format: "jpg"))

                        let curremtSelector = viewModel.getCurremtSelector()
                        let updateSelector = IMChatViewModelFactory.ofUnPart(ids: [str])
                        let folderSelector = IMChatViewModelFactory.ofPart(ids: ["_not-interested-folder_"])
                        if let andSelector = curremtSelector.and?(selector: updateSelector) {
                            if let lastSelector = andSelector.or?(selector: folderSelector) {
                                viewModel.replace(selector: lastSelector)
                            }

                        }
                    }
                }
            }
        })
        alertController.addTextField { (textfield) in

        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func settingMassageClick() {
        
        let confirmAlertController = UIAlertController(title: nil, message: "设置", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let action1 = UIAlertAction(title: "设置不感兴趣", style: .default) {[weak self] (action) in
            guard let self = self else {return}
            self.folderMassageClick()
        }
        
        let action2 = UIAlertAction(title: "修改不感兴趣", style: .default) {[weak self] (action) in
            guard let self = self else {return}
            self.changefolderMassageClick()
        }

        let action3 = UIAlertAction(title: "删除不感兴趣", style: .default) {[weak self] (action) in
            guard let self = self else {return}
            self.deletefolderMassageClick()
        }
        
        let action4 = UIAlertAction(title: "只显示某回话", style: .default) {[weak self] (action) in
            guard let self = self else {return}
            self.onlyShowChat()
        }
        
        let action5 = UIAlertAction(title: "不显示某回话", style: .default) {[weak self] (action) in
            guard let self = self else {return}
            self.showNoChat()
        }
        
        let action6 = UIAlertAction(title: "显示全部回话", style: .default) {[weak self] (action) in
            guard let self = self else {return}
            self.showAll()
        }
        
        let action7 = UIAlertAction(title: "筛选只有未读的会话", style: .default) {[weak self] (action) in
            guard let self = self else {return}
            self.showUnRead()
        }
        
        confirmAlertController.addAction(cancelAction)
        confirmAlertController.addAction(action1)
        confirmAlertController.addAction(action2)
        confirmAlertController.addAction(action3)
        confirmAlertController.addAction(action4)
        confirmAlertController.addAction(action5)
        confirmAlertController.addAction(action6)
        confirmAlertController.addAction(action7)

        self.present(confirmAlertController , animated: true, completion: nil)

    }
    
    
    func showUnRead() {
        let unreadSelector = IMChatViewModelFactory.unRead()
        
        if let andSelector = self.conversionViewModel?.getCurremtSelector().and?(selector: unreadSelector) {
            self.conversionViewModel?.replace(selector: andSelector)
        }
        
    }
    
    func showNoChat() {
        let alertController = UIAlertController(title: "tip",
                        message: "不显示某回话", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            let textField: UITextField = (alertController.textFields?[0])!;
            if let str = textField.text, str.count > 1 {
                if let viewModel = self.conversionViewModel {

//                    let curremtSelector = viewModel.getCurremtSelector()
                    let upDateSelector = IMChatViewModelFactory.ofUnPart(ids: [str])
                    
                    
                    viewModel.replace(selector: upDateSelector)

                    
//                    if let lastSelector = curremtSelector.and?(selector: upDateSelector) {
//                        viewModel.replace(selector: lastSelector)
//                    }
                }
            }
        })
        alertController.addTextField { (textfield) in
            //这个block会在弹出对话框的时候调用,这个参数textfield就是系统为我们创建的textfield
//            textfield.delegate = self
            print(textfield)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func onlyShowChat() {
        let alertController = UIAlertController(title: "tip",
                        message: "只显示某回话", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            let textField: UITextField = (alertController.textFields?[0])!;
            if let str = textField.text, str.count > 1 {
                if let viewModel = self.conversionViewModel {

//                    let curremtSelector = viewModel.getCurremtSelector()
                    let upDateSelector = IMChatViewModelFactory.ofPart(ids: [str])
                    
                    viewModel.replace(selector: upDateSelector)

//                    if let lastSelector = curremtSelector.and?(selector: upDateSelector) {
//                        viewModel.replace(selector: lastSelector)
//                    }
                }
            }
        })
        alertController.addTextField { (textfield) in
            //这个block会在弹出对话框的时候调用,这个参数textfield就是系统为我们创建的textfield
//            textfield.delegate = self
            print(textfield)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAll() {
        if let viewModel = self.conversionViewModel {

            let curremtSelector = viewModel.getCurremtSelector()
            let upDateSelector = IMChatViewModelFactory.ofAll()
            if let lastSelector = curremtSelector.or?(selector: upDateSelector) {
                viewModel.replace(selector: lastSelector)
            }
        }
    }
    
    func changefolderMassageClick() {
        let value = Int(arc4random()%47) + 1
        let image = UIImage.init(named: "head_" + String(value))

        if let viewModel = self.conversionViewModel {

            if let data = image?.pngData() {
                viewModel.setFolder(aChatId: "_not-interested-folder_", content: "1 contacts", name: "Not 1 contacts", folderIcon: IMAvatar(data: data, format: "jpg"))
            }
        }
    }
    
    @objc private func deletefolderMassageClick() {
        if let viewModel = self.conversionViewModel {
            viewModel.removeFolder(aChatId: "_not-interested-folder_")

            let curremtSelector = viewModel.getCurremtSelector()
            let updateSelector = IMChatViewModelFactory.ofAll()
            if let andSelector = curremtSelector.or?(selector: updateSelector) {
                viewModel.replace(selector: andSelector)
            }
        }
    }
    
    
    @objc private func sendMassageClick() {

        self.renameAlert()
    }
    
    // ConversationDelegate
    
    func onItemClick(aChatId: String) {
        if aChatId == "_not-interested-folder_" {
            let vc = TMFolderListViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.aChatIds = ["14714710_14714711"]
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = TMChatDetailController()
            vc.hidesBottomBarWhenPushed = true
            vc.aChatId = aChatId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func renameAlert() {
        let alertController = UIAlertController(title: "tip",
                        message: "请输入对方手机号", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            let textField: UITextField = (alertController.textFields?[0])!;
            if let str = textField.text, str.count > 1 {
                if let loginInfo = self.loginInfo {
                    let chatId = self.createAchatId(uid1: loginInfo.phone, uid2: str)
                    let auid = str.DDMD5Encrypt(.lowercase16)
                    self.imSdk?.createChat(aChatId: chatId, chatName: chatId, aUids: [auid], success: {
                        let vc = TMChatDetailController()
                        vc.hidesBottomBarWhenPushed = true
                        vc.aChatId = chatId
                        vc.viewModel = self.conversionViewModel
                        self.navigationController?.pushViewController(vc, animated: true)
                    }, fail: { error in
                        print("create chat error: \(error)")
                    })
                }
            }
        })
        alertController.addTextField { (textfield) in
            //这个block会在弹出对话框的时候调用,这个参数textfield就是系统为我们创建的textfield
//            textfield.delegate = self
            print(textfield)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func createAchatId(uid1 : String, uid2 : String) -> String {
        if uid1 > uid2 {
            let code = uid2 + "_" + uid1
            return code
        } else {
            let code = uid1 + "_" + uid2
            return code
        }
    }
    
}

extension TMChatListController: ConversationViewModelDelegate {
    func onHideConversation(aChatIds: [String]) -> [String] {
        return []
    }
    
    func unReadChange(count: Int) {
        print("未读数:\(count)")
    }
}
