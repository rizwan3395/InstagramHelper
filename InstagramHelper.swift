//
//  InstagramHelper.swift
//  CountryNaturalBeef
//
//  Created by Muhamad Rizwan on 09/11/2018.
//  Copyright © 2018 Muhamad Rizwan. All rights reserved.
//

import UIKit
import Foundation

class InstagramHelper: NSObject, UIDocumentInteractionControllerDelegate {
    
    private let kInstagramURL = "instagram://den3079"
    private let kUTI = "com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.igo"
    private let kAlertViewTitle = "Error"
    private let kAlertViewMessage = "Please install the Instagram application"
    
    var documentInteractionController = UIDocumentInteractionController()
    
    // singleton manager
    class var sharedManager: InstagramHelper {
        struct Singleton {
            static let instance = InstagramHelper()
        }
        return Singleton.instance
    }
    

    func postImageToInstagramWithCaption(imageInstagram: UIImage, instagramCaption: String, controller: UIViewController) {
        // called to post image with caption to the instagram application
        
        let instagramURL = URL(string: kInstagramURL)
        
        DispatchQueue.main.async {
            
            if UIApplication.shared.canOpenURL(instagramURL!) {
                
                let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(self.kfileNameExtension)
                if let jpegData = UIImageJPEGRepresentation(imageInstagram, 1.0) {
                    do {
                        try jpegData.write(to: URL(fileURLWithPath: jpgPath), options: .atomicWrite)
                        
                    } catch {
                        print("write image failed")
                    }
                }else {
                    let jpegData = UIImagePNGRepresentation(imageInstagram)
                    do {
                        try jpegData?.write(to: URL(fileURLWithPath: jpgPath), options: .atomicWrite)
                        
                    } catch {
                        print("write image failed")
                    }
                }
    //            let rect = CGRect(x: 0, y: 0, width: 612, height: 612)
                let fileURL = NSURL.fileURL(withPath: jpgPath)
                self.documentInteractionController.url = fileURL
                self.documentInteractionController.delegate = self
                self.documentInteractionController.uti = self.kUTI
                
                // adding caption for the image
                self.documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
                self.documentInteractionController.presentOpenInMenu(from: controller.view.frame, in: controller.view, animated: true)

            } else {
                
                // alert displayed when the instagram application is not available in the device
                Utility.showAlert("", message: self.kAlertViewMessage, controller: controller)
            }
        }
    }
}
