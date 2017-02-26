//
//  rotateImage.swift
//  SwiftAVFCIDetector2
//
//  Created by 吉澤実 on H28/11/26.
//  Copyright © 平成28年 Yoshihisa Nitta. All rights reserved.
//

import Foundation
import UIKit

class rotateImage{

    func rotateImage(_ image: UIImage,_ radian: Float) -> UIImage {
    let size: CGSize = image.size
    //画像のサイズを読み込む
    UIGraphicsBeginImageContext(size);
    //コンテキストを作成
    let context = UIGraphicsGetCurrentContext()
    //contextのtransform(位置とか拡大縮小、回転？）を調整、描画する画像の占める領域（サイズ）
    //画像を回転させている,中心を軸に回転
    context?.translateBy(x: size.width/2, y: size.height/2) // rotation center
    //y軸の方向を反転させる↑→　を　↓→
    context?.scaleBy(x: 1.0, y: -1.0) // flip y-coordinate
    context?.rotate(by: CGFloat(M_PI))
    context?.rotate(by: CGFloat(-radian))
    //上で作成したコンテキストデータを取得して描画してると思う、第２引数は描画する領域
    //回転軸の範囲指定もしている
    UIGraphicsGetCurrentContext()?.draw(image.cgImage!, in: CGRect(x: -size.width/2,y: -size.height/2, width: size.width, height: size.height))
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img!
    }
}
