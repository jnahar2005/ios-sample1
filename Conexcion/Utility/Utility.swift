//
//  Utility.swift
//  Shared
//
//  Created by admin on 5/8/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD


var latitude:  Double! = 37.0902
var longitude: Double! = 95.7129

let appDelegate = UIApplication.shared.delegate as! AppDelegate
var mainStoryB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
var iPadMainStoryB : UIStoryboard = UIStoryboard(name: "iPadMain", bundle: nil)
var mainStoryboard = DeviceType.IS_IPAD ? mainStoryB : mainStoryB
var isPad = UIDevice.current.userInterfaceIdiom == .pad
var tabBarUser: UITabBarController!
let reachability = Reachability()!
var user_device_token :String = UserDefaults_FindData(keyName: kAccessToken) as! String
var user_device_type :String = "IOS"
var user_device_id :String = UIDevice.current.identifierForVendor!.uuidString

//---------encoded--------
func UserDefaults_SaveData(dictData:Any ,keyName: String) {
    let encodedData = NSKeyedArchiver.archivedData(withRootObject: dictData)
    UserDefaults.standard.set(encodedData, forKey: keyName)
}

//---------decoded--------
func UserDefaults_FindData(keyName: String) -> Any {
    //print(UserDefaults.standard.object(forKey: keyName)!)
    if UserDefaults.standard.object(forKey: keyName) != nil {
        let decoded = UserDefaults.standard.object(forKey: keyName)
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data)
        return decodedTeams as Any
        
    }else{
        return "";
    }
}

// MARK:- api_ExtraParameter Methods color, size
func jsonPrettyString(from object: Any) -> String? {
    if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
        let objectString = String(data: objectData, encoding: .utf8)
        return objectString
    }
    return nil
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

//// MARK: ------- MBProgressHUD Delegate methode -------
func MBProgressStart(){
    if let topVC = UIApplication.getTopViewController() {
        let HUD =  MBProgressHUD.showAdded(to: topVC.view, animated: true)
        HUD.labelText = "Loading..."    }
//    let viewController =  (UIApplication.shared.keyWindow?.rootViewController)! as UIViewController
//    let HUD =  MBProgressHUD.showAdded(to: viewController.view, animated: true)
//    HUD.labelText = "Loading..."
}

func MPProgressFinish(){
    if let topVC = UIApplication.getTopViewController() {
        _ = MBProgressHUD.hideAllHUDs(for: topVC.view, animated: true)
    }
//    let viewController =  (UIApplication.shared.keyWindow?.rootViewController)! as UIViewController
//    _ = MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
}

//---**----Get Current Device Size----***--
struct ScreenSize{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;
    static let SCREEN_MAX_LENGTH  = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT);
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT);
}
struct DeviceType{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

//MARK: Email Validation
func isValidEmail(testStr:String) -> Bool {
    print("validate emilId: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
    return result
}
//MARK: URL Validation
func isValidUrl(testStr:String) -> Bool {
    print("validate URL: \(testStr)")
    let emailRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
    return result
}

//MARK: Phone Validation
func mobileNumberValidate(value: String) -> Bool {
    let PHONE_REGEX = "[0-9]{8,15}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: value)
    return result
}

//MARK Space Detect From String
func trim(str: String) -> String {
    let strFinal = str.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    return strFinal as String
}

//MARK:------Message Alert Open------------
func alertOpen(title1: String, message msg: String) {
   let alert = UIAlertController(title:title1 , message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    let viewController =  (UIApplication.shared.keyWindow?.rootViewController)! as UIViewController
    viewController.present(alert, animated: true, completion: nil)
}

//MARK: Phone Calling
//MARK: CALLING
func phoneCall(num: NSString) {
    if num.length > 0 {
        let newString: String = num.replacingOccurrences(of: " ", with: "")
        let phNo: String = newString
        let phoneUrl: NSURL = NSURL(string: "telprompt:\(phNo)")!
        if UIApplication.shared.canOpenURL(phoneUrl as URL) {
            UIApplication.shared.openURL(phoneUrl as URL)
        } else {
            alertOpen(title1: "Error", message: "Your device doesn't support Call")
        }
    } else {
        alertOpen(title1: "Error", message: "Don't have contact number ")
    }
}


func openURLScheme(schemeURL: String) {
    if let url = URL(string: schemeURL) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                print("Open \(schemeURL): \(success)")
            })
        } else {
            let success = UIApplication.shared.openURL(url)
            print("Open \(schemeURL): \(success)")
        }
    }
}



//-----------Convert Image to Base64----------
func convertImageToBase64(image: UIImage) -> String {
//    let imageData:NSData =  (UIImageJPEGRepresentation(image, 0.6) as NSData?)!
//    let strBase64 = imageData.base64EncodedString(options: .init(rawValue: 0))
    return ""//strBase64
}

//-----------Convert Base64 to Image----------
func convertBase64ToImage(base64: String) -> UIImage {
    let data = NSData(base64Encoded: base64, options: NSData.Base64DecodingOptions.init(rawValue: 0))
    let image = UIImage(data: data as! Data)
    return image!
}

public func timeAgoSince(dateString: String, format: String) -> String {
    
//    print(dateString)
//    let ary = dateString.components(separatedBy: ".")
//    let dateString = ary[0]
//    print(dateString)
//    yyyy-MM-dd'T'HH:mm:ss
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    //dateFormatter.locale = Locale.init(identifier: "en_GB")
    let date: Date = dateFormatter.date(from: dateString)!
    //2017-06-09T09:33:26.97
    //print(date)
    
    let calendar = Calendar.current
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
    
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    
    if let year = components.year, year >= 2 {
        return "\(year) years ago"
    }
        
    else if let year = components.year, year >= 1 {
        return "Last year"
    }
        
    else if let month = components.month, month >= 2 {
        return "\(month) months ago"
    }
        
    else if let month = components.month, month >= 1 {
        return "Last month"
    }
        
    else if let week = components.weekOfYear, week >= 2 {
        return "\(week) weeks ago"
    }
        
    else if let week = components.weekOfYear, week >= 1 {
        return "Last week"
    }
        
    else if let day = components.day, day >= 2 {
        return "\(day) days ago"
    }
        
    else if let day = components.day, day >= 1 {
        return "Yesterday"

    }
        
    else if let hour = components.hour, hour >= 2 {
        return "\(hour) hours ago"
    }
        
    else if let hour = components.hour, hour >= 1 {
        return "1 hour ago"//An hour ago
    }
        
    else if let minute = components.minute, minute >= 2 {
        return "\(minute) minutes ago"
    }
        
    else if let minute = components.minute, minute >= 1 {
        return "1 minute ago"//A minute ago
    }
        
    else if let second = components.second, second >= 2 {//3
        return "\(second) seconds ago"
    }
        
    else if let second = components.second, second < 1 {//3
        return "0 seconds ago"
    }
    else {
        return "Just now"
    }
}

 
//"yyyy-MM-dd'T'HH:mm:ss"
public func changeDateFormat(dateString: String, inFormat: String, outFormat: String) -> String {
    
    let str = dateString.replacingOccurrences(of: "Z", with: "")
    let ary = str.components(separatedBy: ".")
    let dateString = ary[0]
    print(dateString)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = inFormat
    //dateFormatter.locale = Locale.init(identifier: "en_GB")
    let date = dateFormatter.date(from: dateString)
    
    let outPutFormatter = DateFormatter()
    outPutFormatter.dateFormat = outFormat
    let strOP = outPutFormatter.string(from: date!)
    
    return strOP;
}


