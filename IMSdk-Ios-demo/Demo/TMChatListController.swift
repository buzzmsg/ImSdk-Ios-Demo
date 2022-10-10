//
//  TMChatListController.swift
//  IMSDK
//
//  Created by Joey on 2022/9/26.
//

import UIKit

import IMSdk


class TMChatListController: UIViewController, IMDelegate, ConversationDelegate {
    
    
    func onAuth(aUid: String, resolve: @escaping ((_ auth: String) -> ())) {
        if let info = self.loginInfo {
            TMDemoGetAuth.execute(token: info.token).then { authRespon -> Promise<Void> in
                resolve(authRespon.authcode)
                return Promise<Void>.resolve()
            }
        }
    }
    

    var loginInfo: TMDemoLoginResponse?
    var kit: IMSdk?
    
    private var chatView: ConversationView = ConversationView()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "聊天"
        

        
        let btn1=UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        btn1.setTitle("发消息", for: .normal)
        let item2=UIBarButtonItem(customView: btn1)
        self.navigationItem.rightBarButtonItem = item2
        
        if let loginInfo = TMUserUtil.getLogin() {
            self.loginInfo = loginInfo
            //self.kit = TMKit(ak: loginInfo.ak, environment: .development)//TMKit.getSharedInstance(ak: loginInfo.ak, environment: .development)
            self.kit = IMSdk.getInstance(ak: loginInfo.ak, env: .alpha)
            self.kit?.setIMDelegate(delegate: self)
            self.kit?.initUser(aUid: loginInfo.auid)
        }
        
        if let kit = self.kit {
            
            self.chatView = kit.creatConversationView()
            self.chatView.setDelegate(delegate: self)
            self.view.addSubview(self.chatView)
        }
        
        
        if let loginInfo = TMUserUtil.getLogin() {
            IMSdk.getInstance(ak: loginInfo.ak, env: .alpha).startSocket()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        let items1=UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
//        self.navigationItem.rightBarButtonItems=[items1]
        
        let btn1=UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        btn1.setTitle("创建chat", for: .normal)
        btn1.addTarget(self, action: #selector(sendMassageClick), for: .touchUpInside)
        btn1.setTitleColor(UIColor.blue, for: .normal)
        let item2=UIBarButtonItem(customView: btn1)
        self.navigationItem.rightBarButtonItem = item2
        
        let originY: CGFloat = 0.0
        let tabbarH: CGFloat = self.tabBarController?.tabBar.frame.height ?? 0.0
        let height: CGFloat = self.view.frame.height - originY - tabbarH
        self.chatView.frame = CGRect(x: 0, y: originY, width: screenWidth, height: height)
    }
    
    @objc private func sendMassageClick() {
//        let vc = TMCreateGroupViewController()
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
        self.renameAlert()

    }
    
    // ConversationDelegate
    
    func onItemClick(aChatId: String) {
        let vc = TMChatDetailController()
        vc.hidesBottomBarWhenPushed = true
        vc.aChatId = aChatId
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func renameAlert() {
        let alertController = UIAlertController(title: "tip",
                        message: "请输入对方手机号", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            let textField: UITextField = (alertController.textFields?[0])!;
            
            if let str = textField.text, str.count > 1 {
                //执行
                
                let otherAuid = str.DDMD5Encrypt(.lowercase16)
                if let loginInfo = TMUserUtil.getLogin() {                    
                    let chat = self.createAchatId(uid1: loginInfo.phone, uid2: str)
                    IMSdk.getInstance(ak: loginInfo.ak, env: .alpha).createChat(aChatId: chat, chatName: chat, auids: [otherAuid]) {
                        let vc = TMChatDetailController()
                        vc.hidesBottomBarWhenPushed = true
                        vc.aChatId = str
                        self.navigationController?.pushViewController(vc, animated: true)
                    } fail: { errorString in
                        //create fail
                    }
                }
            }
        })
        alertController.addTextField { (textfield) in
            //这个block会在弹出对话框的时候调用,这个参数textfield就是系统为我们创建的textfield
//            textfield.delegate = self
            print(textfield)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func createAchatId(uid1 : String, uid2 : String) -> String {
        if uid1 > uid2 {
            let code = uid2 + "_" + uid1
            return code
        } else {
            let code = uid1 + "_" + uid2
            return code
        }
    }
    
}
