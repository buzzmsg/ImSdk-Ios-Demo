//
//  TMFilePreController.swift
//  IMSDKDemo
//
//  Created by Joey on 2022/10/13.
//

import UIKit
import IMSdk

class TMFilePreController: UIViewController {

    
    var preView: FilePreView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let pView = preView {
            
            self.view.addSubview(pView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.preView?.frame = self.view.bounds
    }
    
    func statusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    func navigationBarHeight() -> CGFloat {
        return 44.0
    }
    
    func navigationFullHeight() -> CGFloat {
        return self.statusBarHeight() + self.navigationBarHeight()
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
