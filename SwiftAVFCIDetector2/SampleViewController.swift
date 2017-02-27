//
//  SampleViewController.swift
//  swiftavfcidetector2
//
//  Created by 松浦 雅人 on 2017/02/23.
//  Copyright © 2017年 Yoshihisa Nitta. All rights reserved.
//

import UIKit



class SampleViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    var detector: CIDetector! = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
    var detect: detectFace? = detectFace()
    
    var count:Int = 1
    
    @IBAction func pushBtn(_ sender: Any) {
        
        if(count>6){
            count = 1
        }
        
        let img: UIImage = UIImage(named: "\(count).jpg")!
        
        imgView.image = self.detect!.detectFace2(img, detector: self.detector)
        //imgView.image = img
        count += 1
        
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //imgProcess.setXML("haarcascade_frontalface_alt")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

