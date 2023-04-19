//
//  TMImageBrowserViewController.swift
//  IMSDKDemo
//
//  Created by oceanMAC on 2022/10/13.
//

import UIKit
import IMSDK

class TMImageBrowserViewController: UIViewController, IMImageBrowserViewDelegate {

    var imageBrowserView: IMImageBrowserView?  //展示资源的view
    
    
    private var placeholderBackgroundView: UIView? //手势滑动看到下面的view
    private var placeholderImgView: UIImageView?//进入TMImageBrowserViewController看到的放大动画
    private var screenShopImageView: UIImageView?//手势滑动看到下面的image，因为push控制器不能穿透看到上一个控制器的内容所以截屏了上一个控制器作为背景，那么滑动看到的背景就被认为是上一个控制器的界面

    @objc var viewFrame: CGRect = .zero //点击跳转到TMImageBrowserViewController时点击的那个图片在window上的frame，为了做放大缩小动画用的
    @objc var image: UIImage? //是上一个控制器点击的图片，做放大缩小用的
    
    private var dragImageFrame: CGRect = .zero
    @objc var screenShopImage: UIImage? //截取的上一个控制器的界面，做TMImageBrowserViewController的背景
    
    private lazy var countLbl: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.imageBrowserView?.frame = self.view.bounds
        self.countLbl.frame = CGRect(x: 0, y: 88, width: self.view.frame.size.width, height: 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "图片预览"
        
        self.view.backgroundColor = UIColor.white
        
        //先让数据初始化
        if let pView = imageBrowserView {
            pView.isHidden = true
            self.view.addSubview(pView)
            pView.setDelegate(delegate: self)
        }
        
        //添加背景
        placeholderImgView = UIImageView()
        placeholderImgView?.contentMode = .scaleAspectFit
        view.addSubview(placeholderImgView!)
        view.addSubview(self.countLbl)
        
        self.showPlaceholderView()
        
    }
    
    func showPlaceholderView() {
        
         placeholderImgView?.image = self.image
         placeholderImgView?.frame = self.viewFrame
                 
        
        /*
         If the image view referenced by the chat message is not in the interface, the browser view is gradually displayed when the referenced image is clicked, and the transition animation for zooming in is not performed
         */
        if self.image == nil {
            // warning !!!
            self.imageBrowserView?.showWithAnimation()
            
            self.placeholderImgView?.isHidden = true
            self.imageBrowserView?.isHidden = false
            return
        }
        
        
         UIView.animate(withDuration: 0.2) {
             self.placeholderImgView?.frame = self.view.bounds
         } completion: { finish in
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                 self.placeholderImgView?.isHidden = true
                 self.imageBrowserView?.isHidden = false
             }
         }
     }
    
    func hidePlaceholderView() {
                
        placeholderImgView?.frame = self.dragImageFrame
        placeholderImgView?.isHidden = false

         UIView.animate(withDuration: 0.2) {
             self.placeholderImgView?.frame = self.viewFrame
             self.placeholderImgView?.layer.cornerRadius = 10
             self.placeholderImgView?.alpha = 0.0

             self.placeholderBackgroundView?.alpha = 0.0

         } completion: { finish in
             
             self.navigationController?.popViewController(animated: false)
         }
     }
    
    // MARK: - IMImageBrowserViewDelegate
    
    //拖拽预览图片松手后调用
    func finish(scrollFrame: CGRect, color: UIColor, alpha: CGFloat) {
        self.imageBrowserView?.isHidden = true

        if self.screenShopImageView == nil {
            self.screenShopImageView = UIImageView(image: self.screenShopImage)
            self.screenShopImageView?.frame = self.view.bounds
            self.view.addSubview(self.screenShopImageView!)
        }

        if self.placeholderBackgroundView == nil {
            self.placeholderBackgroundView = UIView(frame: self.view.bounds)
            self.view.addSubview(self.placeholderBackgroundView!)
        }

        self.placeholderBackgroundView?.backgroundColor = color
        self.placeholderBackgroundView?.alpha = alpha

        if let plac: UIView = self.placeholderImgView {
            self.view.bringSubviewToFront(plac)
        }
        self.dragImageFrame = scrollFrame
        self.hidePlaceholderView()
    }
    
    func scrollMedia(currentIdx: Int, totalCount: Int) {
        self.countLbl.text = "\(currentIdx)/\(totalCount)"
        print("当前第\(currentIdx)页，总共\(totalCount)页")
    }
    
    func mediaLongPress(browserVo: TMMImageBrowVo) {
        print("长按当前资源手势被响应")
    }
    func mediaClick(hidden: Bool, browserVo: TMMImageBrowVo) {
        self.countLbl.isHidden = hidden
    }
    
    func syncOriginalDownloadStatus(browserVo: TMMImageBrowVo) {
        print("下载原图状态变化")
    }

}
