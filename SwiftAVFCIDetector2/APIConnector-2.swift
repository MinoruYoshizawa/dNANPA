//
//  APIConnector.swift
//  swiftavfcidetector2
//
//  Created by Yoshizawa Minoru on 2017/02/24.
//  Copyright © 2017年 Yoshizawa Minoru. All rights reserved.
//

import UIKit


class APIConnector : NSObject {
    
    var type:Int = 0 //シーン選択
    var object:Any //POSTするデータ
    
    var activity:UIViewController
    var indicator = UIActivityIndicatorView()
    var group = DispatchGroup()
    
    var resultState:Int = -1
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    init(activity: UIViewController, type: Int, object: Any){
        //親アクティビティのインスタンス保持 => グルグル表示
        self.activity = activity
        self.type = type
        self.object = object
        
        super.init()
    }
    
    
    //実行する関数（APIへアクセス＆配列へ格納）
    func execute(){
        
        
        //1回APIを叩く
        //        for i in 0..<countryArray.count {
        //            group.enter()
        //            DispatchQueue.global().async {
        //                self.getRateArray(num: i)
        //            }
        //        }
        
        if(self.type==0){
            return
            
        }else if(self.type==1){
            //会員登録
            
            //処理中のグルグルを表示
            showIndicator()
            //ディスパッチエントリー
            group.enter()
            //非同期通信
            DispatchQueue.global().async {
                self.postUserRegist()
            }
            //非同期処理完了
            group.notify(queue: .global()) {
                print("データ取得完了")
                DispatchQueue.main.async {
                    let uivc:EnrollViewController = self.activity as! EnrollViewController
                    uivc.reDicision() //ステータス再判定
                    self.endIndicator()
                }
            }
        }else if(self.type==2){
            //ポジションPOST
            //処理中のグルグルを表示
            showIndicator()
            //ディスパッチエントリー
            group.enter()
            //非同期通信
            DispatchQueue.global().async {
                self.postFaceFeature()
            }
            //非同期処理完了
            group.notify(queue: .global()) {
                print("データ取得完了")
                DispatchQueue.main.async {
                    self.endIndicator()
                }
            }
            
        }else if(self.type==3){
            //会員登録者の平均特徴量POST
            //処理中のグルグルを表示
            showIndicator()
            //ディスパッチエントリー
            group.enter()
            //非同期通信
            DispatchQueue.global().async {
                self.postEnrollFaceFeature()
            }
            //非同期処理完了
            group.notify(queue: .global()) {
                print("データ取得完了")
                DispatchQueue.main.async {
                    self.endIndicator()
                }
            }
        }

        
    }
    
    
    //会員登録
    func postUserRegist(){
        
        let baseUrl:String = "http://concierge-apps.lovepop.jp/face/regist_user.php"
        var request = URLRequest(url: URL(string:baseUrl)!)
        
        let userData:UserData = self.object as! UserData

        // set the method(HTTP-POST)
        request.httpMethod = "POST"
        let query = "name=\(userData.getName())&" +
                    "age=\(userData.getAge())&" +
                    "gender=\(userData.getGender())&" +
                    "comment=\(userData.getComment())"
        request.httpBody = query.data(using: String.Encoding.utf8)

        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            } else {
                
                do {
    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:String]

                    print(parsedData)

                    if(parsedData["result"] == "1"){
                        //会員登録成功
                        self.resultState = 1
                        //会員IDを本体に保存
                        Config.sharedInstance.enrollComplete(user_id: parsedData["user_id"]!)
                        
                    }else{
                        //エラー
                        self.resultState = -1
                    }
                    
                    self.group.leave()
                } catch {
                    //エラー処理
                    self.resultState = -1
                    self.group.leave()
                }
            }
            
        })
        
        task.resume()
    }
    
    
    //特徴量をPOSTして検索
    func postFaceFeature(){
        
        let baseUrl:String = "http://concierge-apps.lovepop.jp/face/matching.php"
        var request = URLRequest(url: URL(string:baseUrl)!)
        
        let faceFeature:FaceFeature = self.object as! FaceFeature
        
        // set the method(HTTP-POST)
        request.httpMethod = "POST"
        
        let leftEye:CGPoint = faceFeature.getLeftEye()
        let rightEye:CGPoint = faceFeature.getRightEye()
        let mouthEye:CGPoint = faceFeature.getMouth()
        
        let query = "leftEye_x=\(leftEye.x)&" +
                    "leftEye_y=\(leftEye.y)&" +
                    "rightEye_x=\(rightEye.x)&" +
                    "rightEye_y=\(rightEye.y)&" +
                    "mouth_x=\(mouthEye.x)&" +
                    "mouth_y=\(mouthEye.y)&"
        request.httpBody = query.data(using: String.Encoding.utf8)
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            } else {
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:String]
                    
                    print(parsedData)
                    
                    if(parsedData["result"] == "1"){
                        //成功
                        self.resultState = 1
                        
                        let userData:UserData = UserData()
                        userData.setUserId(str: parsedData["user_id"]!)
                        userData.setName(str: parsedData["name"]!)
                        userData.setAge(num: Int(parsedData["age"]!)!)
                        userData.setGender(num: Int(parsedData["gender"]!)!)
                        userData.setComment(str: parsedData["comment"]!)
                        let img: UIImage = UIImage(named: "lena.jpg")!
                        userData.setProfImg(obj: img)
                        self.appDelegate.matchingUser = userData
                    }else{
                        //エラー
                        self.resultState = 0
                    }
                    
                    self.group.leave()
                } catch {
                    //エラー処理
                    self.resultState = 0
                    self.group.leave()
                }
            }
            
        })
        
        task.resume()
    }

    //会員登録者の平均特徴量POST
    func postEnrollFaceFeature(){
        
        let baseUrl:String = "http://concierge-apps.lovepop.jp/face/regist_feature.php"
        var request = URLRequest(url: URL(string:baseUrl)!)
        
        let faceFeature:FaceFeature = self.object as! FaceFeature
        
        // set the method(HTTP-POST)
        request.httpMethod = "POST"
        
        let leftEye:CGPoint = faceFeature.getLeftEye()
        let rightEye:CGPoint = faceFeature.getRightEye()
        let mouthEye:CGPoint = faceFeature.getMouth()
        
        let query = "leftEye_x=\(leftEye.x)&" +
            "leftEye_y=\(leftEye.y)&" +
            "rightEye_x=\(rightEye.x)&" +
            "rightEye_y=\(rightEye.y)&" +
            "mouth_x=\(mouthEye.x)&" +
            "mouth_y=\(mouthEye.y)&" +
            "user_id=\(Config.sharedInstance.user_id)"
        request.httpBody = query.data(using: String.Encoding.utf8)
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            } else {
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:String]
                    
                    print(parsedData)
                    
                    if(parsedData["result"] == "1"){
                        //成功
                        self.resultState = 1

                    }else{
                        //エラー
                        self.resultState = -1
                    }
                    
                    self.group.leave()
                } catch {
                    //エラー処理
                    self.resultState = -1
                    self.group.leave()
                }
            }
            
        })
        
        task.resume()
    }
    
    
    //グルグル生成＆表示
    func showIndicator() {
        
        // UIActivityIndicatorView のスタイルをテンプレートから選択
        indicator.activityIndicatorViewStyle = .whiteLarge
        // 表示位置
        indicator.center = activity.view.center
        // 色の設定
        indicator.color = UIColor.green
        // アニメーション停止と同時に隠す設定
        indicator.hidesWhenStopped = true
        // 画面に追加
        activity.view.addSubview(indicator)
        // 最前面に移動
        activity.view.bringSubview(toFront: indicator)
        // アニメーション開始
        indicator.startAnimating()
        
    }

    
    func endIndicator() {
        
        if(self.type==1){
            self.indicator.stopAnimating()
            
            if(self.resultState == 1){
                //成功
                let alert = UIAlertController(
                    title: "成功",
                    message: "会員登録が完了しました。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)

            }else{
                //失敗
                let alert = UIAlertController(
                    title: "通信エラー",
                    message: "再度お試しください。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)
            }
            
        }else if(self.type == 2){
            self.indicator.stopAnimating()
            
            if(self.resultState==1){
                //成功
                let alert = UIAlertController(
                    title: "該当あり",
                    message: "名前：" + (appDelegate.matchingUser?.getName())!,
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)
                
            }else if(self.resultState==0){
                //該当なし
                let alert = UIAlertController(
                    title: "該当なし",
                    message: "該当ユーザーがいません。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)
            }
            
        }else if(self.type == 3){
            self.indicator.stopAnimating()
            
            if(self.resultState == 1){
                //成功
                let alert = UIAlertController(
                    title: "成功",
                    message: "登録完了しました。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: {
                    let vc:CaptureViewController = self.activity as! CaptureViewController
                    vc.successedPost(result: true)
                })
                
            }else if(self.resultState == -1){
                //該当なし
                let alert = UIAlertController(
                    title: "エラー",
                    message: "再度お試しください。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)
                let vc:CaptureViewController = activity as! CaptureViewController
                vc.successedPost(result: false)
            }

            
        }
        
    }
    
    
}
