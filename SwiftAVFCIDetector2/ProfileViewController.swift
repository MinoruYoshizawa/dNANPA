//
//  ProfileViewController.swift
//  SwiftAVFCIDetector2
//
//  Created by Yoshizawa Minoru on H29/02/26.
//  Copyright © 平成29年 Yoshizawa Minoru. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nickName: UILabel!
    
    @IBOutlet weak var age: UILabel!
    
    
    @IBOutlet weak var gender: UILabel!
    
    @IBOutlet weak var profileText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileSetting()
    }
    
    func profileSetting() {
        //deligateに渡されたユーザデータからプロフィールを取得する
        let myImage = appDelegate.matchingUser?.profImg
        profileImage.image = myImage
        
        let userNickName = appDelegate.matchingUser?.name
        nickName.text = userNickName
        
        let userAge = appDelegate.matchingUser?.age
        age.text = String(describing: userAge)
        
        let userGender = appDelegate.matchingUser?.gender
        if(userGender == 1){
            gender.text = "男性"
        }else{
            gender.text = "女性"
        }
        
        let userProfileText  = appDelegate.matchingUser?.comment
        profileText.text = userProfileText
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
