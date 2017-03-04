//
//  CaptureViewController.swift
//  swiftavfcidetector2
//
//  Created by Yoshizawa Minoru on 2017/02/26.
//  Copyright © 2017年 Yoshizawa Minoru. All rights reserved.
//

import UIKit
import AVFoundation


class CaptureViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
    @IBOutlet weak var camView: UIImageView!
    
    @IBOutlet weak var label_count: UILabel!
    

    
    var detector: CIDetector!
    var mySession: AVCaptureSession!
    var myCamera: AVCaptureDevice!
    var myVideoInput: AVCaptureDeviceInput!
    var myVideoOutput: AVCaptureVideoDataOutput!
    var iFSB:imageFromSampleBuffer? = imageFromSampleBuffer()
    var detect: detectFace? = detectFace()
    
    var capFlag:Bool = false
    var featureArray:[FaceFeature] = [FaceFeature]()
    var count:Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        prepareVideo()
        
        camView.translatesAutoresizingMaskIntoConstraints = true
        camView.frame = CGRect(x:0, y:Int(DeviceSize.screenHeight()/3), width:Int(DeviceSize.screenWidth()), height:Int(DeviceSize.screenHeight()/3)*2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //撮影ボタン押下時
    @IBAction func push_capture(_ sender: Any) {
        if(count>0){
            self.capFlag = true
        }
    }
    
    //SKIPボタン押下時
    @IBAction func push_skip(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
        }
    }
    
    //detectFaceで処理後に呼ばれる
    //  (i)撮影ボタン押された かつ　顔検出あり => 撮影数カウント＆FaceFeatureを配列へ格納
    //  (ii)　撮影ボタン押下なし または 撮影ボタン押されたが顔検出なし => スルー
    func noticeFeature(ff: FaceFeature?){
        
        if(ff != nil){
            count -= 1
            featureArray.append(ff!)
            if(count>0){
                label_count.text = "\(count)/3"
                
            }else if(count == 0){
                label_count.text = "完了！"
                mySession.stopRunning()
                completeCapture()
            }
            
        }else{
            
            
        }
    }
    
    //3回撮影完了後に呼ばれる
    //平均値算出＆POST
    func completeCapture(){
        var left:CGPoint
        var right:CGPoint
        var mouth:CGPoint
        var sum_l_x:CGFloat = 0
        var sum_l_y:CGFloat = 0
        var sum_r_x:CGFloat = 0
        var sum_r_y:CGFloat = 0
        var sum_m_x:CGFloat = 0
        var sum_m_y:CGFloat = 0
        
        //平均値算出
        for tmp in featureArray {
            left = tmp.getLeftEye()
            right = tmp.getRightEye()
            mouth = tmp.getMouth()
            
            sum_l_x = sum_l_x + left.x
            sum_l_y = sum_l_y + left.y
            sum_r_x = sum_r_x + right.x
            sum_r_y = sum_r_y + right.y
            sum_m_x = sum_m_x + mouth.x
            sum_m_y = sum_m_y + mouth.y
        }
        
        let leftAvg:CGPoint = CGPoint(x:sum_l_x/CGFloat(featureArray.count), y:sum_l_y/CGFloat(featureArray.count))
        let rightAvg:CGPoint = CGPoint(x:sum_r_x/CGFloat(featureArray.count), y:sum_r_y/CGFloat(featureArray.count))
        let mouthAvg:CGPoint = CGPoint(x:sum_m_x/CGFloat(featureArray.count), y:sum_m_y/CGFloat(featureArray.count))
        
        let ff:FaceFeature = FaceFeature()
        ff.setLeftEye(obj: leftAvg)
        ff.setRightEye(obj: rightAvg)
        ff.setMouth(obj: mouthAvg)
        
        //POST
        let apiCon:APIConnector = APIConnector(activity:self, type:3, object:ff)
        apiCon.execute()
        
    }
    
    //APIでPOST後に呼ばれる
    //失敗したら状態リセット
    func successedPost(result: Bool) {
        
        if(result){
            //POST成功
            //self.dismiss(animated: true) {
                
            //}
        }else{
            //POST失敗
            featureArray.removeAll()
            count = 3
            label_count.text = "\(count)/3"
            mySession.startRunning()
        }
        
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        if connection.isVideoOrientationSupported {
            connection.videoOrientation = AVCaptureVideoOrientation.portrait
        }
        
        DispatchQueue.main.async(execute: {

            let image = self.iFSB!.imageFromSampleBuffer(sampleBuffer)

            if(self.capFlag){
                //撮影ボタン押下時
                self.camView.image = self.detect!.detectFaceEnroll(image, detector:self.detector, activity:self, flag:true)
                self.capFlag = false
            }else{
                //通常時
                self.camView.image = self.detect!.detectFaceEnroll(image, detector:self.detector, activity:self, flag:false)
            }
            
        })
    }
    
    
    func prepareVideo() {
        mySession = AVCaptureSession()
        mySession.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()
        for device in devices! {
            if ((device as AnyObject).position == AVCaptureDevicePosition.front) {
                myCamera = device as! AVCaptureDevice
            }
        }
        do {
            //ビデオの入力元を指定する
            myVideoInput = try AVCaptureDeviceInput(device: myCamera)
            if (mySession.canAddInput(myVideoInput)) {
                //セッションに入力先を追加
                mySession.addInput(myVideoInput)
            } else {
                print("cannot add input to session")
            }
            
            //ビデオの出力先を指定する
            myVideoOutput = AVCaptureVideoDataOutput()
            //ビデオへの出力はBGRAを指定する
            myVideoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable : Int(kCVPixelFormatType_32BGRA)]
            myVideoOutput.setSampleBufferDelegate(self,queue:DispatchQueue.main)

            myVideoOutput.alwaysDiscardsLateVideoFrames = true
            if (mySession.canAddOutput(myVideoOutput)) {
                //セッションに出力先を追加
                mySession.addOutput(myVideoOutput)
            } else {
                print("cannot add output to session")
            }
            
            mySession.startRunning()
            
            //カメラが使えないエラー処理
        } catch let error as NSError {
            print("cannot use camera \(error)")
        }
    }

}

