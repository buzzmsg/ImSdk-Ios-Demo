//
//  TMCostomizeView.swift
//  IMSDKDemo
//
//  Created by oceanMAC on 2022/12/8.
//

import UIKit
import SnapKit

class TMCostomizeView: UIView {

    lazy var timeLbl: UILabel = {
        let lbl: UILabel = UILabel(frame: .zero)
        lbl.font = UIFont.systemFont(ofSize: 12.0)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.isUserInteractionEnabled = true
        lbl.text = "可是对方贺卡的复活卡后付款啊国防科大个日历分割器拉人犯规卢卡斯的过分啦果然饭啦刚打开卡收到话费了"
        lbl.textColor = UIColor(red:162/255.0, green:168/255.0, blue:195/255.0, alpha:1.0)
        return lbl
    }()
       
    @objc private func whenLongClick(gesture: UIGestureRecognizer) {
        print("timeLbl长按手势来了")
    }
    
    public var aMid: String = ""
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10.0
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.whenLongClick(gesture:)))
        self.timeLbl.addGestureRecognizer(longPress)
        
        self.addSubview(self.timeLbl)
        self.timeLbl.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.snp_top).offset(10)
            make.bottom.equalTo(self.snp_bottom).offset(-10)

        }
    }
    

    override public func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
