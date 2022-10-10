//
//  TMSendMessageFootView.swift
//  IMSDK
//
//  Created by oceanMAC on 2022/9/29.
//

import UIKit
import SnapKit

class TMSendMessageFootView: UIView {

    private lazy var tipLab: UILabel = {
        let tipLab = UILabel(frame: .zero)
        tipLab.textAlignment = .center
        tipLab.font = UIFont.boldSystemFont(ofSize: 16)
        tipLab.textColor = UIColor.black
        tipLab.text = "输入区域"
        return tipLab
    }()
    
    public lazy var sendMessageBtn: UIButton = {
        let sendMessageBtn = UIButton(type: .roundedRect)
        sendMessageBtn.setTitle("发送消息", for: .normal)
        sendMessageBtn.setTitleColor(UIColor.white, for: .normal)
        sendMessageBtn.layer.cornerRadius = 5.0
        sendMessageBtn.layer.masksToBounds = true
        sendMessageBtn.backgroundColor = UIColor.blue
//        sendMessageBtn.addTarget(self, action: #selector(createGroupClick), for: .touchUpInside)
        return sendMessageBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white

        self.addSubview(self.tipLab)
        self.tipLab.snp_makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        self.addSubview(self.sendMessageBtn)
        self.sendMessageBtn.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.tipLab.snp_bottom).offset(0)
            make.width.equalTo(200)
            make.height.equalTo(42)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
