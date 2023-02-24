//
//  TMUserInfoController.swift
//  IMSDK
//
//  Created by Joey on 2022/9/26.
//

import UIKit
import IMSDK

class TMUserInfoController: UIViewController {

    private lazy var createGroupBtn: UIButton = {
        let createGroupBtn = UIButton(type: .roundedRect)
        createGroupBtn.setTitle("退出登录", for: .normal)
        createGroupBtn.addTarget(self, action: #selector(createGroupClick), for: .touchUpInside)
        createGroupBtn.setTitleColor(UIColor.red, for: .normal)
        return createGroupBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.backgroundColor = .blue
        
        self.view.addSubview(self.createGroupBtn)
        self.createGroupBtn.frame = CGRect(x: 100, y: 100, width: 100, height: 40)
    }
    
    @objc private func createGroupClick() {
        TMUserUtil.shared.imSdk?.loginOut()
        TMUserUtil.shared.clearLoginInfo()
        let loginVC: TMLoginController = TMLoginController()
        UIApplication.shared.keyWindow?.rootViewController = loginVC
    }
}
