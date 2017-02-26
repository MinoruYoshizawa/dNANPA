//
//  FaceFeature.swift
//  swiftavfcidetector2
//
//  Created by 松浦 雅人 on 2017/02/26.
//  Copyright © 2017年 Yoshihisa Nitta. All rights reserved.
//

import UIKit


class FaceFeature: NSObject {
    
    var leftEye:CGPoint? = nil
    var rightEye:CGPoint? = nil
    var mouth:CGPoint? = nil
    
    init(leftEye:CGPoint, rightEye:CGPoint, mouth:CGPoint) {
        self.leftEye = leftEye
        self.rightEye = rightEye
        self.mouth = mouth
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    //Setter
    
    func setLeftEye(obj:CGPoint){
        self.leftEye = obj
    }
    
    func setRightEye(obj:CGPoint){
        self.rightEye = obj
    }
    
    
    func setMouth(obj:CGPoint){
        self.mouth = obj
    }
    
    //Getter
    func getLeftEye() -> CGPoint {
        return self.leftEye!
    }
    
    func getRightEye() -> CGPoint {
        return self.rightEye!
    }
    
    func getMouth() -> CGPoint {
        return self.mouth!
    }
}
