//
//  APIManager.swift
//  AlamoFire_WebService
//
//  Created by admin on 24/12/18.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import Alamofire
import TTGSnackbar


class APIManager: NSObject {
    
    //MARK:
    //MARK: API Without Secureity Parameter
    class func callAPIBYGET(url:String,OnResultBlock: @escaping (_ dict: NSDictionary,_ status:String) -> Void) {
        
        if !reachability.isReachable {
            self.iToastMessage(msg: "No Internet Connection, try later!")
        } else  {
            request(url, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                print("------\(String(describing: response.response?.statusCode))-----")
                if  response.response?.statusCode == nil {
                    let dic = NSMutableDictionary.init()
                    dic .setValue("Server Error", forKey: "Message")
                    OnResultBlock(dic,"false")
                    return;
                }
                
                if (response.response?.statusCode)! != 200{//No recordFound
                    
                    if let data = response.result.value {
                        let dictdata = NSMutableDictionary()
                        let dataQ = data as! NSDictionary
                        if dataQ.value(forKey: "Message") != nil {
                            dictdata.setValue(data, forKey: "data")
                            OnResultBlock((dictdata) ,"false")
                            self.iToastMessage(msg: (data as! NSDictionary).value(forKey: "Message") as! String)
                            return;
                        }
                    }
                    
                    let data = [  "Message":ERROR_NO_RECORD] as NSDictionary;
                    let dictdata = NSMutableDictionary()
                    dictdata.setValue(data, forKey: "data")
                    OnResultBlock((dictdata) ,"false")
                    self.iToastMessage(msg: ERROR_NO_RECORD)
                    return;
                }

                
                switch(response.result) {
                    
                case .success(_):
                    if let data = response.result.value {
                        let dictdata = NSMutableDictionary()
                        dictdata.setValue(data, forKey: "data")
                        OnResultBlock((dictdata) ,"true")
                    }
                    break
                    
                case .failure(_):
                    if response.response?.statusCode == 200 {
                        let dic = NSMutableDictionary.init()
                        dic .setValue("Successfully update", forKey: "Message")
                        OnResultBlock(dic,"false")
                        
                    }else{
                        print(response.result.error!)
                        let dic = NSMutableDictionary.init()
                        dic .setValue("Connection Time Out ", forKey: "Message")
                        OnResultBlock(dic,"false")
                    }

                    break
                }
            }
        }
    }
    
    class func callAPIBYPOST(parameter:[String: Any],url:String,  OnResultBlock: @escaping (_ dict: NSDictionary,_ status:String) -> Void) {
        
        if !reachability.isReachable {
            self.iToastMessage(msg: "No Internet Connection, try later!")
    
        } else {
            print(parameter)
            request(url, method: .post, parameters: parameter, encoding: URLEncoding.default).validate(contentType: ["application/json","text/html"]).responseJSON { (response) in
                
 
                if response.response?.statusCode == nil {
                    let data = [  "Message":ERROR_NO_RECORD] as NSDictionary;
                    let dictdata = NSMutableDictionary()
                    dictdata.setValue(data, forKey: "data")
                    OnResultBlock((dictdata) ,"false")
                    self.iToastMessage(msg: ERROR_NO_RECORD)
                    return;
                }
                
                if (response.response?.statusCode)! != 200 {//No recordFound
                    
                    if let data = response.result.value {
                        let dictdata = NSMutableDictionary()
                        let dataQ = data as! NSDictionary
                        if dataQ.value(forKey: "Message") != nil {
                            dictdata.setValue(data, forKey: "data")
                            OnResultBlock((dictdata) ,"false")
    // self.iToastMessage(msg: (data as! NSDictionary).value(forKey: "Message") as! String)
                            return;
                        }
                    }
                    
                    let data = [  "Message":ERROR_NO_RECORD] as NSDictionary;
                    let dictdata = NSMutableDictionary()
                    dictdata.setValue(data, forKey: "data")
                    OnResultBlock((dictdata) ,"false")
                    self.iToastMessage(msg: ERROR_NO_RECORD)
                    return;
                }

                switch(response.result) {
                    
                case .success(_):
                    if let data = response.result.value {
                        let dictdata = NSMutableDictionary()
                        dictdata.setValue(data, forKey: "data")
                        OnResultBlock((dictdata) ,"true")
                    }
                    break
                    
                case .failure(_):
                    if response.response?.statusCode == 200 {
                        let dic = NSMutableDictionary.init()
                        dic .setValue("Successfully update", forKey: "Message")
                        OnResultBlock(dic,"true")
                        
                    }else{
                        
                        print(response.result.error!)
                        let dic = NSMutableDictionary.init()
                        dic .setValue("Connection Time Out ", forKey: "Message")
                        OnResultBlock(dic,"false")
                    }
                    break
                }
            }
        }
    }
    
