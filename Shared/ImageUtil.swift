//
//  ImageUtil.swift
//  LowLightCamera
//
//  Created by Diep Tran on 29/05/2022.
//

import SwiftUI

class ImageUtil: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        let newImagePNG = image.pngData()
        let saveableImage = UIImage(data: newImagePNG!)
        UIImageWriteToSavedPhotosAlbum(saveableImage!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            print(error)
           
        } else {
            print("Sucess")
        }
    }
}
