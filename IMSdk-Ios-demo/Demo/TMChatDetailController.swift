//
//  TMChatDetailController.swift
//  IMSDK
//
//  Created by Joey on 2022/9/26.
//

import UIKit
import SnapKit
import IMSdk

class TMChatDetailController: UIViewController {

    var aChatId = ""

    private var chatListView: ChatView = ChatView()
    private lazy var sendView: TMSendMessageFootView = {
        let sendView = TMSendMessageFootView(frame: .zero)
        sendView.sendMessageBtn.addTarget(self, action: #selector(sendMessageClick), for: .touchUpInside)
        return sendView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.aChatId
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.sendView)
        self.sendView.snp_makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(140)
        }
        
        
        if let loginInfo = TMUserUtil.getLogin() {
            self.chatListView = IMSdk.getInstance(ak: loginInfo.ak, env: .alpha).creatChatView(aChatId: self.aChatId)
            self.chatListView.backgroundColor = .red
            self.view.addSubview(self.chatListView)
            
            self.chatListView.snp_makeConstraints { make in
                make.left.top.right.equalToSuperview()
                make.bottom.equalTo(self.sendView.snp_top)
            }
        }
        
        
        
    }
    
    @objc private func sendMessageClick() {
        let vc = TMSendMessageViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.aChatId = self.aChatId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, yovu will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
