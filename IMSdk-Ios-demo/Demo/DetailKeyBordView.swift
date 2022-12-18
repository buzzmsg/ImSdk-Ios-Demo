//
//  DetailKeyBordView.swift
//  IMSDKDemo
//
//  Created by oceanMAC on 2022/12/13.
//

import UIKit
import SnapKit

class DetailKeyBordView: UIView {

    lazy var contentTextField: UITextField = {
        let lbl: UITextField = UITextField(frame: .zero)
        lbl.font = UIFont.systemFont(ofSize: 14.0)
        lbl.textAlignment = .left
//        lbl.numberOfLines = 0
        lbl.isUserInteractionEnabled = true
        lbl.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        lbl.text = "可是对方贺卡的复活卡后付款啊国防科大个日历分割器拉人犯规卢卡斯的过分啦果然饭啦刚打开卡收到话费了"
//        lbl.textColor = UIColor(red:162/255.0, green:168/255.0, blue:195/255.0, alpha:1.0)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.contentTextField)
        self.contentTextField.snp.makeConstraints { make in
            make.left.equalTo(self.snp_left).offset(20)
            make.right.equalTo(self.snp_right).offset(-20)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
    }
    

    override public func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
