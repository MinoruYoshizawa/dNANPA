//
//  detectFace.swift
//  SwiftAVFCIDetector2
//
//  Created by 吉澤実 on H28/11/26.
//  Copyright © 平成28年 Yoshihisa Nitta. All rights reserved.
//

import Foundation
import UIKit

class detectFace{
    
    var rotate: rotateImage? = rotateImage()
    var count:Int = 0
    
    func detectFace(_ image: UIImage, detector: CIDetector, maskImage: UIImage!) -> UIImage {
        
          count = 0
        
        //UIImageをCIImageに変換、CIImageはフィルタをかける時に使うっぽい
        let ciImage:CIImage! = CIImage(image: image)
        let features = detector.features(in: ciImage)
        
        var rect2:CGRect = CGRect()
        var croppedFaceCIImage:CIImage = CIImage()
        var ff:CIFaceFeature = CIFaceFeature()
        
        //多分映像全体の大きさ？
        UIGraphicsBeginImageContext(image.size);
        //無加工画像をコンテキストに書き込んでいる？
        image.draw(in: CGRect(x: 0,y: 0,width: image.size.width,height: image.size.height))
        let context: CGContext = UIGraphicsGetCurrentContext()!
        //レンタリング描画線の細さ指定？
        context.setLineWidth(5.0);
        context.setStrokeColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)

        //ここを読まないとサイズの概念を紐解けない？
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        //人の分だけフィーチャーを取ってくる
        for feature in features as! [CIFaceFeature] {
            
            count += 1
            
            //boundsは顔の範囲
            var rect:CGRect = feature.bounds;
            rect2 = feature.bounds;
            
            croppedFaceCIImage = ciImage.cropping(to: rect)
            croppedFaceCIImage.applying(CGAffineTransform(scaleX: (256/rect.size.width), y: (256/rect.size.height)))
            ff = feature
            
            appDelegate.detectPosition_y = image.size.height - rect.maxY //appDelegateの変数を操作
            appDelegate.detectPosition_x = rect.minX
            
            //origin.xは一番左が０
            print("origin.x:\(rect.origin.x)")
            print("origin.y:\(rect.origin.y)")
            
            //maskサイズを2倍にしてみた
            rect.size.height = rect.size.height/4
            rect.size.width = rect.size.width
            
            appDelegate.tagButtonSize_x = rect.size.width
            appDelegate.tagButtonSize_y = rect.size.height
        
        }
        
        let left256:CGPoint = CGPoint(x:(ff.leftEyePosition.x-rect2.minX)*(256/rect2.size.width), y:(rect2.size.height-(ff.leftEyePosition.y-rect2.minY))*(256/rect2.size.width))
        let right256:CGPoint = CGPoint(x:(ff.rightEyePosition.x-rect2.minX)*(256/rect2.size.width), y:(rect2.size.height-(ff.rightEyePosition.y-rect2.minY))*(256/rect2.size.width))
        let mouth256:CGPoint = CGPoint(x:(ff.mouthPosition.x-rect2.minX)*(256/rect2.size.width), y:(rect2.size.height-(ff.mouthPosition.y-rect2.minY))*(256/rect2.size.width))
        
        print("leftEyePosition x = \(left256.x) y = \(left256.y)")
         print("rightEyePosition x = \(right256.x) y = \(right256.y)")
         print("MouthPosition x = \(mouth256.x) y = \(mouth256.y)")
        
        appDelegate.leftEyePositionData = left256
        appDelegate.rightEyePositionData = right256
        appDelegate.mouthPositionData = mouth256
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        appDelegate.detectFaceImageSize = img!.size
        appDelegate.faceCount = count
        return img!;
    }

}
