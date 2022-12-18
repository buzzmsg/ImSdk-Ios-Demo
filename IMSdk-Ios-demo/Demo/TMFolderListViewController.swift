//
//  TMFolderListViewController.swift
//  IMSDKDemo
//
//  Created by oceanMAC on 2022/11/2.
//

import UIKit
import IMSdk

class TMFolderListViewController: UIViewController, IMDelegate, ConversationDelegate, TMConversionSelector {

    var aChatIds:[String] = []

    var kit: IMSdk?
    var conversionViewModel: TMConversionViewModel?

    private var chatView: ConversationView = ConversationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "不感兴趣"
        self.view.backgroundColor = UIColor.white
        
        if let loginInfo = TMUserUtil.getLogin() {
            self.kit = IMSdk.getInstance(ak: loginInfo.ak, env: .alpha, deviceId: "iOS")
        }
        
        if let kit = self.kit {
            self.conversionViewModel = kit.createConversationViewModel(selector: ChatViewModelFactory.ofPart(ids: self.aChatIds))
            if let viewModel = self.conversionViewModel {
                self.chatView = viewModel.getConversionView()
                self.chatView.setDelegate(delegate: self)
                self.view.addSubview(self.chatView)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let originY: CGFloat = 0.0
//        let tabbarH: CGFloat = self.tabBarController?.tabBar.frame.height ?? 0.0
        let height: CGFloat = self.view.frame.height - originY
        self.chatView.frame = CGRect(x: 0, y: originY, width: screenWidth, height: height)
    }
    
    func onShowUserInfo(aUids: [String]) {
        
        let value = Int(arc4random()%47) + 1

        let image = UIImage.init(named: "head_" + String(value))
        
        if let data = image?.pngData() {
            let userProfile = UserProfile(avatar: data, format: "jpg", name: "小胖子", avatarPath: "")
            let model = UserInfoModel(aUid: aUids.first ?? "", profile: userProfile)
            self.kit?.setUserInfo(userInfos: [model], complete: { code in
                if code == 1024 {
                    print("头像选择的图片超过1M")
                }
            })
        }
    }

    func onItemClick(aChatId: String) {
        let vc = TMChatDetailController()
        vc.hidesBottomBarWhenPushed = true
        vc.aChatId = aChatId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
