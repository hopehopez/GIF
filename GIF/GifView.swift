//
//  GifView.swift
//  GIF
//
//  Created by 张树青 on 2017/7/11.
//  Copyright © 2017年 zsq. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices
class GifView: UIImageView {
    
    //分解
    class func decodeGif(byUrl url: String?) -> Array<UIImage>?{
        if let gifPath = url {
            
            let gifData = try! Data(contentsOf: URL(fileURLWithPath: gifPath))
            
            let gifDataSource: CGImageSource = CGImageSourceCreateWithData(gifData as CFData, nil)!
            let gifImageCount: Int = CGImageSourceGetCount(gifDataSource)
            var imageArray: [UIImage] = Array();
            for i in 0...gifImageCount-1 {
                let imageref: CGImage? = CGImageSourceCreateImageAtIndex(gifDataSource, i, nil)
                let image: UIImage = UIImage(cgImage: imageref!, scale: UIScreen.main.scale, orientation: UIImageOrientation.up)
                let imageData: Data = UIImagePNGRepresentation(image)!
                var docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentsDirectory = docs[0] as String
                let imagePath: String = documentsDirectory + "/\(i)" + ".png"
                try? imageData.write(to: URL(fileURLWithPath: imagePath), options: .atomic)
                print(imagePath)
                imageArray.append(image)
                
            }
            return imageArray
        }
        return nil
    }
    
    //合成
    class func encodeGif(byImages images: Array<UIImage>) {
        //1. 在Document目录创建gif文件
        let docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDictionary: String = docs[0]
        let gifPath = documentDictionary + "/plane.gif"
        print(gifPath)
        //CFURL
        let url: CFURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, gifPath as CFString, CFURLPathStyle.cfurlposixPathStyle, false)
        let destion: CGImageDestination? = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil)
        
        //2. 设置gif图片属性, 利用图片构建gif
        let cgimagePropertiesDic = [kCGImagePropertyGIFDelayTime as String: 0.1]
        let cgimagePropertiesDestDic = [kCGImagePropertyGIFDictionary as String: cgimagePropertiesDic]
        for cgimage in images{
            CGImageDestinationAddImage(destion!, (cgimage as AnyObject).cgImage!!, cgimagePropertiesDestDic as CFDictionary)
        }//依次为gif图像对象添加每一帧元素
        
        var gifPropertiesDic = Dictionary<String, Any>()
        gifPropertiesDic[kCGImagePropertyColorModel as String] = kCGImagePropertyColorModelRGB//设置图像的彩色空间格式
        gifPropertiesDic[kCGImagePropertyDepth as String] = 16//设置图像的颜色深度
        gifPropertiesDic[kCGImagePropertyGIFLoopCount as String] = 0//执行循环次数
        let gifPropertiesDestDic = [kCGImagePropertyGIFDictionary as String: gifPropertiesDic]
        CGImageDestinationSetProperties(destion!, gifPropertiesDestDic as CFDictionary?)
        
        CGImageDestinationFinalize(destion!)
        
    }
    
    func showGif(named name: String) -> () {
        let path: String? = Bundle.main.path(forResource: name, ofType: "gif")
        let array: [UIImage]? = GifView.decodeGif(byUrl: path)
        if let images = array {
            self.animationImages = images
            self.animationDuration = 5
            self.animationRepeatCount = 0
            self.startAnimating()
        }
    }
    
}
