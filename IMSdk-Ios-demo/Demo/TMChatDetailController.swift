//
//  TMChatDetailController.swift
//  IMSDK
//
//  Created by Joey on 2022/9/26.
//

import UIKit
import SnapKit
import IMSDK
import QMUIKit

class TMChatDetailController: UIViewController, IMChatDelegate {
    
    var aChatId = ""
    
    var navHeight = 0.0
    
    var imSdk: IMSdk? {
        return TMUserUtil.shared.imSdk
    }
    
    lazy var viewModel: IMConversationViewModel? = {
        return imSdk?.createConversationViewModel(selector: IMChatViewModelFactory.ofPart(ids: [aChatId]))
    }()
    deinit {
        print("TMChatDetailController - swift 灰飞烟灭")
    }

    public var tapMap: [String: ((UIView) -> ())] = [:]

    private var chatListView: IMChatView?

//    private lazy var sendView: TMSendMessageFootView = {
//        let sendView = TMSendMessageFootView(frame: .zero)
//        sendView.sendMessageBtn.addTarget(self, action: #selector(sendMessageClick), for: .touchUpInside)
//        sendView.editBtn.addTarget(self, action: #selector(subTitleClick), for: .touchUpInside)
//        sendView.textBtn.addTarget(self, action: #selector(selectImageClick), for: .touchUpInside)
//        return sendView
//    }()
    
    private lazy var inputV: QMUITextView = {
        let v = QMUITextView(frame: .zero)
        v.placeholder = "请输入内容"
        v.backgroundColor = .white
        v.returnKeyType = .send
        v.delegate = self
        return v
    }()

    @objc private func whenTapTwoClick(gesture: UIGestureRecognizer) {
        if var view = gesture.view as? TMCostomizeView, let aMid = view.restorationIdentifier, let cloc = self.tapMap[aMid] {
            view.frame = CGRect(x: 0, y: 0, width: UIDevice.YH_Width * 0.8, height: 140)
            view.timeLbl.text = aMid + "567uijhnbvcertyhgfdsrtyh可是对方贺卡的复活卡后付款啊国防科大是对方贺卡的复活卡后付款啊国防科大是对方贺卡的复活卡后付款啊国防科大是对方贺卡的复活卡后付款啊国防科大个日历分割器拉人犯规卢卡斯的过分啦果然饭啦刚打开卡收到话费了"
            cloc(view)
        }
        
        
//        for item in self.viewList {
//            if let amid = aMid {
//                item.frame = CGRect(x: 0, y: 0, width: UIDevice.YH_Width/2, height: 140)
//                item.timeLbl.text = amid + "567uijhnbvcertyhgfdsrtyh可是对方贺卡的复活卡后付款啊国防科大是对方贺卡的复活卡后付款啊国防科大是对方贺卡的复活卡后付款啊国防科大是对方贺卡的复活卡后付款啊国防科大个日历分割器拉人犯规卢卡斯的过分啦果然饭啦刚打开卡收到话费了"
//                if let closure = self.defaultSort {
//                    closure(item)
//                }
//                break
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.aChatId
        
        self.view.backgroundColor = UIColor.white
        
//        self.view.addSubview(self.sendView)
//        self.sendView.snp_makeConstraints { make in
//            make.left.bottom.right.equalToSuperview()
//            make.height.equalTo(140)
//        }
        self.navHeight = 44.0
        
        if let w = UIApplication.shared.keyWindow {
            self.navHeight = self.navHeight + w.safeAreaInsets.top
        }
        self.view.addSubview(self.inputV)
        let height = 90.0
        let y = self.view.frame.height - height - self.navHeight
        self.inputV.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)

        self.chatListView = self.imSdk?.creatChatView(aChatId: self.aChatId)
        
