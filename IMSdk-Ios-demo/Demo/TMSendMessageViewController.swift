//
//  TMSendMessageViewController.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/29.
//

import UIKit
import SnapKit
import QMUIKit
import IMSdk

class TMSendMessageViewController: UIViewController {

    var aChatId = ""
    
    private lazy var messageTextView: QMUITextView = {
        let messageTextView = QMUITextView(frame: .zero)
        messageTextView.backgroundColor = UIColor.clear
        messageTextView.font = UIFont.systemFont(ofSize: 16)
        messageTextView.placeholder = "输入对方uid"
        messageTextView.placeholderColor = UIColor.gray
        messageTextView.text = "f1ab109be266e394"
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
    }
    
    @objc private func sendTextClick() {
        if self.messageTextView.text.count > 0 {
            if let loginInfo = TMUserUtil.getLogin() {
                IMSdk.getInstance(ak: loginInfo.ak, env: .alpha).sendTextMessage(content: self.messageTextView.text, aChatId: self.aChatId, aMid: IMSDKMessageId.create(uid: "f1ab109be266e394"))
                self.navigationController?.popViewController(animated: true)
            }
        }

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
