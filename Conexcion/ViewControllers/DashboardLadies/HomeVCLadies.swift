//
//  HomeVCLadies.swift
//  Conexcion
//
//  Created by admin on 07/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MGStarRatingView
import CoreLocation

class HomeVCLadies: UIViewController , StarRatingDelegate ,CLLocationManagerDelegate{
    @IBOutlet weak var ratingView: StarRatingView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var imgBarCode: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblLang: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    var isNotificationAvailable = false
    var DicNotification = NSDictionary()
    var locationLat: Double = 0.0
    var locationLong: Double = 0.0
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    // MARK: Setup Function
    func viewSetup(){
        self.title = "My Profile"
        let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .done, target: self, action: #selector(btnMenuAction))
        let otherBarItemSearch = UIBarButtonItem(image: #imageLiteral(resourceName: "bell-solid"), style: .done, target: self, action: #selector(btnNotification))
        let otherBarItemCart = UIBarButtonItem(image: #imageLiteral(resourceName: "pencil-edit-button"), style: .done, target: self, action: #selector(btnEdit))
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1439727247, green: 0.3993673921, blue: 0.4678213596, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationItem.leftBarButtonItem  = backBarButtonItem
        self.navigationItem.rightBarButtonItems  = [otherBarItemCart,otherBarItemSearch] // ,otherBarItemSearch
        self.navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.redirectionInstroction(_:)), name: NSNotification.Name(rawValue: "SideMenuGetClickEvent"), object: nil)
        
        if "\(UserDefaults_FindData(keyName: kPofileURL))" != "" {
            let strURL = UserDefaults_FindData(keyName: kPofileURL) as! String
            if strURL != ""{
                let placeholderImage = UIImage(named: "girl")!
                self.imgUserProfile.sd_setImage(with: URL(string: strURL), placeholderImage: placeholderImage)
            }
        }
        if "\(UserDefaults_FindData(keyName: kUserName))" != "" {
            let strName = UserDefaults_FindData(keyName: kUserName) as? String
            self.lblUserName.text = strName ?? "NA"
        }else {
            self.lblUserName.text = "NA"
        }
        if "\(UserDefaults_FindData(keyName: kCountry))" != "" {
            let strName = UserDefaults_FindData(keyName: kCountry) as? String
            self.lblState.text = strName ?? "NA"
            self.lblCountry.text = strName ?? "NA"
        }else {
            self.lblState.text = "NA"
            self.lblCountry.text = "NA"
        }
        ratingView.current = 3
        self.ratingView.delegate = self
    }
    // MARK: View Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        self.WebServiceForGetUserInformation()
    }
    // MARK: Menu Action Function
    @objc func btnMenuAction() {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    // MARK: Edit Function
    @objc func btnEdit() {
        let LadiesEditVC = mainStoryboard.instantiateViewController(withIdentifier: "LadiesEditVC") as! LadiesEditVC
        self.navigationController?.pushViewController(LadiesEditVC, animated: true)
    }
    // MARK: Notification Function
    @objc func btnNotification() {
    }
    // MARK: Cancel Membership Button Action
    @IBAction func btnCancelMembership(_ sender: Any) {
        self.WebServiceForCancelMembership()
    }
    @objc func redirectionInstroction(_ notification: NSNotification) {
        if let type = notification.userInfo?["MenuOption"] as? String {
            // do something with your image
            print(type)
            if type == "MyBalance"
            {
                let cartController = mainStoryboard.instantiateViewController(withIdentifier: "MyBalanceVCLadies") as! MyBalanceVCLadies
                self.navigationController?.pushViewController(cartController, animated: true)
            }else if type == "FAQ"
            {
                let cartController = mainStoryboard.instantiateViewController(withIdentifier: "FAQVCLadies") as! FAQVCLadies
                self.navigationController?.pushViewController(cartController, animated: true)
            }else if type == "MyContact"
            {
                
            }else if type == "ChangePassword"
            {
                
            }
            else
            {
                print("\n\nNo Menu Option Find out\n\n")
            }
        }
    }
    //MARK: Location did Update Locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        locationLat = locValue.latitude
        locationLong = locValue.longitude
        locationManager.stopUpdatingLocation()
        self.WebServiceForLocationUpdate()
    }
    
    //MARK: Location did Fail Wit hError
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    //MARK: Location Update
    func WebServiceForLocationUpdate(){
        let UserId = UserDefaults_FindData(keyName: API_UserId) as! String
        let parameter: [String: Any] = [
            API_UserId:UserId,
            API_Latitude:locationLat,
            API_Longitude:locationLong
        ]
        print("request params: \(parameter)")
        APIManager.callAPIBYPOST(parameter: parameter, url: ApiBaseURL + LocationUpdate, OnResultBlock: { (response, status) in
            print("------\(response)------")
            MPProgressFinish()
        })
    }
    //MARK: Login API / Web Service
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
                        let passport = Dic.passportNumber
                        let name = "\(first_name ?? "NA") \(last_name ?? "NA")"
                        let Service_Plan_ID = Dic.servicePlanId
                        UserDefaults_SaveData(dictData:Service_Plan_ID ?? "", keyName: kService_Plan_ID)
                        UserDefaults_SaveData(dictData:String(usrID ?? ""), keyName: API_UserId)
                        UserDefaults_SaveData(dictData: String(usrID ?? ""), keyName: kAccessToken)
                        UserDefaults_SaveData(dictData: String(profilePhoto ?? ""), keyName: kPofileURL)
                        UserDefaults_SaveData(dictData: String(country ?? ""), keyName: kCountry)
                        UserDefaults_SaveData(dictData: String(name), keyName: kUserName)
                        UserDefaults_SaveData(dictData: String(passport ?? ""), keyName: kPasssportNumber)
                        UserDefaults_SaveData(dictData: String(Dic.emailId ?? ""), keyName: API_EMAIL)
                        if (gender! == "Female"){
                            UserDefaults_SaveData(dictData: "Woman", keyName: kRegisterType)
                        }else{
                            UserDefaults_SaveData(dictData: "Man", keyName: kRegisterType)
                        }
                        self.lblEmail.text = Dic.emailId
                        self.lblAbout.text = Dic.additionalData
                        self.lblLang.text = Dic.languageSpoken
                        //let url = URL(string: Dic.barcode)!
                        //self.imgBarCode.af_setImage(withURL: url)
                        self.handleOperationWithData(data: Dic.barcode)
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
    //MARK: Cancel Membership
    func WebServiceForCancelMembership(){
        let UserId = UserDefaults_FindData(keyName: API_UserId) as! String
        let EmailId = UserDefaults_FindData(keyName: API_EMAIL) as! String
        let parameter: [String: Any] = [
            API_UserId:UserId,
            API_EMAIL:EmailId
        ]
        print("request params: \(parameter)")
        MBProgressStart()
        APIManager.callAPIBYPOST(parameter: parameter, url: ApiBaseURL + ManageConnexion, OnResultBlock: { (response, status) in
            print("------\(response)------")
            let dictResponse = response
            if status == "true" {
                let dictData = dictResponse[DATA] as? NSDictionary
                print(dictData ?? "")
                if dictData != nil{
                    if  dictData?.value(forKey: MESSAGE) as? String == "Success" {//Success
                        MPProgressFinish()
                        self.view?.makeToast(message:  "Profile Cancellation Request sent to admin.", duration: TimeInterval(3.0), position: .center, backgroundColor: .black, messageColor: .white, font: nil)
                        _ = Timer.scheduledTimer(timeInterval: 3.1, target: self, selector: #selector(self.LogoutAction), userInfo: nil, repeats: false)
                    }
                    else {//Failure
                        MPProgressFinish()
                        let err = dictData?.value(forKey: MESSAGE) as? String
                        self.view?.makeToast(message:  err ?? "", duration: TimeInterval(3.0), position: .center, backgroundColor: .black, messageColor: .white, font: nil)
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
    //MARK: Logout Action
    @objc func LogoutAction(){
        DispatchQueue.main.async() {
            if "\(UserDefaults_FindData(keyName: kAccessToken))" != "" {
                let token = UserDefaults_FindData(keyName: kAccessToken)
                if let appDomain = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    UserDefaults.standard.synchronize()
                }
                //UserDefaults_SaveData(dictData: token, keyName: kAccessToken)
            }
            self.LoginAction()
        }
    }
    fileprivate func LoginAction() {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "RootVC") as! RootVC
        let navigationController = UINavigationController(rootViewController: vc)
        appDelegate.window?.rootViewController = navigationController
        appDelegate.window?.makeKeyAndVisible()
        navigationController.setNavigationBarHidden(false, animated: false)
    }
    //MARK: String to Image Data and asign barcode image
    func handleOperationWithData(data: String) {
        //let dataNew = Data(data.utf8)
        let url:NSURL = NSURL(string : data)!
        let imageData:NSData = NSData.init(contentsOf: url as URL)!
        if let image = UIImage(data: imageData as Data) {
            self.imgBarCode.image = image
        }
    }
    func StarRatingValueChanged(view: StarRatingView, value: CGFloat) {
        // use value
    }
}

