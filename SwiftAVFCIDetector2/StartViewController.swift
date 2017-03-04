//
//  StartViewController.swift
//  SwiftAVFCIDetector2
//
//  Created by 吉澤実 on H29/03/04.
//  Copyright © 平成29年 Yoshizawa  Minoru. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var StartImage: UIImageView!
    
    @IBOutlet weak var startTitle: UIImageView!
    
    @IBAction func startButton(_ sender: Any) {
        // process if this is first time to launch this app
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "firstLaunch") {
            
            // 初回起動のみ登録
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "enroll")
            self.present(nextView, animated: true, completion: nil)
            // off the flag to know if it is first time to launch
            defaults.set(false, forKey: "firstLaunch")
        }else{
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "camera")
            self.present(nextView, animated: true, completion: nil)
        }
    }
    
    
    func itemSet() {
        let startImg = UIImage(named: "startImage.jpg")
        StartImage.image = startImg
        let startT = UIImage(named: "title.png")
        startTitle.image = startT
        //let startBtn = UIButton()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemSet()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
