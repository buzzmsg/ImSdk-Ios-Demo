//
//  TMChatListController.swift
//  IMSDK
//
//  Created by Joey on 2022/9/26.
//

import UIKit
import SVProgressHUD
import IMSDK


// TODO:
/// 1. 搬marker测试代码到当前页面逻辑

let SdkEnvType: IMEnvironmentType = .alpha

class TMChatListController: UIViewController, IMDelegate, IMConversationDelegate, IMConversionSelector, ConversionViewModelDelegate {
    
    
    func onUnReadCountChange(count: Int) {
        print("当前未读数\(count)")
    }

    var loginInfo: TMDemoLoginResponse? {
        return TMUserUtil.shared.loginInfo
    }
    var imSdk: IMSdk? {
        return TMUserUtil.shared.imSdk
    }
    var conversionViewModel: IMConversionViewModel?
    private var chatView: IMConversationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "聊天"

        let btn1=UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        btn1.setTitle("发消息", for: .normal)
        let item2=UIBarButtonItem(customView: btn1)
        self.navigationItem.rightBarButtonItem = item2
        
        if let imSdk = self.imSdk, let loginInfo = loginInfo {
            imSdk.setIMDelegate(delegate: self)
            
            imSdk.setAuthCode(auth: loginInfo.authcode)
            imSdk.initUser(aUid: loginInfo.auid)
            imSdk.setLanguage(language: IMLanguageType.English)
            
            self.conversionViewModel = imSdk.createConversationViewModel(selector: IMChatViewModelFactory.ofAll())
            self.conversionViewModel?.setDelegate(delegate: self)
            
            let value = Int(arc4random()%47) + 1
            let image = UIImage.init(named: "head_" + String(value))

            if let viewModel = self.conversionViewModel {
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
        }
    }
    
    func authCodeExpire(aUid: String, errorCode: IMSDK.IMSdkError) {
        print("登录失败来了, errorCode: \(errorCode)")
    }
    
    func onShowUserInfo(datas: [IMSDK.IMShowUserInfo]) {
        
        let value = Int(arc4random()%47) + 1
        let image = UIImage.init(named: "head_" + String(value))
        
        if let data = image?.pngData() {
            let userProfile = UserProfile(avatar: IMAvatar(data: data, format: "jpg"), name1: "小胖子", name3: "")
            if let aUid = datas.first?.aUid {
                let model = IMUserInfoModel(aUid: aUid, profile: userProfile)
                self.imSdk?.setUserInfo(userInfos: [model])
            }
        }
    }
    
    func onShowConversationSubTitle(aChatIds: [String]) {
//        let value = Int(arc4random()%47) + 1
//
//        let image = UIImage.init(named: "head_" + String(value))
//
//        if let data = image?.pngData() {
//            //let marker1 = ConversationMarker(aChatId: "1471471479_18522221111", icon: data, format: "jpg")
//            let subTitle = ConversationSubTitle(aChatId: "1471471479_18522221111", subTitle: "开发工程师")
//            self.kit?.setConversationSubTitle(subTitles: [subTitle])
//        }
    }
    
    func onShowConversationMarker(aChatIds: [String]) {
//        let value = Int(arc4random()%47) + 1
//
//        let image = UIImage.init(named: "head_" + String(value))
//
//        if let data = image?.pngData() {
//            let marker1 = ConversationMarker(aChatId: "1471471479_18522221111", icon: data, format: "jpg")
//            self.kit?.setConversationMarker(markers: [marker1])
//        }
        
    }
     
    
    func onReceiveMessage(aMids: [String]) {
        for mid in aMids {
            print("receive new messages amid: \(mid), aChatId: null")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        let items1=UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
//        self.navigationItem.rightBarButtonItems=[items1]
        
        let btn1=UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        btn1.setTitle("创建chat", for: .normal)
        btn1.addTarget(self, action: #selector(sendMassageClick), for: .touchUpInside)
        btn1.setTitleColor(UIColor.blue, for: .normal)
        let item2=UIBarButtonItem(customView: btn1)
//        self.navigationItem.rightBarButtonItem = item2
        
        let btn2 = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        btn2.setTitle("加入测试群", for: .normal)
        btn2.addTarget(self, action: #selector(addMassageClick), for: .touchUpInside)
        btn2.setTitleColor(UIColor.blue, for: .normal)
        let item3=UIBarButtonItem(customView: btn2)
        
        
        let btn3 = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        btn3.setTitle("不感兴趣", for: .normal)
        btn3.addTarget(self, action: #selector(folderMassageClick), for: .touchUpInside)
        btn3.setTitleColor(UIColor.blue, for: .normal)
        let item4=UIBarButtonItem(customView: btn3)
        
        
        self.navigationItem.rightBarButtonItems = [item2,item4];

        self.navigationItem.leftBarButtonItem = item3
        
        let originY: CGFloat = 0.0
        let tabbarH: CGFloat = self.tabBarController?.tabBar.frame.height ?? 0.0
        let height: CGFloat = self.view.frame.height - originY - tabbarH
        self.chatView?.frame = CGRect(x: 0, y: originY, width: screenWidth, height: height)
    }
    
    @objc private func folderMassageClick() {
        let value = Int(arc4random()%47) + 1
        let image = UIImage.init(named: "head_" + String(value))
        
        if let viewModel = self.conversionViewModel {
            
            if let data = image?.pngData() {
                viewModel.setFolder(aChatId: "_not-interested-folder_", content: "4 contacts", name: "Not 4 contacts", folderIcon: IMAvatar(data: data, format: "jpg"))
            }
        }
    }
    
    @objc private func addMassageClick() {

//        if let viewModel = self.conversionViewModel {
//            viewModel.updateSelector(removeAchatIds: ["147147100_1479999"])
//        }
//        return
        
//        self.conversionViewModel?.getChatIsTop(aChatId: "147147100_147147323232")
        self.renameAlert()
//        SVProgressHUD.show()
//        if let loginInfo = TMUserUtil.getLogin() {
//            IMSdk.getInstance(ak: loginInfo.ak, env: SdkEnvType, deviceId: "iOS").joinTestGroup {[weak self] (aChatId) in
//                guard let self = self else { return }
//                SVProgressHUD.popActivity()
//                let vc = TMChatDetailController()
//                vc.hidesBottomBarWhenPushed = true
//                vc.aChatId = aChatId
//                self.navigationController?.pushViewController(vc, animated: true)
//            } fail: { str in
//                SVProgressHUD.popActivity()
//                SVProgressHUD.showError(withStatus: str)
//            }
//        }
    }
    
    
    @objc private func sendMassageClick() {
        
//        if let viewModel = self.conversionViewModel {
//            viewModel.updateSelector(selectAchatIds: ["-empty-cmd"])
//
//            viewModel.updateSelector(unSelectAchatIds: ["147147100_1471471000"])
//
//            self.folderMassageClick()
//            viewModel.updateSelector(selectAchatIds: ["_not-interested-folder_"], unSelectAchatIds:["147147100_1471471000"])
//
//            viewModel.updateSelector(selectAchatIds: ["147147100_1471471000"])
//        }
        self.renameAlert()
        
//        if let viewModel = self.conversionViewModel {
//
//            viewModel.getUnReadCount { count in
//                print("当前未读数\(count)")
//            }
//        }
    }
    
    // ConversationDelegate
    
    func onItemClick(aChatId: String) {
        if aChatId == "xxxxxxxxxxxxxxxxxxxxxx" {
            let vc = TMFolderListViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.aChatIds = ["TestAli","147147000000_14714733333"]
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
