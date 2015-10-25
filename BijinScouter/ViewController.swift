//
//  ViewController.swift
//  BijinScouter
//
//  Created by Ryo Kanbayashi on 2015/10/03.
//  Copyright (c) 2015年 ryo_grid. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var point_label: UILabel!
    

    @IBAction func evaluation(sender: UIButton) {
        point_label.text = "hoge"
        
        get_similarity2()
    }
    
    func get_similarity2(){
        var counter = 0
        
        
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
    
    
    
    
    
    
    func get_similarity(){
        // create the url-request
        //let urlString = "https://apius.faceplusplus.com/v2/detection/detect?api_secret=l7PsiUEj1TuF2b5_p369Ai8W6y_BnIsV&api_key=0e5ac228d92bc2c63c11c9aa47752b2a&img"
        let urlString = "http://127.0.0.1:8080/v2/detection/detect?api_secret=l7PsiUEj1TuF2b5_p369Ai8W6y_BnIsV&api_key=0e5ac228d92bc2c63c11c9aa47752b2a&img"
        var urlRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        // set the method(HTTP-POST)
        urlRequest.HTTPMethod = "POST"
//        // set the header(s)

        
        let BijinImage = UIImage(named: "japanese_bijin.png")
        
        let imageData:NSData = NSData(data:UIImagePNGRepresentation(BijinImage!)!)
 
        let uniqueId = NSProcessInfo.processInfo().globallyUniqueString
        var body: NSMutableData = NSMutableData()

        var postData :String = String()
//        var boundary:String = "---------------------------\(uniqueId)"
        var boundary:String = "---------------------------jf74jd83ju3ud752"
        
        urlRequest.addValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(String(imageData.length), forHTTPHeaderField: "Content-Length")
        urlRequest.addValue("ios app", forHTTPHeaderField: "User-Agent")
        urlRequest.addValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.addValue("100-continue", forHTTPHeaderField: "Expect")
//        urlRequest.addValue(nil, forHTTPHeaderField: "Accept-Encoding")
//        urlRequest.addValue(nil, forHTTPHeaderField: "Accept-Language")
        //request.addValue("form-data; name=\"img\";", forHTTPHeaderField: "Content-Disposition")
        //request.addValue("form-data; name=img;", forHTTPHeaderField: "Content-Disposition")
        //       request.addValue("multipart/form-data;", forHTTPHeaderField: "Content-Type")
        

//        postData += "Content-Disposition: form-data; name=img;\r\n"
//        postData += "Content-Type: application/octet-stream\r\n"
//        postData += "Content-Transfer-Encoding: binary\r\n\r\n"
        
//        postData += "Content-Type: image/png\r\n\r\n"
//        postData += "img=jieopwjioweklalsjoawejasfklsadjklaf\r\n"
        postData += "\(boundary)\r\n"
        body.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(imageData)
        postData += "\(boundary)\r\n"
        body.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        urlRequest.HTTPBody = NSData(data:body)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(urlRequest, completionHandler: { data, request, error in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
            print(request)
        })
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

