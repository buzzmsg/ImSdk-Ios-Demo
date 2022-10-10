//
//  TMTabbarController.swift
//  IMSDK
//
//  Created by Joey on 2022/9/26.
//

import UIKit

class TMTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.backgroundColor = .white
        
        let chatListVC: TMChatListController = TMChatListController()
        chatListVC.tabBarItem.selectedImage = UIImage(named: "tab_icon_chat_select")
        chatListVC.tabBarItem.image = UIImage(named: "tab_icon_chat_normal")
        chatListVC.tabBarItem.title = "聊天"
        let chatNav: TMNavigationController = TMNavigationController(rootViewController: chatListVC)
        
        let userVC: TMUserInfoController = TMUserInfoController()
        userVC.tabBarItem.selectedImage = UIImage(named: "tab_icon_me_select")
        userVC.tabBarItem.image = UIImage(named: "tab_icon_me_normal")
        userVC.tabBarItem.title = "我"
        let userNav: TMNavigationController = TMNavigationController(rootViewController: userVC)
        
        self.viewControllers = [chatNav, userNav]
        
    }
    
    

}
