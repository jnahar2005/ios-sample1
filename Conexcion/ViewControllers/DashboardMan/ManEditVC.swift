//
//  ManEditVC.swift
//  Conexcion
//
//  Created by admin on 24/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import RSSelectionMenu

class ManEditVC: UIViewController {
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPassportNumber: UITextField!
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
        self.title = "Edit Profile"
        self.WebServiceForGetCountries()
        
        if "\(UserDefaults_FindData(keyName: kUserName))" != "" {
            let strName = UserDefaults_FindData(keyName: kUserName) as? String
            let delimiter = " "
            let fname = strName!.components(separatedBy: delimiter).first
            let Lname = strName!.components(separatedBy: delimiter).last
            self.txtFirstName.text = fname
            self.txtLastName.text = Lname
            
        }else {
            self.txtFirstName.text = "NA"
            self.txtLastName.text = "NA"
        }
        if "\(UserDefaults_FindData(keyName: kCountry))" != "" {
            let strName = UserDefaults_FindData(keyName: kCountry) as? String
            self.txtCountry.text = strName ?? "NA"
        }else {
            self.txtCountry.text = "NA"
        }
        if "\(UserDefaults_FindData(keyName: kPasssportNumber))" != "" {
            let strName = UserDefaults_FindData(keyName: kPasssportNumber) as? String
            self.txtPassportNumber.text = strName ?? "NA"
        }else {
            self.txtCountry.text = "NA"
        }
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
    //Mark:- BtnSelectValvue Action
    @IBAction func BtnUpdate(_ sender: UIButton) {
        guard validateData() else { return }
        WebServiceForUpdateProfile()
    }
    //MARK: Web Service For Update Profile
    func WebServiceForUpdateProfile() {
        self.view?.makeToast(message: "Profile Updated", duration: TimeInterval(2.0), position: .center, backgroundColor: .black, messageColor: .white, font: nil)
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.btnBackAction), userInfo: nil, repeats: false)
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
            MPProgressFinish()
        })
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
        guard !trim(str: txtPassportNumber.text!).isEmpty else {
            spaceDescr = PassportIDMessage
            MethodForErrorShow()
            return false
        }
        return true
    }
}
