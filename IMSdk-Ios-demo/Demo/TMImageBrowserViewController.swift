//
//  TMImageBrowserViewController.swift
//  IMSDKDemo
//
//  Created by oceanMAC on 2022/10/13.
//

import UIKit
import IMSDK

class TMImageBrowserViewController: UIViewController, IMImageBrowserViewDelegate {

    var imageBrowserView: IMImageBrowserView?


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
            pView.setDelegate(delegate: self)
//            pView.clickPanGestureCloseVC = { [weak self] _, _, _ in
//                guard let self = self else {return}
//                self.navigationController?.popViewController(animated: true)
//            }
        }
    }
    
    func finish(scrollFrame: CGRect, color: UIColor, alpha: CGFloat) {
        self.navigationController?.popViewController(animated: true)
    }

}