    class func callAPIBYPUT(parameter:[String: Any],url:String,OnResultBlock: @escaping (_ dict: NSDictionary,_ status:String) -> Void) {
        if !reachability.isReachable {
            self.iToastMessage(msg: "No Internet Connection, try later!")
        } else {
             print(parameter)
           // request(url, method: .put, parameters: parameter, encoding: URLEncoding.default).validate(contentType: ["application/json","text/html"]).responseJSON { (response) in
                
              request(url, method: .put, parameters:parameter, encoding: JSONEncoding.default, headers: nil).responseString  { (response:DataResponse<String>) in
                
                if (response.response?.statusCode)! != 200{//No recordFound
                    //print(response.result.value)
                    
                    if response.result.value != nil {
                        let jsonString: String = response.result.value!
                        let data = jsonString.data(using: .utf8)!
                        let jsonData: NSDictionary = try! JSONSerialization.jsonObject(with: data) as! NSDictionary
                        print(jsonData)
                        
                        let dictdata = NSMutableDictionary()
                         if jsonData.value(forKey: "Message") != nil {
                            dictdata.setValue(data, forKey: "data")
                            OnResultBlock((dictdata) ,"false")
                            self.iToastMessage(msg:jsonData.value(forKey: "Message") as! String)
                            return;
                        }
                    }
                    
                    let data = [  "message":ERROR_NO_RECORD] as NSDictionary;
                    let dictdata = NSMutableDictionary()
                    dictdata.setValue(data, forKey: "data")
                    OnResultBlock((dictdata) ,"false")
                    self.iToastMessage(msg: ERROR_NO_RECORD)
                    return;
                }
                
                switch(response.result) {
                    
                case .success(_):
                    if let data = response.result.value {
                        let dictdata = NSMutableDictionary()
                        dictdata.setValue(data, forKey: "data")
                        OnResultBlock((dictdata) ,"true")
                    }
                    
                    break
                    
                case .failure(_):
                    
                    if response.response?.statusCode == 200 {
                        let dic = NSMutableDictionary.init()
                        dic .setValue("Successfully update", forKey: "message")
                        OnResultBlock(dic,"true")
                        
                    }else{
                        
                        print(response.result.error!)
                        let dic = NSMutableDictionary.init()
                        dic .setValue("Connection Time Out ", forKey: "message")
                        OnResultBlock(dic,"false")
                    }
                    break
                }
            }
        }
    }
    class func callAPIBYPUTT(parameter:[String: Any],url:String,OnResultBlock: @escaping (_ dict: NSDictionary,_ status:String) -> Void) {
        if !reachability.isReachable {
            self.iToastMessage(msg: "No Internet Connection, try later!")
        } else {
    
//    
//            let headers = [ "cache-control": "no-cache",
//                "postman-token": "a34397d4-373b-a418-36e7-afd7347f8965"]
//            
////            let postData = NSData(data: [
////                "Fk_UserId" : "4e060981-a9b4-4681-b6b3-f164414fd339",
////                "ShowMeInConnectStatus" : true,
////                "EmailNotification" : true,
////                "EmailNewContact" : true,
////                "EmailContactUpdates" : true,
////                "EmailNewInvites" : true,
////                "EmailNewMessages" : true,
////                "PushNotification" : true,
////                "PushNewContact" : true,
////                "PushContactUpdates" : true,
////                "PushNewInvites" : true,
////                "PushNewMessages" : true,
////                "Others" : [
////                "ContactSupport" : "www.demo1.emjow.com",
////                "TermsOfServices" : "www.demo1.emjow.com",
////                "Guide": "www.demo1.emjow.com"
////                ],
////                "PrimaryContact" : [
////                "Phonenumber" : "9098319112",
////                "Email" : "mdhakad89@gmail.com",
////                "ChangePasword" : "www.demo1.emjow.com"
////            ]
////            ]
//            
//            let parameter = parameter.data(using: .utf8)
//            
//            
//        let postData = parameter.data(using: String.Encoding.utf8)!
//        
//        let request = NSMutableURLRequest(url: NSURL(string: "https://demo1.emjow.com/api/user/settings/update")! as URL, cachePolicy: .useProtocolCachePolicy,  timeoutInterval: 30.0)
//        request.httpMethod = "PUT"
//        request.allHTTPHeaderFields = headers
//        request.httpBody = postData as Data
//        
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if (error != nil) {
//                print(error)
//            } else {
//                let httpResponse = response as? HTTPURLResponse
//                print(httpResponse)
//            }
//        })
//        
//        dataTask.resume()
//    
    
    
    
    
    
    
    
    
    }
}
    
    
    class func callAPIBYDELETE(parameter:[String: Any],url:String,OnResultBlock: @escaping (_ dict: NSDictionary,_ status:String) -> Void) {
        
