//
//  OTPVC.swift
//  Conexcion
//
//  Created by admin on 03/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import SVPinView
class OTPVC: UIViewController {
    var OTP = 123456
    var isComeFromWomanRegistrion = false
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var btnContinue: UIButton!
    var parameter: [String: Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    // MARK: Setup Function
    func viewSetup(){
        let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(btnBackAction))
        self.navigationItem.leftBarButtonItem  = backBarButtonItem
        self.title = "Enter OTP"
        configurePinView()
        btnContinue.isEnabled = false
        btnContinue.alpha = 0.5
    }
    func configurePinView() {
        
        pinView.interSpace = 5
        pinView.textColor = UIColor.white
        pinView.borderLineThickness = 1
        pinView.shouldSecureText = false
        pinView.allowsWhitespaces = false
        pinView.style = .box
        pinView.fieldCornerRadius = 8
        pinView.activeFieldCornerRadius = 8
        pinView.placeholder = ""
        pinView.becomeFirstResponderAtIndex = 0
        pinView.textColor = #colorLiteral(red: 0.1439727247, green: 0.3993673921, blue: 0.4678213596, alpha: 1)
        pinView.font = UIFont.systemFont(ofSize: 20)
        pinView.didChangeCallback = { pin in
            if pin.count >= 6
            {
                self.btnContinue.isEnabled = true
                self.btnContinue.alpha = 1.0
            }else{
                self.btnContinue.isEnabled = false
                self.btnContinue.alpha = 0.5
            }
            
        }
        pinView.keyboardType = .phonePad
    }
    // MARK: Back Button Action
    @objc func btnBackAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Submit OTP Button Action
    @IBAction func btnReSendOTP(_ sender: Any) {
        MBProgressStart()
        let parameterOther: [String: Any] = [
            API_Phone_Number:self.parameter[API_Phone_Number] ?? "",
            EMAIL:self.parameter[API_EMAIL] ?? ""
        ]
        print("request params: \(parameter)")
        MBProgressStart()
        APIManager.callAPIBYPOST(parameter: parameterOther, url: ApiBaseURL + RequestOtpTwo, OnResultBlock: { (response, status) in
            print("------\(response)------")
            let dictResponse = response
            if status == "true" {
                let dictData = dictResponse[DATA] as? NSDictionary
                print(dictData ?? "")
                if dictData != nil{
                    if  dictData?.value(forKey: STATUS) as! String == Status_Code100 {//Success
                        MPProgressFinish()
                        let strverificationCode = dictData?.value(forKey: "otp_verification_code") as! Int
                        self.OTP = strverificationCode
                        self.showCustomAlertWith(
                            message: "Code has been send, Please Check your Messages",
                            descMsg: "Please enter New OTP Code",
                            itemimage: nil,
                            actions: nil)
                    }
                    else if dictData?.value(forKey: STATUS) as! String == Status_Code0{//Failure
                        MPProgressFinish()
                        let err = dictData?.value(forKey: ERROR) as? NSDictionary
                        self.view?.makeToast(message:  err?.value(forKey: DISCRIPTION) as? String ?? "", duration: TimeInterval(3.0), position: .center, backgroundColor: .black, messageColor: .white, font: nil)
                    }else if dictData?.value(forKey: STATUS) as! String == Status_Code500{//Failure
                        MPProgressFinish()
                        let err = dictData?.value(forKey: DISCRIPTION) as? String
                        self.view?.makeToast(message:  err ?? "", duration: TimeInterval(3.0), position: .center, backgroundColor: .black, messageColor: .white, font: nil)
                    }else{
                        MPProgressFinish()
                    }
                }
            }
            else{//Failure
                MPProgressFinish()
            }
            //RSLoadingView.hide(from: self.view)
            MPProgressFinish()
        })
    }
    // MARK: - Submit OTP Button Action
    @IBAction func btnSubmitOTP(_ sender: Any) {
        guard !(trim(str: pinView.getPin()) != String(OTP)) else {
            pinView.clearPin()
            pinView.becomeFirstResponderAtIndex = 0
            spaceDescr = OTPErrorMessage
            MethodForErrorShow()
            return
        }
        if (isComeFromWomanRegistrion == true){
            WebServiceForWomanRegister()
        }else{
            WebServiceForMenRegister()
        }
    }
    //MARK: Signup Man API / Web Service
    func WebServiceForMenRegister() {
        print("request params: \(parameter)")
        MBProgressStart()
        APIManager.callAPIBYPOST(parameter: parameter, url: ApiBaseURL + MenRegister, OnResultBlock: { (response, status) in
            print("------\(response)------")
            let dictResponse = response
            if status == "true" {
                let dictData = dictResponse[DATA] as? NSDictionary
                print(dictData ?? "")
                if dictData != nil{
                    if  dictData?.value(forKey: STATUS) as! String == Status_Code100 {//Success
                        MPProgressFinish()
                        let strAvialable = dictData?.value(forKey: RESPONSE) as? String
                        if(strAvialable == "REGISTERED"){
                            let usrID = dictData?.value(forKey: KUser_Id) as? NSInteger
                            let Service_Plan_ID = dictData?.value(forKey: kService_Plan_ID) as? String
                            UserDefaults_SaveData(dictData:Service_Plan_ID ?? "", keyName: kService_Plan_ID)
                            UserDefaults_SaveData(dictData:String(usrID ?? 0), keyName: API_UserId)
                            UserDefaults_SaveData(dictData: String(usrID ?? 0), keyName: kAccessToken)
                            UserDefaults_SaveData(dictData: "Man", keyName: kRegisterType)
                            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVCMan") as! HomeVCMan//CollectionsViewController
                            viewController.isNotificationAvailable = false;
                            let navigationController = NavigationController(rootViewController: viewController)
                            let mainViewController = MainViewController()
                            mainViewController.rootViewController = navigationController
                            mainViewController.setup(type: UInt(1))
                            appDelegate.window?.rootViewController = mainViewController
                            navigationController.setNavigationBarHidden(false, animated: false)
                        }else{
                            MPProgressFinish()
                            self.view?.makeToast(message:  strAvialable ?? "Error", duration: TimeInterval(3.0), position: .center, backgroundColor: .black, messageColor: .white, font: nil)
                        }
                    }
                    else if dictData?.value(forKey: STATUS) as! String == Status_Code0{//Failure
                        MPProgressFinish()
                        let err = dictData?.value(forKey: ERROR) as? NSDictionary
                        self.view?.makeToast(message:  err?.value(forKey: DISCRIPTION) as? String ?? "", duration: TimeInterval(3.0), position: .center, backgroundColor: .black, messageColor: .white, font: nil)
                    }else{
                        MPProgressFinish()
                    }
                }
            }
            else{//Failure
                MPProgressFinish()
            }
            //RSLoadingView.hide(from: self.view)
            MPProgressFinish()
        })
    }
    
    //MARK: Signup Man API / Web Service
    func WebServiceForWomanRegister() {
        
    }
}