        if let v = self.chatListView {
            v.backgroundColor = .white
            v.setDelegate(delegate: self)
            self.view.addSubview(v)

            v.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: y)
//            v.snp_makeConstraints { make in
//                make.left.top.right.equalToSuperview()
//                make.bottom.equalTo(self.inputV.snp_top)
//            }
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        
        let btn1=UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        btn1.setTitle("发消息", for: .normal)
        btn1.addTarget(self, action: #selector(sendMessageClick), for: .touchUpInside)
        btn1.setTitleColor(UIColor.blue, for: .normal)
        let item2=UIBarButtonItem(customView: btn1)
        
        let btn2=UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        btn2.setTitle("Maker", for: .normal)
        btn2.addTarget(self, action: #selector(markerClick), for: .touchUpInside)
        btn2.setTitleColor(UIColor.blue, for: .normal)
        let item3=UIBarButtonItem(customView: btn2)
        
        let btn3 = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        btn3.setTitle("副标题", for: .normal)
        btn3.addTarget(self, action: #selector(subTitleClick), for: .touchUpInside)
        btn3.setTitleColor(UIColor.blue, for: .normal)
        let item4=UIBarButtonItem(customView: btn3)
        
        self.navigationItem.rightBarButtonItems = [item2,item3, item4];


//
//        self.navigationItem.leftBarButtonItems = [item4];
        
    }
    
    var keyBoardHeight = 0.0
    @objc private func keyboardWillShow(notification: Notification) {
        if self.keyBoardHeight != 0 {
            return
        }
        let info: NSDictionary? = notification.userInfo as NSDictionary?
        var keyBoardH = 0.0
        if let f = info {
            let keyValue = f.object(forKey: "UIKeyboardFrameEndUserInfoKey")
            let keyRect = (keyValue as AnyObject).cgRectValue
            let height = keyRect?.size.height
            keyBoardH = height ?? 0.0
        }
        
        let inset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardH, right: 0)
        self.chatListView?.setTableViewContentInset(inset: inset)
        let oldFrame = self.inputV.frame
        let newFrame = CGRect(x: oldFrame.origin.x, y: self.view.frame.height - oldFrame.size.height - keyBoardH, width: oldFrame.size.width, height: oldFrame.size.height)
        
        let safeAreaH: CGFloat = (self.chatListView?.frame.height ?? 0.0) - inset.bottom - inset.top
        let contentH: CGFloat = self.chatListView?.getTableViewContentSize().height ?? 0.0
        let oldOffsetY: CGFloat = self.chatListView?.getTableViewContentOffset().y ?? 0.0
        var newOffsetY: CGFloat = oldOffsetY
        if safeAreaH < contentH {
            var diff: CGFloat = contentH - safeAreaH
            if diff > keyBoardH {
                diff = keyBoardH
            }
            newOffsetY = oldOffsetY + diff
        }
        let newOffset = CGPoint(x: 0, y: newOffsetY)
        self.view.bringSubviewToFront(self.inputV)
        UIView.animate(withDuration: 0.2) {
            self.inputV.frame = newFrame
            self.chatListView?.setTableViewContentOffset(offset: newOffset, animated: false)
        }
        self.keyBoardHeight = keyBoardH
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        let oldFrame = self.inputV.frame
        let newFrame = CGRect(x: oldFrame.origin.x, y: self.view.frame.height - oldFrame.size.height, width: oldFrame.size.width, height: oldFrame.size.height)
        
        let inset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.chatListView?.setTableViewContentInset(inset: inset)
        let safeAreaH: CGFloat = (self.chatListView?.frame.height ?? 0.0) - inset.bottom - inset.top
        let contentH: CGFloat = self.chatListView?.getTableViewContentSize().height ?? 0.0
        let oldOffsetY: CGFloat = self.chatListView?.getTableViewContentOffset().y ?? 0.0
        var newOffsetY: CGFloat = oldOffsetY
        if safeAreaH < contentH {
            var diff: CGFloat = contentH - safeAreaH
            if diff > self.keyBoardHeight {
                diff = self.keyBoardHeight
            }
            newOffsetY = oldOffsetY - diff
        }
        
        let newOffset = CGPoint(x: 0, y: newOffsetY)
        UIView.animate(withDuration: 0.2) {
            self.inputV.frame = newFrame
            self.chatListView?.setTableViewContentOffset(offset: newOffset, animated: false)
        }
        self.keyBoardHeight = 0.0
    }

    // MARK: -

    @objc private func sendMessageClick() {
        let vc = TMSendMessageViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.aChatId = self.aChatId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 设置会话标识
    @objc private func markerClick() {
        let value = Int(arc4random()%47) + 1
        let image = UIImage.init(named: "head_" + String(value))
        
        if let data = image?.pngData() {
//            let userProfile = UserProfile(avatar: data, format: "jpg", name: "小胖子")
//            let model = UserInfoModel(aUid: aUids.first ?? "", profile: userProfile)
//            self.kit?.setUserInfo(userInfos: [model])
            
            let marker = IMConversationMarker(aChatId: self.aChatId, icon: IMAvatar(data: data, format: "jpg"))
            self.viewModel?.setConversationMarker(markers: [marker])
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func subTitleClick() {
        
        let vc: TMInputViewController = TMInputViewController()
        vc.doneBlock = { [weak self] text in
            guard let self = self else {
                return
            }
            
            let subTitle = IMConversationSubTitle(aChatId: self.aChatId, subTitle: text)
            self.viewModel?.setConversationSubTitle(subTitles: [subTitle])
            self.navigationController?.popViewController(animated: true)
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onFileMessageClick(aMid: String, preView: IMFilePreView) {
        let vc: TMFilePreController = TMFilePreController()
        vc.preView = preView
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func onButtonMessageClick(aMid: String, buttonId: String) {
        print("did click button message with buttonId: \(buttonId)")
        if let data = buttonId.data(using: .utf8), let json = try? JSONSerialization.jsonObject(with: data) {
            if let jsonObj = json as? [String: Any] {
                let type = jsonObj["type"] as? Int ?? 0
                if type == 21 { // system notice message don`t to disbaleCardMessage
                    return
                }
            }
        }
        self.imSdk?.disableCardMessage(aMid: aMid, buttonIds: [buttonId])
    }
    
    func onImageMessageClick(aMid: String, preView: IMImageBrowserView, selectImageInfo: TMMImageSelectViewInfo) {
        if self.inputV.isFirstResponder {
            self.inputV.resignFirstResponder()
        }
        let vc = TMImageBrowserViewController()
        vc.imageBrowserView = preView
        vc.viewFrame = selectImageInfo.viewFrame;
        vc.image = selectImageInfo.image;
        vc.screenShopImage = UIApplication.shared.keyWindow?.screenshotsImage()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func onCloseKeyBoard() {
        self.inputV.endEditing(true)
    }
    
    func onShowCustomMessageView(aMid: String, body: String, handleCustomView: ((UIView) -> ())?, tapCustomView: ((UIView) -> ())?) {
        let sendView = TMCostomizeView(frame: CGRect(x: 0, y: 0, width: UIDevice.YH_Width * 0.8, height: 80))
        sendView.aMid = aMid
        sendView.restorationIdentifier = aMid
        sendView.timeLbl.text = aMid + body
        let tapTwoGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.whenTapTwoClick(gesture:)))
        tapTwoGestureRecognizer.view?.restorationIdentifier = aMid
        sendView.addGestureRecognizer(tapTwoGestureRecognizer)

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.whenLongClick(gesture:)))
        sendView.addGestureRecognizer(longPress)

        self.tapMap[aMid] = tapCustomView

        if let closure = handleCustomView {
            closure(sendView)
        }
    }
    
    @objc private func whenLongClick(gesture: UIGestureRecognizer) {
        print("业务层长按手势来了")
    }
    
    func onMiddleMessageClick(aMid: String, tmpId: String, buttonId: String) {
        print("当前点击：\(buttonId)")
    }
    
    func onNoticeMessageClick(aMid: String, buttonId: String) {
        print("当前点击通知消息：\(buttonId)")
    }
    
    // 仅对当前用户删除该消息
    func onDeleteMessageForMe(aMid: String, senderAUid: String) {
        let tipAlert = UIAlertController(title: "Tips", message: "Confirm to delete this Message for me?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
            self?.imSdk?.deleteMessages(aMids: [aMid], success: nil, fail: nil)
        }
        tipAlert.addAction(cancelAction)
        tipAlert.addAction(deleteAction)
        self.present(tipAlert, animated: true)
    }
    
    // 对所有前用户删除该消息
    func onDeleteMessageForEveryOne(aMid: String, senderAUid: String) {
        let tipAlert = UIAlertController(title: "Tips", message: "Confirm to delete this Message for everyone?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
            self?.imSdk?.retractMessages(aMids: [aMid], success: nil, fail: nil)
        }
        tipAlert.addAction(cancelAction)
        tipAlert.addAction(deleteAction)
        self.present(tipAlert, animated: true)
    }
    
}

extension TMChatDetailController: QMUITextViewDelegate {
    func textViewShouldReturn(_ textView: QMUITextView!) -> Bool {
        self.sendTextClick()
        return true
    }

    private func sendTextClick() {
        if self.inputV.text.count > 0 {
            let mid = IMSDKMessageId.create(uid: "f1ab109be266e394")
            self.imSdk?.sendTextMessage(aChatId: self.aChatId, aMid: mid, content: self.inputV.text)
            self.inputV.text = nil
        }
    }
}
