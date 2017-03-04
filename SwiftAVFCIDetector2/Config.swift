//
//  Config.swift
//  swiftavfcidetector2
//
//  Created by Yoshizawa Minoru on 2017/02/24.
//  Copyright © 2017年 Yoshizawa Minoru. All rights reserved.
//

import Foundation


class Config :NSObject {
    
    //シングルトン化
    static let sharedInstance = Config()
    
    var userDefaults = UserDefaults.standard

    var user_id:String = ""
    
    
    
    private override init() {
        
    }
    
    //会員登録済みか判定(必ず実行すること)
    func isEnrolled() -> Bool {
        
        if (userDefaults.object(forKey: "user_id") == nil) {
            return false
        }else{
            self.user_id = userDefaults.string(forKey: "user_id")!
            return true
        }
    }
    
    //会員登録完了時に呼び出し
    func enrollComplete(user_id:String){
        self.user_id = user_id
        syncroData()
    }
    
    //データを本体に保存
    func syncroData() {

        userDefaults.set(self.user_id, forKey: "user_id")
        userDefaults.synchronize()
    }

    //リセット
    func resetConfig() {
        
        self.user_id = ""
        userDefaults.removeObject(forKey: "user_id")
        userDefaults.synchronize()
    }

}
