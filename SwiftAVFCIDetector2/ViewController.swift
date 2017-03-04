//
//  ViewController.swift
//  SwiftAVFCIDetector
//
//  Created by Yoshizawa Minoru on 2016/06/21.
//  Copyright © 2016年 Yoshizawa Minoru. All rights reserved.
//

import UIKit
import AVFoundation

//prepareVideoで動画を撮り続けて、detectFlgが立った時に顔認識をするプログラム
class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var detector: CIDetector!
    var maskImage: UIImage!
    var startDate: Date!//開始時間の取得
    
    var mySession: AVCaptureSession!
    var myCamera: AVCaptureDevice!
    var myVideoInput: AVCaptureDeviceInput!
    var myVideoOutput: AVCaptureVideoDataOutput!
    var detectFlag: Bool = false
    var rangeBox:[CGRect] = []
    var flag:Bool = false
    var iFSB:imageFromSampleBuffer? = imageFromSampleBuffer()
    var detect: detectFace? = detectFace()
    var detectPosition_x:CGFloat!
    var detectPosition_y:CGFloat!
    var buttonWidth:CGFloat!
    var buttonHeight:CGFloat!
    var count = 0
    var imageSize:CGSize!
    var btnFlg:Bool = false
    var faceFeature: FaceFeature? = FaceFeature()
    let Button = UIButton()
    
    //ボタンとの関連づけ
    @IBOutlet weak var myImageView: UIImageView!
