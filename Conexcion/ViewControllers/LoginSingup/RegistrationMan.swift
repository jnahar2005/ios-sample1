//
//  RegistrationMan.swift
//  Conexcion
//
//  Created by admin on 03/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import RSSelectionMenu

class RegistrationMan: UIViewController , UINavigationControllerDelegate ,UITextFieldDelegate , TermDelegate{
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var imgCountryFlag: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPassportNumber: UITextField!
    @IBOutlet weak var txtRequestedScreenName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var imgCountryCode: UIImageView!
    @IBOutlet weak var btnPlan1: UIButton!
    @IBOutlet weak var btnPlan2: UIButton!
    @IBOutlet weak var btnPlan3: UIButton!
    @IBOutlet weak var btnPlan4: UIButton!
    @IBOutlet weak var btnPlan5: UIButton!
    @IBOutlet weak var btnPlan6: UIButton!
    @IBOutlet weak var btnTermCondition: UIButton!
    @IBOutlet weak var btnShowPass: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var strPlan = "free"
    var planSel=1;
    var isAcceptTerm = false
    var isVerifyUserName = false
    var iconClick = true
    var arrCountries = NSArray()
    var simpleDataArrayOfCountry = [String]()
    var simpleSelectedArrayOfCountry = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    // MARK: Setup Function
    func viewSetup(){
        let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(btnBackAction))
        self.navigationItem.leftBarButtonItem  = backBarButtonItem
        self.title = "Man Registration"
        txtRequestedScreenName.delegate = self
        WebServiceForGetCountries()
    }
    // MARK: Back Button Action
    @objc func btnBackAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Country Button Action
    @IBAction func btnChooseCountry(_ sender: Any) {
        let selectionMenu = RSSelectionMenu(dataSource: simpleDataArrayOfCountry) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        // show searchbar
        selectionMenu.showSearchBar(withPlaceHolder: "Select Country", barTintColor: #colorLiteral(red: 0.9991930127, green: 0.7329201102, blue: 0, alpha: 1)) { (searchtext) -> ([String]) in
            return self.simpleDataArrayOfCountry.filter {$0.contains(searchtext) || $0.contains(searchtext.lowercased()) || $0.contains(searchtext.uppercased())}
        }
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        selectionMenu.navigationController?.navigationBar.titleTextAttributes = textAttributes
        selectionMenu.navigationController?.navigationBar.barTintColor = UIColor.black
        selectionMenu.setSelectedItems(items: simpleSelectedArrayOfCountry) { [weak self] (item, index, isSelected, selectedItems) in
            self?.simpleSelectedArrayOfCountry = selectedItems
            self?.txtCountry.text = item
        }
        selectionMenu.show(style: .formSheet, from: self)
    }
    //MARK: - Country Code Button Action
    @IBAction func btnChooseCountryCode(_ sender: Any) {
        let picker = MICountryPicker()
        picker.delegate = self
        picker.didSelectCountryWithCallingCodeClosure = { name, code, dialcode in
            print(dialcode)
        }
        navigationController?.pushViewController(picker, animated: true)
        self.navigationController?.title = "Country List"
    }
    // MARK: - Choose Plan Action
    @IBAction func btnPlan(_ sender: UIButton) {
        strPlan = ""
        planSel = 1;
        let Tag = sender.tag
        btnPlan1.setImage(#imageLiteral(resourceName: "uncheckWhite"), for: .normal)
        btnPlan2.setImage(#imageLiteral(resourceName: "uncheckWhite"), for: .normal)
        btnPlan3.setImage(#imageLiteral(resourceName: "uncheckWhite"), for: .normal)
        btnPlan4.setImage(#imageLiteral(resourceName: "uncheckWhite"), for: .normal)
        btnPlan5.setImage(#imageLiteral(resourceName: "uncheckWhite"), for: .normal)
        btnPlan6.setImage(#imageLiteral(resourceName: "uncheckWhite"), for: .normal)
        if Tag == 1 {
            btnPlan1.setImage(#imageLiteral(resourceName: "checkYellow"), for: .normal)
            strPlan = "free"
            planSel = 1;
        }else if Tag == 2 {
            btnPlan2.setImage(#imageLiteral(resourceName: "checkYellow"), for: .normal)
            strPlan = "1 month"
            planSel = 2;
        }else if Tag == 3 {
            btnPlan3.setImage(#imageLiteral(resourceName: "checkYellow"), for: .normal)
            strPlan = "3 month"
            planSel = 3;
        }else if Tag == 4 {
            btnPlan4.setImage(#imageLiteral(resourceName: "checkYellow"), for: .normal)
            strPlan = "6 month"
            planSel = 4;
        }else if Tag == 5 {
            btnPlan5.setImage(#imageLiteral(resourceName: "checkYellow"), for: .normal)
            strPlan = "1 year"
            planSel = 5;
        }else if Tag == 6 {
            btnPlan6.setImage(#imageLiteral(resourceName: "checkYellow"), for: .normal)
            strPlan = "one time paid"
            planSel = 6;
        }
    }
    // MARK: - See Password Action
    @IBAction func eyeAction(sender: AnyObject) {
        if(iconClick == true) {
            txtPassword.isSecureTextEntry = false
            self.btnShowPass.setImage(#imageLiteral(resourceName: "hidePass"), for: .normal)
        } else {
            txtPassword.isSecureTextEntry = true
            self.btnShowPass.setImage(#imageLiteral(resourceName: "showPass"), for: .normal)
        }
        iconClick = !iconClick
    }
    // MARK: - Check availablity Action
    @IBAction func btnAvailablity(_ sender: Any) {
        guard !trim(str: txtRequestedScreenName.text!).isEmpty else {
            spaceDescr = ScreenNameMessage
            MethodForErrorShow()
            return
        }
        WebServiceForCheckUserNameAvailability()
    }
    // MARK: - Check TermAndCondition Action
    @IBAction func btnTermAndCondition(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermAndConditionVC") as! TermAndConditionVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    // MARK: - Continue Button Action
    @IBAction func btnContinue(_ sender: Any) {
        guard validateData() else { return }
        WebServiceForGetOTP()
    }
    //MARK: Text Field Did End Editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtRequestedScreenName {
            guard !trim(str: txtRequestedScreenName.text!).isEmpty else {
                return
            }
            WebServiceForCheckUserNameAvailability()
        }
    }
    //MARK: Screen Name API / Web Service
    func WebServiceForCheckUserNameAvailability() {
        let parameter: [String: Any] = [
            Screen_Name:self.txtRequestedScreenName.text!,
        ]
        print("request params: \(parameter)")
        MBProgressStart()
        APIManager.callAPIBYPOST(parameter: parameter, url: ApiBaseURL + CheckMemberID, OnResultBlock: { (response, status) in
            print("------\(response)------")
            let dictResponse = response
            if status == "true" {
                let dictData = dictResponse[DATA] as? NSDictionary
                print(dictData ?? "")
                if dictData != nil{
                    if  dictData?.value(forKey: STATUS) as! String == Status_Code100 {//Success
                        MPProgressFinish()
                        let strAvialable = dictData?.value(forKey: RESPONSE) as? String
                        if(strAvialable == "Available"){
                            self.isVerifyUserName = true
                            spaceDescr = ScreenAvailable
                            self.MethodForErrorShow()
                        }else{
                            self.isVerifyUserName = false
                            self.txtRequestedScreenName.text = ""
                            spaceDescr = ScreenNotAvailable
                            self.MethodForErrorShow()
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
    
    //MARK: Get OTP
    func WebServiceForGetOTP() {
        let parameter: [String: Any] = [
            API_Phone_Number:"\(self.lblCountryCode.text!)\(self.txtPhoneNumber.text!)",
            EMAIL:self.txtEmail.text!
        ]
        print("request params: \(parameter)")
        MBProgressStart()
        APIManager.callAPIBYPOST(parameter: parameter, url: ApiBaseURL + RequestOtpTwo, OnResultBlock: { (response, status) in
            print("------\(response)------")
            let dictResponse = response
            if status == "true" {
                
                let parameter: [String: Any] = [
                    Screen_Name:self.txtRequestedScreenName.text!,
                    API_First_Name:self.txtFirstName.text!,
                    API_Last_Name:self.txtLastName.text!,
                    API_EMAIL:self.txtEmail.text!,
                    API_Country:self.txtCountry.text!,
                    API_Phone_Number:"\(self.lblCountryCode.text!)\(self.txtPhoneNumber.text!)",
                    API_Passport_Number:self.txtPassportNumber.text!,
                    API_Service_Plan:self.strPlan,
                    STATUS:"0",
                    API_PASSWORD:self.txtPassword.text!,
                    API_Login_Type:Normal
                ]
                
                let first_name = self.txtFirstName.text!
                let last_name = self.txtLastName.text!
                let country = self.txtCountry.text!
                let name = "\(first_name) \(last_name)"
                UserDefaults_SaveData(dictData: String(country), keyName: kCountry)
                UserDefaults_SaveData(dictData: String(name), keyName: kUserName)
                let passport = self.txtPassportNumber.text!
                UserDefaults_SaveData(dictData: passport, keyName: kPasssportNumber)
                
                
                
                let dictData = dictResponse[DATA] as? NSDictionary
                print(dictData ?? "")
                if dictData != nil{
                    if  dictData?.value(forKey: STATUS) as! String == Status_Code100 {//Success
                        MPProgressFinish()
                        let strverificationCode = dictData?.value(forKey: "otp_verification_code") as! Int
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                        vc.OTP = strverificationCode
                        vc.parameter = parameter
                        self.navigationController?.pushViewController(vc, animated: true)
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
            else{
                MPProgressFinish()
            }
            MPProgressFinish()
        })
    }
    //MARK: Get Countries
    func WebServiceForGetCountries() {
        MBProgressStart()
        APIManager.callAPIBYGET(url: ApiBaseURL + GetCountries, OnResultBlock:{ (response, status) in
            print("------\(response)------")
            let dictResponse = response
            if status == "true" {
                let dictData = dictResponse[DATA] as? NSDictionary
                print(dictData ?? "")
                if dictData != nil{
                    if  dictData?.value(forKey: STATUS) as! String == Status_Code100 {//Success
                        MPProgressFinish()
                        let arrCountries = dictData?.value(forKey: "Countries") as! NSArray
                        self.arrCountries = arrCountries
                        self.simpleDataArrayOfCountry = [String]()
                        for i in 0..<arrCountries.count{
                            let dic = arrCountries.object(at: i) as! NSDictionary
                            let name = dic.object(forKey: "name") as! String
                            self.simpleDataArrayOfCountry.append(name)
                        }
                    }
                    else if dictData?.value(forKey: STATUS) as! String == Status_Code0{//Failure
                        MPProgressFinish()
                        let err = dictData?.value(forKey: ERROR) as? NSDictionary
                        self.view?.makeToast(message:  err?.value(forKey: DISCRIPTION) as? String ?? "", duration: TimeInterval(3.0), position: .center, backgroundColor: .black, messageColor: .white, font: nil)
                    }else if dictData?.value(forKey: STATUS) as! String == Status_Code500{//Failure
                        MPProgressFinish()
                        let err = dictData?.value(forKey: ERROR) as? String
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
    
    //    BKID0ARYAGB
    //    611080100007912
    //MARK: Validate Login Data
    func validateData() -> Bool {
        guard !trim(str: txtFirstName.text!).isEmpty else {
            spaceDescr = FirstNameMessage
            MethodForErrorShow()
            return false
        }
        guard !trim(str: txtLastName.text!).isEmpty else {
            spaceDescr = LastNameMessage
            MethodForErrorShow()
            return false
        }
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
        guard !trim(str: txtPassword.text!).isEmpty else {
            spaceDescr = passwordMessage
            MethodForErrorShow()
            return false
        }
        guard !((txtPassword.text?.count)! < 8 || (txtPassword.text?.count)! > 20) else{
            spaceDescr = passwordRange
            MethodForErrorShow()
            return false
        }
        guard !trim(str: txtPhoneNumber.text!).isEmpty else {
            spaceDescr = PhoneNumberMessage
            MethodForErrorShow()
            return false
        }
        guard !trim(str: txtPassportNumber.text!).isEmpty else {
            spaceDescr = PassportIDMessage
            MethodForErrorShow()
            return false
        }
        guard isVerifyUserName else {
            spaceDescr = UserNameAvailablityMessage
            MethodForErrorShow()
            return false
        }
        guard isAcceptTerm else {
            spaceDescr = TermAndConditionMessage
            MethodForErrorShow()
            return false
        }
        return true
    }
    func isAcceptTermCondition(type: Bool) {
        print(type)
        if type == true {
            isAcceptTerm = true
            self.btnTermCondition.setImage(#imageLiteral(resourceName: "checkYellow"), for: .normal)
        }
    }
}
// MARK: MICountryPickerDelegate
extension RegistrationMan: MICountryPickerDelegate {
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        picker.navigationController?.popViewController(animated: true)
        print(name)
        self.lblCountryCode.text = dialCode
        let bundle = "assets.bundle/"
        //imgCountryFlag.image = UIImage(named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
        imgCountryCode.image = UIImage(named: bundle + code.lowercased() + ".png", in: Bundle(for: MICountryPicker.self), compatibleWith: nil)
    }
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
    }
}


