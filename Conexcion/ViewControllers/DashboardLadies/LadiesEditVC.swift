//
//  LadiesEditVC.swift
//  Conexcion
//
//  Created by admin on 25/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import RSSelectionMenu
import Alamofire

class LadiesEditVC: UIViewController , UINavigationControllerDelegate ,UITextFieldDelegate, UIImagePickerControllerDelegate{
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPassportNumber: UITextField!
    @IBOutlet weak var btnLang1: UIButton!
    @IBOutlet weak var btnLang2: UIButton!
    @IBOutlet weak var btnLang3: UIButton!
    @IBOutlet weak var btnLang4: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var textViewAboutMe: UITextView!
    @IBOutlet weak var txtReadyForConexion: UITextField!
    @IBOutlet weak var txtVideoChat: UITextField!
    var imgProfileSet = UIImage()
    var iconClick = true
    var strEnglish = ""
    var strSpanish = ""
    var strFrench = ""
    var strPortuguese = ""
    var strLanguage = "English"
    var strImageUploadedUrl = ""
    var arrCountries = NSArray()
    var arrStates = NSArray()
    var simpleDataArrayOfCountry = [String]()
    var simpleDataArrayOfCity = [String]()
    var simpleSelectedArrayOfCountry = [String]()
    var simpleSelectedArrayOfCity = [String]()
    var simpleArrayFirstDropDown = ["Ready For Conexion", "Not Available For Conexion"]
    var simpleArraySecondDropDown = ["Yes","No"]
    var simpleSelectedArrayFirstDropDown = [String]()
    var simpleSelectedArraySecondDropDown = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    // MARK: View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        self.WebServiceForGetUserInformation()
    }
    // MARK: Setup Function
    func viewSetup(){
        let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(btnBackAction))
        self.navigationItem.leftBarButtonItem  = backBarButtonItem
        self.title = "Edit Profile"
        self.btnProfile.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        strEnglish = "English";
        strSpanish = "";
        strFrench = "";
        strPortuguese = "";
        strLanguage = "English"
        self.WebServiceForGetCountries()
    }
    // MARK: Back Button Action
    @objc func btnBackAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Choose Plan Action
    @IBAction func btnPlan(_ sender: UIButton) {
        let Tag = sender.tag
        strLanguage = ""
        if Tag == 1 {
            strEnglish = strEnglish != "English" ? "English" : ""
        }else if Tag == 2 {
            strSpanish = strSpanish != "Spanish" ? "Spanish" : ""
        }else if Tag == 3 {
            strFrench = strFrench != "French" ? "French" : ""
        }else if Tag == 4 {
            strPortuguese = strPortuguese != "Portuguese" ? "Portuguese" : ""
        }
        //Mark:- Set string of selected Languages.
        if(strEnglish != ""){
            btnLang1.setImage(#imageLiteral(resourceName: "checkYellow"), for: .normal)
            strLanguage = strLanguage + "\(strEnglish),"
        }else{  btnLang1.setImage(#imageLiteral(resourceName: "uncheckWhite"), for: .normal) }
        if(strSpanish != ""){
            btnLang2.setImage(#imageLiteral(resourceName: "checkYellow"), for: .normal)
            strLanguage = strLanguage + "\(strSpanish),"
        }else{  btnLang2.setImage(#imageLiteral(resourceName: "uncheckWhite"), for: .normal) }
        if(strFrench != ""){
            btnLang3.setImage(#imageLiteral(resourceName: "checkYellow"), for: .normal)
            strLanguage = strLanguage + "\(strFrench),"
        }else{  btnLang3.setImage(#imageLiteral(resourceName: "uncheckWhite"), for: .normal) }
        if(strPortuguese != ""){
            btnLang4 .setImage(#imageLiteral(resourceName: "checkYellow"), for: .normal)
            strLanguage = strLanguage + "\(strPortuguese)"
        }else{  btnLang4.setImage(#imageLiteral(resourceName: "uncheckWhite"), for: .normal) }
        print(strLanguage)
    }
    // MARK:- Add photo
    @IBAction func btnChoosePhoto(_ sender: Any) {
        let camera = DSCameraHandler(delegate_: self)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
            camera.getCameraOn(self, canEdit: true)
        }
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoLibraryOn(self, canEdit: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    // MARK:- Picker Delegate method
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imgProfileSet = selectedImage;
        //        self.btnProfile.setImage(nil, for: .normal)
        //        self.btnProfile.setBackgroundImage(nil, for: .normal)
        self.btnProfile.setImage(selectedImage, for: .normal)
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        self.WebServiceForUploadUserProfile()
    }
    // MARK: -Did Cancel Image Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSelectCountry(_ sender: Any) {
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
            if (self?.txtCountry.text != item){
                self?.txtState.text = ""
            }
            self?.txtCountry.text = item
            if let list = self?.arrCountries {
                for i in 0..<list.count {
                    let dic = self?.arrCountries.object(at: i) as! NSDictionary
                    let name = dic.object(forKey: "name") as! String
                    if(name == item){
                        let ID = dic.object(forKey: "id") as! String
                        self?.WebServiceForGetState(countryID: ID)
                        return
                    }
                }
            }
        }
        selectionMenu.show(style: .formSheet, from: self)
    }
    
    @IBAction func btnSelectState(_ sender: Any) {
        if(simpleDataArrayOfCity.count < 1){
            spaceDescr = UnavailableMessage
            MethodForErrorShow()
            txtState.text = "Unavailable"
            return
        }
        let selectionMenu = RSSelectionMenu(dataSource: simpleDataArrayOfCity) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        // show searchbar
        selectionMenu.showSearchBar(withPlaceHolder: "Select Country", barTintColor: #colorLiteral(red: 0.9991930127, green: 0.7329201102, blue: 0, alpha: 1)) { (searchtext) -> ([String]) in
            return self.simpleDataArrayOfCity.filter {$0.contains(searchtext) || $0.contains(searchtext.lowercased()) || $0.contains(searchtext.uppercased())}
        }
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        selectionMenu.navigationController?.navigationBar.titleTextAttributes = textAttributes
        selectionMenu.navigationController?.navigationBar.barTintColor = UIColor.black
        selectionMenu.setSelectedItems(items: simpleSelectedArrayOfCity) { [weak self] (item, index, isSelected, selectedItems) in
            self?.simpleSelectedArrayOfCity = selectedItems
            self?.txtState.text = item
        }
        selectionMenu.show(style: .formSheet, from: self)
    }
    // MARK: Current Status Drop Down Action
    @IBAction func btnCurrentStatusAction(_ sender: Any) {
        let selectionMenu = RSSelectionMenu(dataSource: simpleArrayFirstDropDown) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        selectionMenu.navigationController?.navigationBar.titleTextAttributes = textAttributes
        selectionMenu.navigationController?.navigationBar.barTintColor = UIColor.black
        selectionMenu.setSelectedItems(items: simpleSelectedArrayFirstDropDown) { [weak self] (item, index, isSelected, selectedItems) in
            self?.simpleSelectedArrayFirstDropDown = selectedItems
            self?.txtReadyForConexion.text = item
        }
        selectionMenu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: self.txtReadyForConexion.frame.size.width , height: 45)), from: self)
    }
    // MARK: Video Chat Drop Down Action
    @IBAction func btnVideoChatAction(_ sender: Any) {
        let selectionMenu = RSSelectionMenu(dataSource: simpleArraySecondDropDown) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        selectionMenu.navigationController?.navigationBar.titleTextAttributes = textAttributes
        selectionMenu.navigationController?.navigationBar.barTintColor = UIColor.black
        selectionMenu.setSelectedItems(items: simpleSelectedArraySecondDropDown) { [weak self] (item, index, isSelected, selectedItems) in
            self?.simpleSelectedArraySecondDropDown = selectedItems
            self?.txtVideoChat.text = item
        }
        selectionMenu.show(style: .popover(sourceView: sender as! UIView, size: CGSize(width: self.txtReadyForConexion.frame.size.width , height: 45)), from: self)
    }
    //MARK: Web Service For Get UserInformation
    func WebServiceForGetUserInformation() {
        let UserId = UserDefaults_FindData(keyName: API_UserId) as! String
        let parameter: [String: Any] = [
            API_UserId:UserId
        ]
        print("request params: \(parameter)")
        MBProgressStart()
        APIManager.callAPIBYPOST(parameter: parameter, url: ApiBaseURL + UserDetailProfile, OnResultBlock: { (response, status) in
            print("------\(response)------")
            let dictResponse = response
            if status == "true" {
                let dictData = dictResponse[DATA] as? NSDictionary
                print(dictData ?? "")
                if dictData != nil{
                    let arrRes = dictData?.value(forKey: "Userdetail") as? NSArray
                    if  arrRes?.count ?? 0 > 0{//Success
                        MPProgressFinish()
                        let Dict = arrRes?.object(at: 0) as? NSDictionary
                        let Dic =  UserInformationDictRootClass(fromDictionary: Dict as! [String : Any])
                        let usrID = Dic.id
                        let gender = Dic.gender
                        let profilePhoto = Dic.profilePhoto
                        let first_name = Dic.firstName
                        let last_name = Dic.lastName
                        let country = Dic.country
                        let name = "\(first_name ?? "NA") \(last_name ?? "NA")"
                        let Service_Plan_ID = Dic.servicePlanId
                        UserDefaults_SaveData(dictData:Service_Plan_ID ?? "", keyName: kService_Plan_ID)
                        UserDefaults_SaveData(dictData:String(usrID ?? ""), keyName: API_UserId)
                        UserDefaults_SaveData(dictData: String(usrID ?? ""), keyName: kAccessToken)
                        UserDefaults_SaveData(dictData: String(profilePhoto ?? ""), keyName: kPofileURL)
                        UserDefaults_SaveData(dictData: String(country ?? ""), keyName: kCountry)
                        UserDefaults_SaveData(dictData: String(name), keyName: kUserName)
                        let passport = Dic.passportNumber
                        UserDefaults_SaveData(dictData: String(passport ?? ""), keyName: kPasssportNumber)
                        UserDefaults_SaveData(dictData: String(Dic.emailId ?? ""), keyName: API_EMAIL)
                        if (gender! == "Female"){
                            UserDefaults_SaveData(dictData: "Woman", keyName: kRegisterType)
                        }else{
                            UserDefaults_SaveData(dictData: "Man", keyName: kRegisterType)
                        }
                        self.txtFirstName.text = Dic.firstName
                        self.txtLastName.text = Dic.lastName
                        self.txtCountry.text = Dic.country
                        self.txtState.text = Dic.state
                        self.txtPassportNumber.text = Dic.passportNumber
                        self.textViewAboutMe.text = Dic.additionalData
                        self.txtReadyForConexion.text = Dic.currentStatus
                        self.txtVideoChat.text = Dic.videoChat
                        self.strLanguage = Dic.languageSpoken
                        let strPhoto = Dic.profilePhoto
                        if (strPhoto != "" && strPhoto != nil){
                            let url = URL(string: Dic.profilePhoto)!
                            let placeholderImage = UIImage(named: "photoUpload3")!
                            self.btnProfile?.sd_setImage(with: url, for: .normal, placeholderImage: placeholderImage)
                        }
                        if(self.strLanguage.contains("English")){
                            self.strEnglish = "English"
                            self.btnLang1.setImage(#imageLiteral(resourceName: "checkYellow"), for: .normal)
                        }
                        if(self.strLanguage.contains("Spanish")){
                            self.strSpanish = "Spanish"
                            self.btnLang2.setImage(#imageLiteral(resourceName: "checkYellow"), for: .normal)
                        }
                        if(self.strLanguage.contains("French")){
                            self.strFrench = "French"
                            self.btnLang3.setImage(#imageLiteral(resourceName: "checkYellow"), for: .normal)
                        }
                        if(self.strLanguage.contains("Portuguese")){
                            self.strPortuguese = "Portuguese"
                            self.btnLang4.setImage(#imageLiteral(resourceName: "checkYellow"), for: .normal)
                        }
                    }else{
                        MPProgressFinish()
                    }
                }else{
                    MPProgressFinish()
                }
                
            }
            else{//Failure
                MPProgressFinish()
            }
            MPProgressFinish()
        })
    }
    // MARK: - Continue Button Action
    @IBAction func btnContinue(_ sender: Any) {
        guard validateData() else { return }
        self.WebServiceForUpdateProfile()
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
    //MARK: Get State
    
    func WebServiceForGetState(countryID : String) {
        MBProgressStart()
        let parameter: [String: Any] = [
            API_CountryId:countryID
        ]
        print("request params: \(parameter)")
        APIManager.callAPIBYPOST(parameter: parameter, url: ApiBaseURL + GetState, OnResultBlock: { (response, status) in
            print("------\(response)------")
            let dictResponse = response
            if status == "true" {
                let dictData = dictResponse[DATA] as? NSDictionary
                print(dictData ?? "")
                if dictData != nil{
                    if  dictData?.value(forKey: STATUS) as! String == Status_Code100 {//Success
                        MPProgressFinish()
                        let arrStates = dictData?.value(forKey: "States") as! NSArray
                        self.arrStates = arrStates
                        self.simpleDataArrayOfCity = [String]()
                        for i in 0..<arrStates.count{
                            let dic = arrStates.object(at: i) as! NSDictionary
                            let name = dic.object(forKey: "name") as! String
                            self.simpleDataArrayOfCity.append(name)
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
    func WebServiceForUploadUserProfile(){
        let parameter = [String: Any]()
        APIManager.callAPIWithImage(parameter: parameter as NSDictionary, url: ApiBaseURL + UploadImage, image: imgProfileSet, imageKeyName: "image", OnResultBlock: { (response, status) in
            print("------\(response)------")
            let dictResponse = response
            if status == "true" {
                let dictData = dictResponse
                print(dictData)
                if  dictData.value(forKey: STATUS) as! String == Status_Code100 {//Success
                    MPProgressFinish()
                    let strUrl = dictData.value(forKey: url) as? String
                    self.strImageUploadedUrl = strUrl ?? ""
                    let url = URL(string: self.strImageUploadedUrl)!
                    let placeholderImage = UIImage(named: "photoUpload3")!
                    self.btnProfile?.sd_setImage(with: url, for: .normal, placeholderImage: placeholderImage)
                }
                else if dictData.value(forKey: STATUS) as! String == Status_Code0{
                    MPProgressFinish()
                    let err = dictData.value(forKey: ERROR) as? NSDictionary
                    self.view?.makeToast(message:  err?.value(forKey: DISCRIPTION) as? String ?? "", duration: TimeInterval(3.0), position: .center, backgroundColor: .black, messageColor: .white, font: nil)
                }else if dictData.value(forKey: STATUS) as! String == Status_Code500{//Failure
                    MPProgressFinish()
                    let err = dictData.value(forKey: ERROR) as? String
                    self.view?.makeToast(message:  err ?? "", duration: TimeInterval(3.0), position: .center, backgroundColor: .black, messageColor: .white, font: nil)
                }else{
                    MPProgressFinish()
                }
            }
            else{//Failure
                MPProgressFinish()
            }
            //RSLoadingView.hide(from: self.view)
            MPProgressFinish()
        })
    }
    
    //MARK: Web Service For Update Profile
    func WebServiceForUpdateProfile() {
        self.view?.makeToast(message: "Profile Updated", duration: TimeInterval(2.0), position: .center, backgroundColor: .black, messageColor: .white, font: nil)
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.btnBackAction), userInfo: nil, repeats: false)
    }
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
        guard !trim(str: txtCountry.text!).isEmpty else {
            spaceDescr = CountryMessage
            MethodForErrorShow()
            return false
        }
        guard !trim(str: txtState.text!).isEmpty else {
            spaceDescr = StateMessage
            MethodForErrorShow()
            return false
        }
        
        guard !trim(str: txtPassportNumber.text!).isEmpty else {
            spaceDescr = PassportIDMessage
            MethodForErrorShow()
            return false
        }
        guard !trim(str: textViewAboutMe.text!).isEmpty else {
            spaceDescr = AboutMeMessage
            MethodForErrorShow()
            return false
        }
        guard !trim(str: strLanguage).isEmpty else {
            spaceDescr = LanguageMessage
            MethodForErrorShow()
            return false
        }
        return true
    }
}
