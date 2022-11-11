//
//  TMLoginController.swift
//  IMSDK
//
//  Created by Joey on 2022/9/26.
//

import UIKit


class TMLoginController: UIViewController {

    
    private let telStr: String = ""//"147147100"
    private var telTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let titleLbl: UILabel = UILabel(frame: CGRect(x: 0, y: 80, width: UIScreen.main.bounds.size.width, height: 30.0))
        titleLbl.text = "TmmTmm SDK"
        titleLbl.textAlignment = .center
        titleLbl.font = UIFont.systemFont(ofSize: 15.0)
        self.view.addSubview(titleLbl)
        
        
        let textLblTop: CGFloat = 270
        let textLblWidth: CGFloat = 80.0
        let textLblHeight: CGFloat = 24.0
        let textLblBottomMargin: CGFloat = 20.0
        let textLblRightMargin: CGFloat = 16.0
        let telphoneLbl: UILabel = UILabel(frame: CGRect(x: 24, y: textLblTop, width: textLblWidth, height: textLblHeight))
        telphoneLbl.text = "手机号码"
        telphoneLbl.textAlignment = .center
        telphoneLbl.font = UIFont.systemFont(ofSize: 15.0)
        self.view.addSubview(telphoneLbl)
        
        let textFieldX: CGFloat = telphoneLbl.frame.minX
        let textFieldWidth: CGFloat = UIScreen.main.bounds.width - textFieldX - textLblRightMargin
        telTextField = UITextField(frame: CGRect(x: textFieldX, y: telphoneLbl.frame.maxY + textLblBottomMargin, width: textFieldWidth, height: 44.0))
        telTextField.font = UIFont.systemFont(ofSize: 15.0)
        telTextField.backgroundColor = .lightGray
        telTextField.layer.cornerRadius = 5.0
        telTextField.keyboardType = .decimalPad
        telTextField.layer.borderColor = UIColor.black.cgColor
        telTextField.text = telStr
        telTextField.placeholder = "请输入手机号码"
//        telTextField.isUserInteractionEnabled = false
        self.view.addSubview(telTextField)
        

        let btnW: CGFloat = 100.0
        let btnH: CGFloat = 30.0
        let btn: UIButton = UIButton.init(frame: CGRect(x: self.view.frame.midX - btnW/2.0, y: telTextField.frame.maxY + textLblBottomMargin*2.0, width: btnW, height: btnH))
        btn.setTitle("登陆", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 5.0
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn.addTarget(self, action: #selector(clickLoginAct(btn:)), for: .touchUpInside)
        self.view.addSubview(btn)
    
        
    }
    

    @objc func clickLoginAct(btn: UIButton) {
        
        if let text = self.telTextField.text, text.count > 0 {
            
            TMDemoLogin.execute(prefix: "", phone: text).then { response -> Promise<Void> in
                
                return TMDemoGetAuth.execute(token: response.token).then { authRespon -> Promise<Void> in
                    var tempResponse = response
                    tempResponse.authcode = authRespon.authcode
                    TMUserUtil.setLogin(data: tempResponse)
                    let tabbar: TMTabbarController = TMTabbarController()
                    UIApplication.shared.keyWindow?.rootViewController = tabbar
                    
                    return Promise<Void>.resolve()
                }
            }
        }
        
        
        
        
    }
    

}
