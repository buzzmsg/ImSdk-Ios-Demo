//
//  TMInputViewController.swift
//  IMSDKDemo
//
//  Created by Joey on 2022/11/8.
//

import UIKit
import SnapKit
import QMUIKit

class TMInputViewController: UIViewController {

    var doneBlock: ((_ text: String) -> Void)?
    
    
    private lazy var messageTextView: QMUITextView = {
        let messageTextView = QMUITextView(frame: .zero)
        messageTextView.backgroundColor = UIColor.clear
        messageTextView.font = UIFont.systemFont(ofSize: 16)
        messageTextView.placeholder = "输入副标题"
        messageTextView.placeholderColor = UIColor.gray
        messageTextView.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        messageTextView.layer.cornerRadius = 6.0
        messageTextView.layer.masksToBounds = true
        return messageTextView
    }()
    
    private lazy var sureBtn: UIButton = {
        let sendTextBtn = UIButton(type: .roundedRect)
        sendTextBtn.setTitle("确定", for: .normal)
        sendTextBtn.setTitleColor(UIColor.white, for: .normal)
        sendTextBtn.layer.cornerRadius = 5.0
        sendTextBtn.layer.masksToBounds = true
        sendTextBtn.backgroundColor = UIColor.blue
        sendTextBtn.addTarget(self, action: #selector(sendTextClick), for: .touchUpInside)
        return sendTextBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        self.view.addSubview(self.messageTextView)
        self.messageTextView.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 30.0)
            make.top.equalTo(self.view).offset(20)
            make.height.equalTo(120)
        }
        
        self.view.addSubview(self.sureBtn)
        self.sureBtn.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.messageTextView.snp_bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(42)
        }
    }
    
    
    @objc private func sendTextClick() {
        if self.doneBlock != nil {
            self.doneBlock!(self.messageTextView.text)
            self.navigationController?.popViewController(animated: true)
        }
    }

}
