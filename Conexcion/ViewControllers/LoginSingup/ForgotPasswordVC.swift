//
//  ForgotPasswordVC.swift
//  Conexcion
//
//  Created by admin on 03/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    // MARK: Setup Function
    func viewSetup(){
        let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(btnBackAction))
        self.navigationItem.leftBarButtonItem  = backBarButtonItem
        self.title = "Forgot Password"
    }
    // MARK: Back Button Action
    @objc func btnBackAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: Password Send Button Action
    @IBAction func ClickOnSendPassword(sender:AnyObject){
        guard validateData() else { return }
        WebServiceForForgotPassword()
    }
    //MARK: Forgot Password API / Web Service
    func WebServiceForForgotPassword() {
        self.txtEmail.resignFirstResponder()
        let parameter: [String: Any] = [
            API_EMAIL:self.txtEmail.text!
        ]
        print("request params: \(parameter)")
        MBProgressStart()
        APIManager.callAPIBYPOST(parameter: parameter, url: ApiBaseURL + forgetPassword, OnResultBlock: { (response, status) in
            print("------\(response)------")
            let dictResponse = response
            if status == "true" {
                let dictData = dictResponse[DATA] as? NSDictionary
                print(dictData ?? "")
                if dictData != nil{
                    if  dictData?.value(forKey: STATUS) as! String == Status_Code100 {//Success
                        MPProgressFinish()
                        let result = dictData?.value(forKey: RESULT) as? String
                        self.showCustomAlertWith(
                            message: "Code has been send, Please Check your Email",
                            descMsg: result ?? "",
                            itemimage: nil,
                            actions: nil)
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
            MPProgressFinish()
        })
    }
    //MARK: validate Login Data
    func validateData() -> Bool {
        guard !trim(str: txtEmail.text!).isEmpty else {
            spaceDescr = emailMessage
            MethodForErrorShow()
            return false
        }
        guard isValidEmail(testStr:trim(str: txtEmail.text!)) else {
            spaceDescr = emailInvalidMessage
            MethodForErrorShow()
            return false
        }
        return true
    }
}
