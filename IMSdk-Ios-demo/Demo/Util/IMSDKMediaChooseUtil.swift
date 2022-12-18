//
//  IMSDKMediaChooseUtil.swift
//  IMSDKDemo
//
//  Created by on 2022/10/12.
//

import Foundation
import UIKit
import Photos

class IMSDKMediaChooseUtil: NSObject {
    
    static let shared = IMSDKMediaChooseUtil()

    private override init() {}
    
    override func copy() -> Any {
        return self
    }
    
    override func mutableCopy() -> Any {
        return self
    }
    
    typealias MediaChooseComplete = ((Data?, String) -> ())

    private var viewController: UIViewController!
    private var completeClosure: MediaChooseComplete?
    private var completeChooseFileClosure: MediaChooseComplete?

    // MARK: -

    func chooseMedia(viewController: UIViewController, complete: @escaping MediaChooseComplete) {
        self.viewController = viewController
        self.completeClosure = complete
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        
                        self.openImagePickerViewController()
                    }
                }
            }
            return
        }
        
        if status != .authorized {
            
            let message: String = "Allow IMSDKDemo to access your album in Settings > Privacy > Photos"
            let confirmAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            confirmAlertController.addAction(cancelAction)
            viewController.present(confirmAlertController , animated: true, completion: nil)
            return
        }
        
        self.openImagePickerViewController()
    }
    
    
    private func openImagePickerViewController() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let pickerVC = UIImagePickerController()
            pickerVC.sourceType = UIImagePickerController.SourceType.photoLibrary
            pickerVC.delegate = self
            viewController.present(pickerVC , animated: true, completion: nil)
        }
    }
    
    // MARK: -

    func chooseFile(viewController: UIViewController, complete: @escaping MediaChooseComplete) {

        self.viewController = viewController
        self.completeChooseFileClosure = complete
        
        var documentPicker: UIDocumentPickerViewController!
        if #available(iOS 14, *) {
            // iOS 14 & later
            let supportedTypes: [UTType] = [UTType.item]
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)

        } else {
            // iOS 13 or older code
            let supportedTypes: [String] = ["public.item"]
            documentPicker = UIDocumentPickerViewController(documentTypes: supportedTypes, in: .import)
        }
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen

        viewController.present(documentPicker, animated: true, completion: nil)
    }
}


// MARK: -

extension IMSDKMediaChooseUtil: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image = info[.originalImage] as? UIImage
        image = image?.fixedOrientation()
        
        picker.dismiss(animated: true, completion: nil)

        var format: String = "jpg"
        if #available(iOS 11.0, *) {
            if let url: URL = info[.imageURL] as? URL {
                let ary: [String] = url.absoluteString.components(separatedBy: ".")
                if let form: String = ary.last {
                    format = form
                }
            }
        }
        
        DispatchQueue.global().async {
            
            if format == "gif" || format == "GIF" {
            
                if #available(iOS 11.0, *), let asst = info[.phAsset] as? PHAsset {
                    
                    
                    let options = PHImageRequestOptions()
                    options.version = .current
                    options.isNetworkAccessAllowed = true

                    
                    options.isSynchronous = true
                    PHImageManager.default().requestImageData(for: asst, options: options) { (data, str, origin, info) in
                        
                        DispatchQueue.main.async(execute: {
                            
                            if let clos = self.completeClosure {
                                clos(data, format)
                            }
                        })
                    }
                }
                
                return
            }
            
         
            let imgData: Data? = image?.pngData()

            DispatchQueue.main.async {

                if let clos = self.completeClosure {
                    clos(imgData, format)
                }
            }
        }
    }

}


// MARK: -

extension IMSDKMediaChooseUtil:UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

        guard let url = urls.first, let data: Data = try? Data.init(contentsOf: url) else {
            return
        }
        
        var filename = url.lastPathComponent
        if filename.isEmpty {
            filename = "Unknow"
        }
        
        if let clos = self.completeChooseFileClosure {
            clos(data, filename)
        }
    }
}