        if !reachability.isReachable {
            self.iToastMessage(msg: "No Internet Connection, try later!")
        } else {
            print(parameter)
            
            request(url, method: .delete, parameters: parameter, encoding: URLEncoding.default).validate(contentType: ["application/json","text/html"]).responseJSON { (response) in
                print(response.response?.statusCode)
                if (response.response?.statusCode)! != 200{//No recordFound
                    
                    if let data = response.result.value {
                        let dictdata = NSMutableDictionary()
                        let dataQ = data as! NSDictionary
                        if dataQ.value(forKey: "Message") != nil {
                            dictdata.setValue(data, forKey: "data")
                            OnResultBlock((dictdata) ,"false")
                            self.iToastMessage(msg: (data as! NSDictionary).value(forKey: "Message") as! String)
                            return;
                        }
                    }
                    
                    
                    
                    let data = [  "message":ERROR_NO_RECORD] as NSDictionary;
                    let dictdata = NSMutableDictionary()
                    dictdata.setValue(data, forKey: "data")
                    OnResultBlock((dictdata) ,"false")
                    self.iToastMessage(msg: ERROR_NO_RECORD)
                    return;
                }
                
                switch(response.result) {
                    
                case .success(_):
                    if let data = response.result.value {
                        let dictdata = NSMutableDictionary()
                        dictdata.setValue(data, forKey: "data")
                        OnResultBlock((dictdata) ,"true")
                    }
                    
                    break
                    
                case .failure(_):
                    
                    if response.response?.statusCode == 200 {
                        let dic = NSMutableDictionary.init()
                        dic .setValue("Successfully update", forKey: "message")
                        OnResultBlock(dic,"true")
                        
                    }else{
                        
                        print(response.result.error!)
                        let dic = NSMutableDictionary.init()
                        dic .setValue("Connection Time Out ", forKey: "message")
                        OnResultBlock(dic,"false")
                    }
                    break
                }
            }
        }
    }
  class  func callAPIWithImage(parameter:NSDictionary,url:String,image:UIImage,imageKeyName:String,OnResultBlock: @escaping (_ dict: NSDictionary,_ status:String) -> Void){
        
        print("parameter:-\(parameter),url:-\(url),imageKeyName:-\(imageKeyName)")
        