//    @IBAction func tapStart(_ sender: AnyObject) {
//        //スレッドを実行する（常時実行状態にする
//        mySession.startRunning()
//    }
//    @IBAction func tapStop(_ sender: AnyObject) {
//        mySession.stopRunning()
//    }
//    @IBAction func tapDetect(_ sender: AnyObject) {
//        //detectFlgを反転する
//        detectFlag = !detectFlag
//    }
    
    //撮影時のカメラの向きを補正？
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        print("captureOutput:didOutputSampleBuffer:fromConnection)")
        if connection.isVideoOrientationSupported {
            connection.videoOrientation = AVCaptureVideoOrientation.portrait
        }
        //バックグラウンドで起動する（メインスレッド）、tapDetectボタンを押してdetectFlgが立った時に顔認識を実行する
        DispatchQueue.main.async(execute: {
            //dispatch_sync(dispatch_get_main_queue(), {
            let image = self.iFSB!.imageFromSampleBuffer(sampleBuffer)
            if self.detectFlag {
                //detectFace関数を使用（imageViewを顔認識線を描画した画像に置き換える）
                self.myImageView.image = self.detect!.detectFace(image,detector: self.detector,maskImage: self.maskImage)
                
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
                
                if(appDelegate.faceCount == 0){
                    
                    if(self.btnFlg == true){
                        //self.view.viewWithTag(99+self.count)?.removeFromSuperview()
                    }
                    
                }else{
                
                //self.view.viewWithTag(99+self.count)?.removeFromSuperview()
                
                //let Button = UIButton()
                self.btnFlg = true
           
                
                
                if(appDelegate.detectPosition_x != nil){
                    self.detectPosition_x = appDelegate.detectPosition_x!
                    self.detectPosition_y = appDelegate.detectPosition_y!
                    self.buttonWidth = appDelegate.tagButtonSize_x!
                    self.buttonHeight = appDelegate.tagButtonSize_y!
                    self.imageSize = appDelegate.detectFaceImageSize!
                    
                //print("\(appDelegate.message)****************")
                
                
                // ボタンのX,Y座標.
                let posX: CGFloat = self.detectPosition_x * (self.view.frame.size.width/self.imageSize!.width) + self.myImageView.frame.minX + appDelegate.faceSizeHeight!/10
                let posY: CGFloat = self.detectPosition_y * (self.view.frame.size.height/self.imageSize!.height) - self.myImageView.frame.minY - appDelegate.faceSizeHeight!/2.2
                
                print("\(image.size.width/self.imageSize!.width)*********")
                    
                    if(self.buttonWidth > 300){
                        self.buttonWidth = 300
                        self.buttonHeight = 75
                    }
                
                    print("buttonWidth = \(self.buttonWidth)")
                    print("buttonHight = \(self.buttonHeight)")
                    
                    
                // ボタンの設置座標とサイズを設定する.
                self.Button.frame = CGRect(x: posX, y: posY, width: self.buttonWidth, height: self.buttonHeight)
                
                let buttonImageDefault :UIImage? = UIImage(named: "goodIcon2.png")//ボタンの画像
                //let buttonImageSelected :UIImage? = UIImage(named:"btn_selected")//押された時のボタンの画像
                //Button.setImage(buttonImageDefault!, for: UIControlState.highlighted)
                self.Button.setBackgroundImage(buttonImageDefault!, for: UIControlState.normal)
                // ボタンの背景色を設定.
                self.Button.backgroundColor = UIColor.clear
                
                // ボタンの枠を丸くする.
                self.Button.layer.masksToBounds = true
                
                // コーナーの半径を設定する.
                self.Button.layer.cornerRadius = 20.0
                
                // タイトルを設定する(通常時).
                //self.Button.setTitle("いいね！", for: .normal)
                self.Button.setTitleColor(UIColor.black, for: .normal)
                
                // タイトルを設定する(ボタンがハイライトされた時).
                self.Button.setTitle("THANK YOU!", for: .highlighted)
                //Button.setTitleColor(UIColor.black, for: .highlighted)
                
                // ボタンにタグをつける.
                self.Button.tag = 100+self.count
                self.count += 1
                
                self.faceFeature?.leftEye = appDelegate.leftEyePositionData!
                self.faceFeature?.rightEye = appDelegate.rightEyePositionData!
                self.faceFeature?.mouth = appDelegate.mouthPositionData!
                    print("1: \(self.faceFeature?.leftEye)")
                self.Button.addTarget(self, action: #selector(self.FaceFeatureSender), for: .touchUpInside)
                    
                // ボタンをViewに追加.
                //self.view.addSubview(self.Button)
                    }
                }
                
                
//                button.setImage(self.detect!.detectFace(image,detector: self.detector,maskImage: self.maskImage), forState: .Normal)
//                //button.drawRect(rect)
//                button.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
//                button.layer.position = CGPoint(x: self.view.frame.width/2, y:200)
//                self.view.addSubview(button)
                
            } else {
                //detectFlgが立ってるとこっちには入らない
                self.myImageView.image = image
            }
        })
    }
    
    //ビデオ撮影用の関数、ビデオを撮り続ける
    func prepareVideo() {
        mySession = AVCaptureSession()
        mySession.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()
        for device in devices! {
            if ((device as AnyObject).position == AVCaptureDevicePosition.back) {
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
            //myVideoOutput.setSampleBufferDelegate(self,queue:dispatch_queue_create("myqueue",nil))
            myVideoOutput.alwaysDiscardsLateVideoFrames = true
            if (mySession.canAddOutput(myVideoOutput)) {
                //セッションに出力先を追加
                mySession.addOutput(myVideoOutput)
            } else {
                print("cannot add output to session")
            }
            
            /* // preview background
             let myVideoLayer = AVCaptureVideoPreviewLayer(session: mySession)
             myVideoLayer.frame = view.bounds
             myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
             view.layer.insertSublayer(myVideoLayer,atIndex:0)
             */
            //カメラが使えないエラー処理
        } catch let error as NSError {
            print("cannot use camera \(error)")
        }
    }
    
    func FaceFeatureSender() {
        let apiCon:APIConnector = APIConnector(activity:self, type:2, object: self.faceFeature!)
        apiCon.execute()
        if(apiCon.type == 2){
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.Button)
        detectFlag = !detectFlag
        detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        maskImage = UIImage(named: "hukidashi.png")
        startDate = Date()
        prepareVideo()
        mySession.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

