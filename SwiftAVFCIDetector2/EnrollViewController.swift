//
//  EnrollViewController.swift
//  swiftavfcidetector2
//
//  Created by Yoshizawa Minoru on 2017/02/24.
//  Copyright © 2017年 Yoshizawa Minoru. All rights reserved.
//

import UIKit


class EnrollViewController: UIViewController {


    @IBOutlet weak var label_state: UILabel!
    
    @IBOutlet weak var btn_reset: UIButton!
    @IBOutlet weak var btn_send: UIButton!
    
    @IBOutlet weak var form_name: UITextField!
    @IBOutlet weak var form_age: UITextField!
    @IBOutlet weak var form_comment: UITextField!
    
    @IBOutlet weak var seg_gender: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        btn_reset.tag = 1
        btn_reset.addTarget(self, action: #selector(self.tappedBtn), for: .touchUpInside)
        btn_send.tag = 2
        btn_send.addTarget(self, action: #selector(self.tappedBtn), for: .touchUpInside)
        
        //form_age.keyboardType = UIKeyboardType.numberPad
        
        if(Config.sharedInstance.isEnrolled()){
            //会員登録済み
            label_state.text = "会員ID:" + Config.sharedInstance.user_id
        }else{
            //未会員
            label_state.text = "未登録"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //モーダルを閉じる
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true) { 
            
        }
    }
    
    //キーボードが出ている状態で、キーボード以外をタップしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(form_name.isFirstResponder || form_age.isFirstResponder || form_comment.isFirstResponder){
            form_name.resignFirstResponder()
            form_age.resignFirstResponder()
            form_comment.resignFirstResponder()
        }
    }
    
    internal func tappedBtn(sender: UIButton){
        switch sender.tag {
        case 1:
           label_state.text = "未登録"
           Config.sharedInstance.resetConfig()
            
        case 2:
            
            //let predicate = NSPredicate(format: "SELF MATCHES '\\\\d+$'")
            //let predicate = NSPredicate(format: "SELF MATCHES '^[0-9]+$'")
            
            if(!form_name.hasText || !form_age.hasText){
                
                let alert = UIAlertController(
                    title: "エラー",
                    message: "未入力の項目があります。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
            }
            //}else if(predicate.evaluate(with: form_age.text)){
//            }else if Int(form_age.text!) {
//                
//                let alert = UIAlertController(
//                    title: "エラー",
//                    message: "年齢は半角数字で入力してください。",
//                    preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default))
//                self.present(alert, animated: true, completion: nil)
//                return
//            }
            
            let userData:UserData = UserData()
            userData.setName(str: form_name.text!)
            userData.setAge(num: Int(form_age.text!)!)
            userData.setGender(num: seg_gender.selectedSegmentIndex + 1)
            userData.setComment(str: form_comment.text!)
            
            let apiCon:APIConnector = APIConnector(activity:self, type:1, object:userData)
            apiCon.execute()
            
        default:
            
            break
        }
        
    }

    func reDicision(){
        if(Config.sharedInstance.isEnrolled()){
            //会員登録済み
            label_state.text = "会員ID:" + Config.sharedInstance.user_id
        }else{
            //未会員
            label_state.text = "未登録"
        }
    }
    
}
