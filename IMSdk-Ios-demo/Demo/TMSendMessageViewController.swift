//
//  TMSendMessageViewController.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/29.
//

import UIKit
import SnapKit
import QMUIKit
import IMSDK

class TMSendMessageViewController: UIViewController {
    
    private lazy var messageTextView: QMUITextView = {
        let messageTextView = QMUITextView(frame: .zero)
        messageTextView.backgroundColor = UIColor.clear
        messageTextView.font = UIFont.systemFont(ofSize: 16)
        messageTextView.placeholder = "输入文本内容"
        messageTextView.placeholderColor = UIColor.gray
        messageTextView.text = "测试文本"
        messageTextView.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        messageTextView.layer.cornerRadius = 6.0
        messageTextView.layer.masksToBounds = true
        return messageTextView
    }()
    
    private lazy var sendTextBtn: UIButton = {
        let sendTextBtn = UIButton(type: .roundedRect)
        sendTextBtn.setTitle("发送文本消息", for: .normal)
        sendTextBtn.setTitleColor(UIColor.white, for: .normal)
        sendTextBtn.layer.cornerRadius = 5.0
        sendTextBtn.layer.masksToBounds = true
        sendTextBtn.backgroundColor = UIColor.blue
        sendTextBtn.addTarget(self, action: #selector(sendTextClick), for: .touchUpInside)
        return sendTextBtn
    }()
    
    private lazy var sendPicBtn: UIButton = {
        let sendTextBtn = UIButton(type: .roundedRect)
        sendTextBtn.setTitle("发送图片消息", for: .normal)
        sendTextBtn.setTitleColor(UIColor.white, for: .normal)
        sendTextBtn.layer.cornerRadius = 5.0
        sendTextBtn.layer.masksToBounds = true
        sendTextBtn.backgroundColor = UIColor.blue
        sendTextBtn.addTarget(self, action: #selector(sendPicClick), for: .touchUpInside)
        return sendTextBtn
    }()
    
    private lazy var sendFileBtn: UIButton = {
        let sendTextBtn = UIButton(type: .roundedRect)
        sendTextBtn.setTitle("发送附件消息", for: .normal)
        sendTextBtn.setTitleColor(UIColor.white, for: .normal)
        sendTextBtn.layer.cornerRadius = 5.0
        sendTextBtn.layer.masksToBounds = true
        sendTextBtn.backgroundColor = UIColor.blue
        sendTextBtn.addTarget(self, action: #selector(sendFileClick), for: .touchUpInside)
        return sendTextBtn
    }()
    
    private lazy var sendCardBtn: UIButton = {
        let sendTextBtn = UIButton(type: .roundedRect)
        sendTextBtn.setTitle("发送卡片消息", for: .normal)
        sendTextBtn.setTitleColor(UIColor.white, for: .normal)
        sendTextBtn.layer.cornerRadius = 5.0
        sendTextBtn.layer.masksToBounds = true
        sendTextBtn.backgroundColor = UIColor.blue
        sendTextBtn.addTarget(self, action: #selector(sendCardClick), for: .touchUpInside)
        return sendTextBtn
    }()
    
    private lazy var sendCVBtn: UIButton = {
        let sendTextBtn = UIButton(type: .roundedRect)
        sendTextBtn.setTitle("发送简历", for: .normal)
        sendTextBtn.setTitleColor(UIColor.white, for: .normal)
        sendTextBtn.layer.cornerRadius = 5.0
        sendTextBtn.layer.masksToBounds = true
        sendTextBtn.backgroundColor = UIColor.blue
        sendTextBtn.addTarget(self, action: #selector(sendCVClick), for: .touchUpInside)
        return sendTextBtn
    }()
    
    var aChatId = ""
    var imSdk: IMSdk? {
        return TMUserUtil.shared.imSdk
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "发消息"
        self.view.backgroundColor = UIColor.white

        self.view.addSubview(self.messageTextView)
        self.messageTextView.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 30.0)
            make.top.equalTo(self.view).offset(20)
            make.height.equalTo(120)
        }
        
        self.view.addSubview(self.sendTextBtn)
        self.sendTextBtn.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.messageTextView.snp_bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(42)
        }
        
        self.view.addSubview(self.sendPicBtn)
        self.sendPicBtn.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.sendTextBtn.snp_bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(42)
        }
        
        self.view.addSubview(self.sendFileBtn)
        self.sendFileBtn.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.sendPicBtn.snp_bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(42)
        }
        
        self.view.addSubview(self.sendCardBtn)
        self.sendCardBtn.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.sendFileBtn.snp_bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(42)
        }
        
        
        self.view.addSubview(self.sendCVBtn)
        self.sendCVBtn.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.sendCardBtn.snp_bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(42)
        }
    }
    
    @objc private func sendTextClick() {
        if self.messageTextView.text.count > 0 {
            let mid = IMSDKMessageId.create(uid: "f1ab109be266e394")
            self.imSdk?.sendTextMessage(aChatId: self.aChatId, aMid: mid, content: self.messageTextView.text)
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc private func sendPicClick() {
        IMSDKMediaChooseUtil.shared.chooseMedia(viewController: self) { (imgdata, format) in
            
            guard let data: Data = imgdata else {
                return
            }
            
            let messageID: String = IMSDKMessageId.create(uid: "f1ab109be266e394")
            self.imSdk?.sendImageMessage(aChatId: self.aChatId, aMid: messageID, data: data, format: format, isOrigin: false)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func sendFileClick() {
        IMSDKMediaChooseUtil.shared.chooseFile(viewController: self) { (imgdata, filename) in
         
            guard let data: Data = imgdata else {
                return
            }
            var ary: [String] = filename.components(separatedBy: ".")
            let format = ary.last ?? ""
            
            ary.removeLast()
            let name: String = ary.joined()

            let messageID: String = IMSDKMessageId.create(uid: "f1ab109be266e394")
            self.imSdk?.sendAttachmentMessage(aChatId: self.aChatId, aMid: messageID, data: data, fileName: name, format: format)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func sendCardClick() {
        let cardMsg = IMCardMessage()
        
        let text1: TextItem = TextItem()
        text1.value = "测试文本" + "\n"
        text1.color = "#898989"
        
        
        let text2: TextItem = TextItem()
        text2.value = "12345678910"
        text2.color = "#00C6DB"
        
        
        let btn1: ButtonItem = ButtonItem()
        btn1.txt = "不来"
        btn1.enableColor = "#0BCADE"
        btn1.disableColor = "#E9EAF0"
        btn1.buttonId = "btn1Context"
        
        let btn2: ButtonItem = ButtonItem()
        btn2.txt = "再想想"
        btn2.enableColor = "#0BCADE"
        btn2.disableColor = "#E9EAF0"
        btn2.buttonId = "btn2Context"
        
        let btn3: ButtonItem = ButtonItem()
        btn3.txt = "约起！"
        btn3.enableColor = "#0BCADE"
        btn3.disableColor = "#E9EAF0"
        btn3.buttonId = "btn3Context"
        
        cardMsg.text = [text1, text2]
        let value = Int(arc4random()%4)
        if value == 0 {
            cardMsg.buttons = [ ]
        }else if value == 1 {
            cardMsg.buttons = [btn1]
        }else if value == 2 {
            cardMsg.buttons = [btn1, btn2]
        }else {
            cardMsg.buttons = [btn1, btn2, btn3]
        }
        
        
        let value1 = Int(arc4random()%47) + 1

        let image = UIImage.init(named: "head_" + String(value1))
        
        if let data = image?.pngData() {
            cardMsg.icon = data
            cardMsg.format = "jpg"
        }
        
        let messageID: String = IMSDKMessageId.create(uid: "f1ab109be266e394")
        self.imSdk?.sendCardMessage(aChatId: self.aChatId, aMid: messageID, msg: cardMsg)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func sendCVClick() {
        if let loginInfo = TMUserUtil.shared.loginInfo {
            let time: Int = Date().milliStamp
            SendCardAndTempMessageApi.execute(aChatId: self.aChatId, aUid: loginInfo.auid, sendTime: time).then { _ -> Promise<Void> in
                self.navigationController?.popViewController(animated: true)
                return Promise<Void>.resolve()
            }
        }
    }
}
