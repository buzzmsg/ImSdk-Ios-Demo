//
//  TMCreateGroupViewController.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/29.
//

import UIKit
import IMSdk

let setAChatId = ""

class TMCreateGroupViewController: UIViewController {

    private lazy var otherUidTextField: UITextField = {
        let otherUidTextField = UITextField(frame: .zero)
        otherUidTextField.backgroundColor = UIColor.clear
        otherUidTextField.font = UIFont.systemFont(ofSize: 16)
        otherUidTextField.placeholder = "输入对方uid"
        otherUidTextField.layer.borderWidth = 1.0
        otherUidTextField.layer.borderColor = UIColor.green.cgColor
        otherUidTextField.text = "ce4a48b4231e3239"
        return otherUidTextField
    }()
    
    private lazy var createGroupBtn: UIButton = {
        let createGroupBtn = UIButton(type: .roundedRect)
        createGroupBtn.setTitle("创建chat", for: .normal)
        createGroupBtn.addTarget(self, action: #selector(createGroupClick), for: .touchUpInside)
        return createGroupBtn
    }()
    
    private lazy var sendMassageBtn: UIButton = {
        let sendMassageBtn = UIButton(type: .roundedRect)
        sendMassageBtn.setTitle("发消息", for: .normal)
        sendMassageBtn.addTarget(self, action: #selector(sendMassageClick), for: .touchUpInside)
        return sendMassageBtn
    }()
    
    private lazy var conversionsBtn: UIButton = {
        let conversionsBtn = UIButton(type: .roundedRect)
        conversionsBtn.setTitle("获取会话列表", for: .normal)
        conversionsBtn.addTarget(self, action: #selector(getConversionsClick), for: .touchUpInside)
        return conversionsBtn
    }()
    
    private lazy var messagesBtn: UIButton = {
        let messagesBtn = UIButton(type: .roundedRect)
        messagesBtn.setTitle("获取会话下所有消息", for: .normal)
        messagesBtn.addTarget(self, action: #selector(getMessagesBtnClick), for: .touchUpInside)
        return messagesBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.otherUidTextField)
        self.otherUidTextField.frame = CGRect(x: 30, y: 100, width: UIScreen.main.bounds.width - 60, height: 50)
        
        self.view.addSubview(self.createGroupBtn)
        self.createGroupBtn.frame = CGRect(x: (UIScreen.main.bounds.width - 100)/2, y: 170, width: 100, height: 50)
        
//        self.view.addSubview(self.sendMassageBtn)
//        self.sendMassageBtn.frame = CGRect(x: (UIScreen.main.bounds.width - 100)/2, y: 250, width: 100, height: 50)
        
//        self.view.addSubview(self.conversionsBtn)
//        self.conversionsBtn.frame = CGRect(x: (UIScreen.main.bounds.width - 100)/2, y: 330, width: 100, height: 50)
        
//        self.view.addSubview(self.messagesBtn)
//        self.messagesBtn.frame = CGRect(x: (UIScreen.main.bounds.width - 200)/2, y: 410, width: 200, height: 50)
    }
    
    @objc private func createGroupClick() {
        
        if let loginInfo = TMUserUtil.getLogin() {
            if (self.otherUidTextField.text?.count ?? 0) > 0 {
//                TMKit.getSharedInstance(ak: loginInfo.ak, environment: .development).createGroupChat(aUid: [self.otherUidTextField.text ?? "xxxxx"], aChatId: loginInfo.auid + "_" + (self.otherUidTextField.text ?? "xxxx"))
                
//                TMKit.getSharedInstance(ak: loginInfo.ak, environment: .development).sendTextMassage(content: "test", aChatId: "achatidmijie123457689", aMid: IMSDKMessageId.create(uid: "33724e6c346e"))

            }
        }
//        TMKit.shared.createGroupChat(aUid: ["33724e6c346e"], aChatId: "achatid")
    }
    
    @objc private func sendMassageClick() {
        if let loginInfo = TMUserUtil.getLogin() {
            IMSdk.getInstance(ak: loginInfo.ak, env: .alpha, deviceId: "iOS").sendTextMessage(aChatId: "achatid", aMid: IMSDKMessageId.create(uid: "33724e6c346e"), content: "咔叽过分哈股份")
        }
//        TMKit.shared.sendTextMassage(content: "咔叽过分哈股份", aChatId: "achatid", aMid: IMSDKMessageId.create(uid: "33724e6c346e"))
    }

    @objc private func getConversionsClick() {
        if let loginInfo = TMUserUtil.getLogin() {
            IMSdk.getInstance(ak: loginInfo.ak, env: .alpha, deviceId: "iOS").getConversions()
        }
//        let list = TMKit.shared.getConversions()
//        print("获取会话列表一共：\(list.count)条")
    }
    
    @objc private func getMessagesBtnClick() {
//        if let loginInfo = TMUserUtil.getLogin() {
//            TMKit.getSharedInstance(ak: loginInfo.ak, environment: .development).getMassages(chatId: "0c3c5f9283cc6bc60108cd667493aa6247fb4c93")
//        }
    }
    
}
