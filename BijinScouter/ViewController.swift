//
//  ViewController.swift
//  BijinScouter
//
//  Created by Ryo Kanbayashi on 2015/10/03.
//  Copyright (c) 2015年 ryo_grid. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class ViewController: UIViewController {

    // セッション.
    var mySession : AVCaptureSession!
    // デバイス.
    var myDevice : AVCaptureDevice!
    // 画像のアウトプット.
    var myImageOutput : AVCaptureStillImageOutput!
    
    @IBOutlet weak var point_label: UILabel!
    

    @IBAction func evaluation(sender: UIButton) {
        point_label.text = "hoge"
        
        get_similarity2()
    }
    
    func get_similarity2(){
        let BijinImage = UIImage(named: "japanese_bijin.png")
        let imageData1:NSData = NSData(data:UIImagePNGRepresentation(BijinImage!)!)
        var face_id1:String? = nil
        Alamofire.upload(.POST,
            "https://apius.faceplusplus.com/v2/detection/detect?api_secret=l7PsiUEj1TuF2b5_p369Ai8W6y_BnIsV&api_key=0e5ac228d92bc2c63c11c9aa47752b2a&img",
            headers: nil,
            multipartFormData: { multipartFormData in
                // 文字列データはUTF8エンコードでNSData型に
                //multipartFormData.appendBodyPart(data: "image".dataUsingEncoding(NSUTF8StringEncoding)!, name: "type")
                // バイナリデータ
                // サーバによってはファイル名や適切なMIMEタイプを指定しないとちゃんと処理してくれないかも
                multipartFormData.appendBodyPart(data: imageData1, name: "img", fileName: "japanese_bijin.png", mimeType: "image/png")
            },
            // リクエストボディ生成のエンコード処理が完了したら呼ばれる
            encodingCompletion: { encodingResult in
                switch encodingResult {
                    // エンコード成功時
                case .Success(let upload, _, _):
                    // 実際にAPIリクエストする
                    upload.responseString { str in
                        //print(str.result.value)
                        var casted = str.result.value as NSString?
                        let pattern = "face_id.+[a-z0-9]+.+,"
                        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
                        regex.enumerateMatchesInString(casted! as String, options: NSMatchingOptions.WithoutAnchoringBounds ,range: NSMakeRange(0, casted!.length),
                            usingBlock: {(result: NSTextCheckingResult?, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                                for i in 0...result!.numberOfRanges - 1 {
                                    let range = result!.rangeAtIndex(i)
                                    face_id1 = casted!.substringWithRange(range)
                                    break
                                }
                        })
                        let rep1 = face_id1!.stringByReplacingOccurrencesOfString("face_id\": \"", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                        let rep2 = rep1.stringByReplacingOccurrencesOfString("\",", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                        face_id1 = rep2
                        //print(face_id1)
                        self.get_face_id2(face_id1!)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
        
    }
    
    func get_face_id2(id1 : String){
        let EvalImage = UIImage(named: "i320.jpeg")
        let imageData2:NSData = NSData(data:UIImagePNGRepresentation(EvalImage!)!)
        var face_id2:String? = nil
        Alamofire.upload(.POST,
            "https://apius.faceplusplus.com/v2/detection/detect?api_secret=l7PsiUEj1TuF2b5_p369Ai8W6y_BnIsV&api_key=0e5ac228d92bc2c63c11c9aa47752b2a&img",
            headers: nil,
            multipartFormData: { multipartFormData in
                // 文字列データはUTF8エンコードでNSData型に
                //multipartFormData.appendBodyPart(data: "image".dataUsingEncoding(NSUTF8StringEncoding)!, name: "type")
                // バイナリデータ
                // サーバによってはファイル名や適切なMIMEタイプを指定しないとちゃんと処理してくれないかも
                multipartFormData.appendBodyPart(data: imageData2, name: "img", fileName: "i320.jpeg", mimeType: "image/jpeg")
            },
            // リクエストボディ生成のエンコード処理が完了したら呼ばれる
            encodingCompletion: { encodingResult in
                switch encodingResult {
                    // エンコード成功時
                case .Success(let upload, _, _):
                    // 実際にAPIリクエストする
                    upload.responseString { str in
                        //debugPrint(str.result.value)
                        var casted = str.result.value as NSString?
                        let pattern = "face_id.+[a-z0-9]+.+,"
                        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
                        regex.enumerateMatchesInString(casted! as String, options: NSMatchingOptions.WithoutAnchoringBounds ,range: NSMakeRange(0, casted!.length),
                            usingBlock: {(result: NSTextCheckingResult?, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                                for i in 0...result!.numberOfRanges - 1 {
                                    let range = result!.rangeAtIndex(i)
                                    face_id2 = casted!.substringWithRange(range)
                                    break
                                }
                        })
                        let rep1 = face_id2!.stringByReplacingOccurrencesOfString("face_id\": \"", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                        let rep2 = rep1.stringByReplacingOccurrencesOfString("\",", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                        face_id2 = rep2
                        //print(id1)
                        //print(face_id2!)
                        self.req_similality(id1, fid2: face_id2!)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
    func req_similality(fid1 : String, fid2 : String){
        Alamofire.request(.GET, "https://apius.faceplusplus.com/v2/recognition/compare?api_secret=l7PsiUEj1TuF2b5_p369Ai8W6y_BnIsV&api_key=0e5ac228d92bc2c63c11c9aa47752b2a&face_id1=\(fid1)&face_id2=\(fid2)")
            .responseString { response in
                print(response.result.value)
                var similarity : String? = nil
                var casted = response.result.value as NSString?
                let pattern = "similarity.+[0-9]+.[0-9]+.+"
                let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
                regex.enumerateMatchesInString(casted! as String, options: NSMatchingOptions.WithoutAnchoringBounds ,range: NSMakeRange(0, casted!.length),
                    usingBlock: {(result: NSTextCheckingResult?, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                        for i in 0...result!.numberOfRanges - 1 {
                            let range = result!.rangeAtIndex(i)
                            similarity = casted!.substringWithRange(range)
                            break
                        }
                })
                print(similarity!)
                let rep1 = similarity!.stringByReplacingOccurrencesOfString("similarity\": ", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                let rep2 = rep1.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                self.point_label.text = rep2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // セッションの作成.
        mySession = AVCaptureSession()
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        // バックカメラをmyDeviceに格納.
        for device in devices{
            if(device.position == AVCaptureDevicePosition.Back){
                myDevice = device as! AVCaptureDevice
            }
        }
        
        // バックカメラからVideoInputを取得.
        let videoInput = try! AVCaptureDeviceInput(device: myDevice)
        
        // セッションに追加.
        mySession.addInput(videoInput)
        
        // 出力先を生成.
        myImageOutput = AVCaptureStillImageOutput()
        
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        
        // 画像を表示するレイヤーを生成.
        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: mySession)
        myVideoLayer.frame = self.view.bounds
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // Viewに追加.
        self.view.layer.addSublayer(myVideoLayer)
        
        // セッション開始.
        mySession.startRunning()
        
        // UIボタンを作成.
        let myButton = UIButton(frame: CGRectMake(0,0,120,50))
        myButton.backgroundColor = UIColor.redColor();
        myButton.layer.masksToBounds = true
        myButton.setTitle("撮影", forState: .Normal)
        myButton.layer.cornerRadius = 20.0
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        // UIボタンをViewに追加.
        self.view.addSubview(myButton);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // ボタンイベント.
    func onClickMyButton(sender: UIButton){
        
        // ビデオ出力に接続.
        let myVideoConnection = myImageOutput.connectionWithMediaType(AVMediaTypeVideo)
        
        // 接続から画像を取得.
        self.myImageOutput.captureStillImageAsynchronouslyFromConnection(myVideoConnection, completionHandler: { (imageDataBuffer, error) -> Void in
            
            // 取得したImageのDataBufferをJpegに変換.
            let myImageData : NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
            
            // JpegからUIIMageを作成.
            let myImage : UIImage = UIImage(data: myImageData)!
            
            // アルバムに追加.
            UIImageWriteToSavedPhotosAlbum(myImage, self, nil, nil)
            
        })
    }
}

