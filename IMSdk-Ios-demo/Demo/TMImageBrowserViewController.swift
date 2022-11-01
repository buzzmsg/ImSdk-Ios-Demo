//
//  TMImageBrowserViewController.swift
//  IMSDKDemo
//
//  Created by oceanMAC on 2022/10/13.
//

import UIKit
import IMSdk

class TMImageBrowserViewController: UIViewController {

    var imageBrowserView: TMImageBrowserView?


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.imageBrowserView?.frame = self.view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "图片预览"
        
        self.view.backgroundColor = UIColor.white
        
        if let pView = imageBrowserView {
            self.view.addSubview(pView)
            pView.clickPanGestureCloseVC = { [weak self] in
                guard let self = self else {return}
                self.navigationController?.popViewController(animated: true)
            }
        }
        
//        if let loginInfo = TMUserUtil.getLogin() {
//            self.imageBrowserView = IMSdk.getInstance(ak: loginInfo.ak, env: .alpha).creatImageBrowserView(chatId: self.chatId, currentIndex: self.currentIndex)
//            self.imageBrowserView.backgroundColor = .black
//            self.view.addSubview(self.imageBrowserView)
//            self.imageBrowserView.snp_makeConstraints { make in
//                make.edges.equalToSuperview()
//            }
//        }
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
