//
//  TMFolderListViewController.swift
//  IMSDKDemo
//
//  Created by oceanMAC on 2022/11/2.
//

import UIKit
import IMSDK

class TMFolderListViewController: UIViewController, IMConversationDelegate, IMConversionSelector {

    var aChatIds:[String] = []
    var imSdk: IMSdk? {
        return TMUserUtil.shared.imSdk
    }
    var conversionViewModel: IMConversionViewModel?
    private var chatView: IMConversationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "不感兴趣"
        self.view.backgroundColor = UIColor.white
        
        conversionViewModel = imSdk?.createConversationViewModel(selector: IMChatViewModelFactory.ofPart(ids: self.aChatIds))
        if let chatView = conversionViewModel?.getConversionView() {
            self.chatView = chatView
            chatView.setDelegate(delegate: self)
            self.view.addSubview(chatView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let originY: CGFloat = 0.0
//        let tabbarH: CGFloat = self.tabBarController?.tabBar.frame.height ?? 0.0
        let height: CGFloat = self.view.frame.height - originY
        self.chatView?.frame = CGRect(x: 0, y: originY, width: screenWidth, height: height)
    }
    

    func onItemClick(aChatId: String) {
        let vc = TMChatDetailController()
        vc.hidesBottomBarWhenPushed = true
        vc.aChatId = aChatId
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
