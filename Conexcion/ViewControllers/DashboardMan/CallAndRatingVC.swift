//
//  CallAndRatingVC.swift
//  Conexcion
//
//  Created by admin on 20/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MGStarRatingView
import SDWebImage
import BarcodeScanner

class CallAndRatingVC: UIViewController , StarRatingDelegate{
    @IBOutlet weak var ratingView: StarRatingView!
    @IBOutlet weak var ratingView1: StarRatingView!
    @IBOutlet weak var ratingView2: StarRatingView!
    @IBOutlet weak var ratingView3: StarRatingView!
    @IBOutlet weak var ratingView4: StarRatingView!
    @IBOutlet weak var ratingView5: StarRatingView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var imgBarCode: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblLang: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var detailsView: UIView!
    
    var Dict = NSDictionary()
    var userID = ""
    var userEmail = ""
    var comeFrom = ""
    var isNotificationAvailable = false
    var DicNotification = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
        self.detailsView.isHidden = true
    }
    // MARK: Setup Function
    func viewSetup(){
        let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(btnBackAction))
        self.navigationItem.leftBarButtonItem  = backBarButtonItem
        self.title = "Profile"
        ratingView.current = 3
        ratingView1.current = 3
        ratingView2.current = 3
        ratingView3.current = 3
        ratingView4.current = 3
        ratingView5.current = 3
        ratingView1.type = .half
        ratingView2.type = .half
        ratingView3.type = .half
        ratingView4.type = .half
        ratingView5.type = .half
        self.ratingView.delegate = self
        if comeFrom == "MemberArea"{
            let Dic =  LadiesDetail(fromDictionary: self.Dict as! [String : Any])
            self.userID = Dic.id
            self.userEmail = Dic.emailId
            let first_name = Dic.firstName
            let last_name = Dic.lastName
            self.lblUserName.text = first_name! + " " + last_name!
            self.lblCountry.text = Dic.country
            // self.lblEmail.text = Dic.emailId
            self.lblAbout.text = Dic.additionalData
            self.lblLang.text = Dic.languageSpoken
            let rat = Int(Dic.starRatings)
            ratingView.current = CGFloat(rat ?? 0)
            let placeholderImage = UIImage(named: "girl")!
            self.imgUserProfile.sd_setImage(with: URL(string: Dic.profilePhoto), placeholderImage: placeholderImage)
        }else{
            let Dic =  RecentSearchList(fromDictionary: self.Dict as! [String : Any])
            self.userID = Dic.id
            self.userEmail = Dic.emailId
            let first_name = Dic.firstName
            let last_name = Dic.lastName
            self.lblUserName.text = first_name! + " " + last_name!
            self.lblCountry.text = Dic.country
            // self.lblEmail.text = Dic.emailId
            self.lblAbout.text = Dic.additionalData
            self.lblLang.text = Dic.languageSpoken
            let rat = Int(Dic.starRatings)
            ratingView.current = CGFloat(rat ?? 0)
            let placeholderImage = UIImage(named: "girl")!
            self.imgUserProfile.sd_setImage(with: URL(string: Dic.profilePhoto), placeholderImage: placeholderImage)
        }
        
    }
    // MARK: Back Button Action
    @objc func btnBackAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: View Will Appear
    override func viewWillAppear(_ animated: Bool) {
    }
    func StarRatingValueChanged(view: StarRatingView, value: CGFloat) {
        // use value
    }
    // MARK: btn Tap On Rating
    @IBAction func btnTapOnRating(_ sender: Any) {
        let viewController = makeBarcodeScannerViewController()
        viewController.title = "Barcode Scanner"
        present(viewController, animated: true, completion: nil)
    }
    // MARK: btn Tap On Rate Now
    @IBAction func btnRateNow(_ sender: Any) {
        self.detailsView.isHidden = true
        let userId = UserDefaults_FindData(keyName: API_UserId) as! String
        let LadiesProfileId = self.userID
        let general = ratingView1.current
        let gee = ratingView2.current
        let hygiene = ratingView3.current
        let friendleness = ratingView4.current
        let qualtiyoftime = ratingView5.current
        let parameter: [String: Any] = [
            API_UserId:userId,
            "LadiesProfileId":LadiesProfileId,
            "general":general,
            "gee":gee,
            "hygiene":hygiene,
            "friendleness":friendleness,
            "qualtiyoftime":qualtiyoftime
        ]
        self.WebServiceForSubmitRating(param: parameter)
    }
    // MARK: btn Tap VIdeo Chat
    @IBAction func btnTapOnVIdeoChat(_ sender: Any) {
        
    }
    
    private func makeBarcodeScannerViewController() -> BarcodeScannerViewController {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        return viewController
    }
    //MARK: WebService For Accept Notification
    func WebServiceForSubmitRating(param : [String: Any]) {
        let parameter: [String: Any] = param
        print("request params: \(parameter)")
        MBProgressStart()
        APIManager.callAPIBYPOST(parameter: parameter, url: ApiBaseURL + GiveRatings, OnResultBlock: { (response, status) in
            print("------\(response)------")
            let dictResponse = response
            if status == "true" {
                let dictData = dictResponse[DATA] as? NSDictionary
                print(dictData ?? "")
                if dictData != nil{
                    if  dictData?.value(forKey: "description") as? String == "ADDED" {//Success
                        MPProgressFinish()
                        self.view?.makeToast(message:  "Thanks For Rating", duration: TimeInterval(3.0), position: .center, backgroundColor: .black, messageColor: .white, font: nil)
                    }
                    else {//Failure
                        MPProgressFinish()
                        let err = dictData?.value(forKey: "message") as? String
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
}

// MARK: - BarcodeScannerCodeDelegate

extension CallAndRatingVC: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("Barcode Data: \(code)")
        print("Symbology Type: \(type)")
        if(code == self.userEmail){
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                controller.dismiss(animated: true, completion: nil)
                self.detailsView.isHidden = false
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                controller.resetWithError()
            }
        }
        //controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - BarcodeScannerErrorDelegate
extension CallAndRatingVC: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
}

// MARK: - BarcodeScannerDismissalDelegate
extension CallAndRatingVC: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
