//
//  UserData.swift
//  swiftavfcidetector2
//
//  Created by Yoshizawa Minoru on 2017/02/24.
//  Copyright © 2017年 Yoshizawa Minoru. All rights reserved.
//

import UIKit


class UserData: NSObject {
    
    var user_id:String = ""
    var name:String = ""
    var gender:Int = 0
    var age:Int = 0
    var comment:String = ""
    var profImg:UIImage? = nil
    
    init(user_id:String, name:String, gender:Int, age:Int, comment:String, profImg:UIImage) {
        self.user_id = user_id
        self.name = name
        self.gender = gender
        self.age = age
        self.comment = comment
        self.profImg = profImg
        
        super.init()
    }
    
    override init(){
        
    }
    
    
    //Setter
    
    func setUserId(str:String){
        self.user_id = str
    }
    
    func setName(str:String){
        self.name = str
    }
    
    func setGender(num:Int){
        self.gender = num
    }
    
    func setAge(num:Int){
        self.age = num
    }
    
    func setComment(str:String){
        self.comment = str
    }
    
    func setProfImg(obj:UIImage){
        self.profImg = obj
    }
    
    
    //Getter
    
    func getUserId() -> String {
        return self.user_id
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getGender() -> Int {
        return self.gender
    }
    
    func getAge() -> Int {
        return self.age
    }
    
    func getComment() -> String {
        return self.comment
    }
    
    func getProfImg() -> UIImage {
        return self.profImg!
    }
    
}
