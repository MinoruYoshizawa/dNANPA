//
//  imageFromSampleBuffer.swift
//  SwiftAVFCIDetector2
//
//  Created by 吉澤実 on H28/11/26.
//  Copyright © 平成28年 Yoshihisa Nitta. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class imageFromSampleBuffer{
    
    func imageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> UIImage {
        //サンプルバッファのデータからCGImageRefを生成する
        let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        //ピクセルバッファのベースアドレスをロックする
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))   // Lock Base Address
        //利用するメモリ領域
        let baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)  // Get Original Image Information
        //ピクセルバッファの行あたりのバイト数
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()  // RGB ColorSpace
        //透明度の指定？
        let bitmapInfo = (CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        //上で作った変数を引数にcontextを作成する
        let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        //contextからCGImageRefオブジェクトの作成
        let imageRef = context?.makeImage() // Create Quarts image
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))    // Unlock Base Address
        
        let resultImage: UIImage = UIImage(cgImage: imageRef!)
        
        return resultImage
    }
    
}
