//
//  RootVC.swift
//  Conexcion
//
//  Created by admin on 03/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import TTGSnackbar
import RSSelectionMenu

class RootVC: UIViewController {
    @IBOutlet weak var txtCountry: UITextField!
    var isNotificationAvailable = false
    var arrCountries = NSArray()
    var simpleDataArrayOfCountry = [String]()
    var simpleSelectedArrayOfCountry = [String]()
    var DicNotification = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetRoot()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
            self?.txtCountry.text = "    \(item ?? "United States")"
        }
        selectionMenu.show(style: .formSheet, from: self)
    }
    // MARK: - Next Button Action
    @IBAction func btnNext(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.country = txtCountry.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Next Ragister Action
    @IBAction func btnRagister(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GenderVC") as! GenderVC
        self.navigationController?.pushViewController(vc, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func SetRoot(){
        if "\(UserDefaults_FindData(keyName: kAccessToken))" != "" {
            if(isNotificationAvailable == true){
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVCMan") as! HomeVCMan//CollectionsViewController
                viewController.isNotificationAvailable = true;
                viewController.DicNotification = DicNotification
                let navigationController = NavigationController(rootViewController: viewController)
                let mainViewController = MainViewController()
                mainViewController.rootViewController = navigationController
                mainViewController.setup(type: UInt(1))
                appDelegate.window?.rootViewController = mainViewController
                navigationController.setNavigationBarHidden(false, animated: false)
            }else{
                if UserDefaults_FindData(keyName: kRegisterType) as! String == "Man" {
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVCMan") as! HomeVCMan//CollectionsViewController
                    viewController.isNotificationAvailable = false;
                    viewController.DicNotification = DicNotification
                    let navigationController = NavigationController(rootViewController: viewController)
                    let mainViewController = MainViewController()
                    mainViewController.rootViewController = navigationController
                    mainViewController.setup(type: UInt(1))
                    appDelegate.window?.rootViewController = mainViewController
                    navigationController.setNavigationBarHidden(false, animated: false)
                }
                else{
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVCLadies") as! HomeVCLadies//CollectionsViewController
                    viewController.isNotificationAvailable = false;
                    viewController.DicNotification = DicNotification
                    let navigationController = NavigationController(rootViewController: viewController)
                    let mainViewController = MainViewController()
                    mainViewController.rootViewController = navigationController
                    mainViewController.setup(type: UInt(1))
                    appDelegate.window?.rootViewController = mainViewController
                    navigationController.setNavigationBarHidden(false, animated: false)
                }
            }
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1439727247, green: 0.3993673921, blue: 0.4678213596, alpha: 1)
            navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        }
        else{
            self.WebServiceForGetCountries()
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1439727247, green: 0.3993673921, blue: 0.4678213596, alpha: 1)
            navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
            //            navigationController?.navigationBar.barStyle = UIBarStyle.black
            //            navigationController?.navigationBar.isTranslucent = true
        }
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
}

// MARK: MICountryPickerDelegate
extension RootVC: MICountryPickerDelegate {
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        picker.navigationController?.popViewController(animated: true)
        print(name)
        self.txtCountry.text = name
        self.navigationController?.isNavigationBarHidden = true
    }
}