        if !reachability.isReachable {
            let dic = NSMutableDictionary.init()
            dic.setValue("No Internet Connection, try later!", forKey: "message")
            dic.setValue("false", forKey: "status")
            OnResultBlock(dic,"failure")
            
        } else {
            
            upload(multipartFormData: { (multiPartFormData:MultipartFormData) in
                if  let imageData = image.jpegData(compressionQuality: 0.2) {
                    let fileName = String(format: "%f.jpg", NSDate.init().timeIntervalSince1970)
                    multiPartFormData.append(imageData, withName: imageKeyName, fileName:fileName , mimeType: "image/jpeg")
                }
//                for (key, value) in parameter {
//                    print("---key: \(key)---","----value: \(value)")
//                    multiPartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key as! String)
//                }
            }, to: url, method: .post) { (encodingResult:SessionManager.MultipartFormDataEncodingResult) in
                
                switch (encodingResult){
                    
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    ///--------JSON----------
                    upload.responseJSON { response in
                        print(response.response?.statusCode) // URL response
                        print(response.result.value!)   // result of response serialization
                        if let JSON = response.result.value {
                            OnResultBlock(JSON as! NSDictionary,"true")
                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                    let dic = NSMutableDictionary.init()
                    dic.setValue("Connection Time Out ", forKey: "message")
                    OnResultBlock(dic,"false")
                }
            }
        }
    }
    
    class func iToastMessage(msg: String) {
        let viewController =  (UIApplication.shared.keyWindow?.rootViewController)! as UIViewController
        viewController.view.makeToast(message:  msg, duration: TimeInterval(3.0), position: .top, backgroundColor: .black, messageColor: .white, font: nil)
        
//        let snackbar = TTGSnackbar(message: msg, duration: .long)
//        snackbar.show()
    }

    
    //MARK:
    //MARK: Get Device ID
    class func get_DeviceID() -> String {
        let device = UIDevice.current
        let str_deviceID = device.identifierForVendor?.uuidString
        return str_deviceID!
    }
    
    //MARK:
    //MARK: Get Device Type
   class func get_DeviceType() -> String {
        let deviceType = "ios"
        return deviceType
    }
    
    
    
    
/*    class func callAPIWithImage(parameter:NSDictionary,url:String,image:UIImage,imageName:String,OnResultBlock: @escaping (_ dict: NSDictionary,_ status:String) -> Void){
        
        let r = Reachability(hostname: "www.google.com")
        
        if r?.currentReachabilityStatus == Reachability.NetworkStatus.notReachable {
            
            let dic = NSMutableDictionary.init()
            dic.setValue("No Internet Connection, try later!", forKey: "message")
            dic.setValue("false", forKey: "status")
            OnResultBlock(dic,"failure")
        }
        else
        {
            upload(multipartFormData: { (multiPartFormData:MultipartFormData) in
                
                if  let imageData = UIImageJPEGRepresentation(image, 0.5) {
                    let fileName = String(format: "%f.jpeg", NSDate.init().timeIntervalSince1970)
                    multiPartFormData.append(imageData, withName: imageName, fileName: fileName, mimeType: "image/jpeg")
                }
                
                for (key, value) in parameter {
                    multiPartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key as! String)
                }
                
            }, to: url) { (encodingResult:SessionManager.MultipartFormDataEncodingResult) in
                
                switch (encodingResult){
                    
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    upload.responseJSON { response in
                        print(response.request!)  // original URL request
                        print(response.response!) // URL response
                        print(response.data!)     // server data
                        print(response.result)   // result of response serialization
                        
                        if let JSON = response.result.value
                        {
                            OnResultBlock(JSON as! NSDictionary,"Suceess")
                        }
                        
                    }
                    
                case .failure(let encodingError):
                    
                    print(encodingError)
                    let dic = NSMutableDictionary.init()
                    dic.setValue("Connection Time Out ", forKey: "message")
                    OnResultBlock(dic,"failure")
                    
                }
                
            }
            
        }
        
    }
    
    //MARK:
    //MARK: API With Secureity Parameter
    func callSecurityAPI(parameter:NSDictionary,url:String,OnResultBlock: @escaping (_ dict: NSDictionary,_ status:String) -> Void) {
        
        let r = Reachability(hostname: "www.google.com")
        
        if r?.currentReachabilityStatus == Reachability.NetworkStatus.notReachable {
            
            let dic = NSMutableDictionary.init()
            dic.setValue("No Internet Connection, try later!", forKey: "message")
            dic.setValue("false", forKey: "status")
            
            OnResultBlock(dic,"failure")
        }
        else
        {
            let finalParameter = self.addSecurity_Parameter(parameter: parameter as! NSMutableDictionary)
            
            request(url, method: .post, parameters: finalParameter as? Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                    
                case .success(_):
                    if let data = response.result.value{
                        OnResultBlock(data as! NSDictionary,"Suceess")
                    }
                    break
                    
                case .failure(_):
                    print(response.result.error!)
                    let dic = NSMutableDictionary.init()
                    dic .setValue("Connection Time Out ", forKey: "message")
                    OnResultBlock(dic,"failure")
                    break
                    
                }
                
            }
            
        }
        
    }
    
    func callAPIWithSecurity_Image(parameter:NSDictionary,url:String,image:UIImage,imageName:String,OnResultBlock: @escaping (_ dict: NSDictionary,_ status:String) -> Void){
        
        let r = Reachability(hostname: "www.google.com")
        
        if r?.currentReachabilityStatus == Reachability.NetworkStatus.notReachable {
            
            let dic = NSMutableDictionary.init()
            dic.setValue("No Internet Connection, try later!", forKey: "message")
            dic.setValue("false", forKey: "status")
            OnResultBlock(dic,"failure")
        }
        else
        {
            let finalParameter = self.addSecurity_Parameter(parameter: parameter as! NSMutableDictionary)
            
            upload(multipartFormData: { (multiPartFormData:MultipartFormData) in
                
                if  let imageData = UIImageJPEGRepresentation(image, 0.5) {
                    let fileName = String(format: "%f.jpeg", NSDate.init().timeIntervalSince1970)
                    multiPartFormData.append(imageData, withName: imageName, fileName: fileName, mimeType: "image/jpeg")
                }
                
                for (key, value) in finalParameter {
                    multiPartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key as! String)
                }
                
            }, to: url) { (encodingResult:SessionManager.MultipartFormDataEncodingResult) in
                
                switch (encodingResult){
                    
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    upload.responseJSON { response in
                        
                        print(response.request!)  // original URL request
                        print(response.response!) // URL response
                        print(response.data!)     // server data
                        print(response.result)   // result of response serialization
                        
                        if let JSON = response.result.value
                        {
                            OnResultBlock(JSON as! NSDictionary,"Suceess")
                        }
                        
                    }
                    
                case .failure(let encodingError):
                    
                    print(encodingError)
                    let dic = NSMutableDictionary.init()
                    dic .setValue("Connection Time Out ", forKey: "message")
                    OnResultBlock(dic,"failure")
                    
                }
                
            }
            
        }
        
    }
    
   
    
    //MARK:
    //MARK: Get Current Time
    func get_currentTime() -> String {
        let timeFormat = DateFormatter.init()
        timeFormat.dateFormat = "HH:mm:ss"
        return timeFormat.string(from: Date.init())
    }
    
    //MARK:
    //MARK: Get Current Time
    func addSecurity_Parameter(parameter:NSMutableDictionary) -> NSDictionary
    {
        let strTimeStamp = self.get_currentTime()
        let strDeviceType = "2"
        let str_Token = String.init(format: "%@%@%@%@", "masterkey","123456789",strDeviceType,strTimeStamp)
        let str_md5 = str_Token.md5
        
        parameter.setValue("123456789", forKey: "user_device_token")
        parameter.setValue(strDeviceType, forKey: "user_device_type")
        parameter.setValue(strTimeStamp, forKey: "timestamp")
        parameter.setValue(str_md5, forKey: "md5_key")
        
        return parameter
    }*/
    
}
/*
//MARK:
//MARK: MD5 Generate

extension String  {
    var md5: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate(capacity: digestLen)
        
        return String(format: hash as String)
    }
}*/
