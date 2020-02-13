//
//  LoginVC.swift
//  Conexcion
//
//  Created by admin on 03/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController ,GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnShowPass: UIButton!
    var sigNIn = GIDSignIn()
    var strImgUrl = ""
    var country = ""
    var sourceGUID = ""
    var iconClick = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    // MARK: Setup Function
    func viewSetup(){
        self.navigationController?.isNavigationBarHidden = false
        let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(btnBackAction))
        self.navigationItem.leftBarButtonItem  = backBarButtonItem
        self.title = "Login"
    }
    // MARK: Back Button Action
    @objc func btnBackAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: - See Password Action
    @IBAction func eyeAction(sender: AnyObject) {
        if(iconClick == true) {
            txtPass.isSecureTextEntry = false
            self.btnShowPass.setImage(#imageLiteral(resourceName: "hidePass"), for: .normal)
        } else {
            txtPass.isSecureTextEntry = true
            self.btnShowPass.setImage(#imageLiteral(resourceName: "showPass"), for: .normal)
        }
        iconClick = !iconClick
    }
    // MARK: - Create Account Woman Button Action
    @IBAction func btnCreateAccount(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GenderVC") as! GenderVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Forgot Password Button Action
    @IBAction func btnForgotPasswordSignin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Facebook Signin Button Action
    @IBAction func btnFacebookSignin(_ sender: Any) {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile","email","user_friends"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email")) {
                    MBProgressStart()
                }
            }
        }
    }
    // MARK: - Google Signin Button Action
    @IBAction func btnGoogleSignin(_ sender: Any) {
        GIDSignIn.sharedInstance().uiDelegate = self
        sigNIn = GIDSignIn.sharedInstance()
        sigNIn.shouldFetchBasicProfile = true;
        sigNIn.delegate = self;
        sigNIn.uiDelegate = self;
        sigNIn.signIn()
        // btnGoogle.isEnabled=false
    }
    // MARK:  Login Button Action
    @IBAction func btnLoginSignin(_ sender: Any) {
        guard validateData() else { return }
        WebServiceForLogin()
    }
    //MARK: Login API / Web Service
    func WebServiceForLogin() {
        let parameter: [String: Any] = [
            //API_USER_NAME:self.txtEmail.text!,
            API_EMAIL:self.txtEmail.text!,
            API_PASSWORD:self.txtPass.text!,
            API_DEVICE_TYPE:user_device_type,
            Women_Device_Token:kDeviceToken//GCM_TOKEN
        ]
        print("request params: \(parameter)")
        MBProgressStart()
        APIManager.callAPIBYPOST(parameter: parameter, url: ApiBaseURL + AppUserLogin, OnResultBlock: { (response, status) in
            print("------\(response)------")
            let dictResponse = response
            if status == "true" {
                let dictData = dictResponse[DATA] as? NSDictionary
                print(dictData ?? "")
                if dictData != nil{
                    if  dictData?.value(forKey: STATUS) as! String == Status_Code100 {//Success
                        MPProgressFinish()
                        let strAvialable = dictData?.value(forKey: "description") as! String
                        if(strAvialable == "Logged in Success "){
                            let arrRes = dictData?.value(forKey: RESPONSE) as? NSArray
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
                            
                            if (gender! == "Female"){
                                UserDefaults_SaveData(dictData: "Woman", keyName: kRegisterType)
                                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVCLadies") as! HomeVCLadies//CollectionsViewController
                                viewController.isNotificationAvailable = false;
                                let navigationController = NavigationController(rootViewController: viewController)
                                let mainViewController = MainViewController()
                                mainViewController.rootViewController = navigationController
                                mainViewController.setup(type: UInt(1))
                                appDelegate.window?.rootViewController = mainViewController
                                navigationController.setNavigationBarHidden(false, animated: false)
                            }else{
                                UserDefaults_SaveData(dictData: "Man", keyName: kRegisterType)
                                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeVCMan") as! HomeVCMan//CollectionsViewController
                                viewController.isNotificationAvailable = false;
                                let navigationController = NavigationController(rootViewController: viewController)
                                let mainViewController = MainViewController()
                                mainViewController.rootViewController = navigationController
                                mainViewController.setup(type: UInt(1))
                                appDelegate.window?.rootViewController = mainViewController
                                navigationController.setNavigationBarHidden(false, animated: false)
                            }
                        }else{
                            MPProgressFinish()
                            self.view?.makeToast(message:  strAvialable , duration: TimeInterval(3.0), position: .center, backgroundColor: .black, messageColor: .white, font: nil)
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
        guard !trim(str: txtPass.text!).isEmpty else {
            spaceDescr = passwordMessage
            MethodForErrorShow()
            return false
        }
        return true
    }
    //-----------------GOOGLE SIGN IN------------------
    //MARK :GOOGLE SIGN IN DELEGATE METHODS
    private func signInWillDispatch(signIn: GIDSignIn!, error: Error!) {
        MBProgressStart()
    }
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:Get Data From Google
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let email = user.profile.email
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    private func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                        withError error: Error!) {
    }
    
    private func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true) { () -> Void in
        }
    }
 
}
