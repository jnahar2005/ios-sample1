//
//  MemberAreaVC.swift
//  Conexcion
//
//  Created by admin on 20/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MGStarRatingView

class cellMemberArea: UITableViewCell {
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnBlock: UIButton!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var ratingView: StarRatingView!
}
class MemberAreaVC: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    var ArrNotificationList = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.WebServiceForGetNotificationList()
    }
    // MARK: Setup Function
    func viewSetup(){
        let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(btnBackAction))
        self.navigationItem.leftBarButtonItem  = backBarButtonItem
        self.title = "My Contact"
    }
    // MARK: Back Button Action
    @objc func btnBackAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: Info Button Action
    @objc func btnInfoAction(_sender:UIButton) {
        _ = _sender.tag
    }
    // MARK: Block Button Action
    @objc func btnBlockAction(_sender:UIButton) {
        let Tag = _sender.tag
        //        let indexPath = IndexPath(row: Tag, section: 0)
        //        let cell:cellMemberArea = tblView.cellForRow(at: indexPath) as! cellMemberArea
        let Dict = self.ArrNotificationList.object(at: Tag) as? NSDictionary
        let Dic =  LadiesDetail(fromDictionary: Dict as! [String : Any])
        let strTitle = Dic.userFriend
        if strTitle == ""{
            guard let UserID = Dic.id else { return }
            self.WebServiceForAcceptNotification(strFriendID: UserID)
        }else if strTitle == "accept"{
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "CallAndRatingVC") as! CallAndRatingVC
            vc.comeFrom = "MemberArea"
            vc.Dict = Dict!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    //MARK: Get Notification API / Web Service
    @objc func WebServiceForGetNotificationList() {
        let UserId = UserDefaults_FindData(keyName: API_UserId) as! String
        let parameter: [String: Any] = [
            API_UserId:UserId
        ]
        print("request params: \(parameter)")
        MBProgressStart()
        APIManager.callAPIBYPOST(parameter: parameter, url: ApiBaseURL + LadiesUserList, OnResultBlock: { (response, status) in
            print("------\(response)------")
            let dictResponse = response
            if status == "true" {
                let dictData = dictResponse[DATA] as? NSDictionary
                print(dictData ?? "")
                if dictData != nil{
                    let arrRes = dictData?.value(forKey: "LadiesDetails") as? NSArray
                    self.ArrNotificationList = NSArray()
                    self.ArrNotificationList = arrRes!
                    MPProgressFinish()
                    self.tblView.reloadData()
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
    //MARK: WebService For Accept Notification
    func WebServiceForAcceptNotification(strFriendID:String) {
        let UserId = UserDefaults_FindData(keyName: API_UserId) as! String
        let parameter: [String: Any] = [
            "men_id":UserId,
            "women_id":strFriendID
        ]
        print("request params: \(parameter)")
        MBProgressStart()
        APIManager.callAPIBYPOST(parameter: parameter, url: ApiBaseURL + SendFriendRequest, OnResultBlock: { (response, status) in
            print("------\(response)------")
            let dictResponse = response
            if status == "true" {
                let dictData = dictResponse[DATA] as? NSDictionary
                print(dictData ?? "")
                if dictData != nil{
                    if  dictData?.value(forKey: "message") as? String == "Success" {//Success
                        MPProgressFinish()
                        self.WebServiceForGetNotificationList()
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
extension MemberAreaVC: UITableViewDelegate, UITableViewDataSource {
    //MARK:- Table View Number Of Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if self.ArrNotificationList.count > 0
        {
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Contacts Available"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    ///MARK:- Table View Number Of Rows In Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ArrNotificationList.count
    }
    //MARK:- Table View Height For Row At
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90//UITableViewAutomaticDimension
    }
    //MARK:- Table View Estimated Height For Row At
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 146
    //    }
    //MARK:- Table View cell For RowAt indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:cellMemberArea = tableView.dequeueReusableCell(withIdentifier: "cellMemberArea") as! cellMemberArea
        cell.tag = indexPath.section
        let Dict = self.ArrNotificationList.object(at: indexPath.row) as? NSDictionary
        let Dic =  LadiesDetail(fromDictionary: Dict as! [String : Any])
        cell.btnInfo.tag = indexPath.row
        cell.btnBlock.tag = indexPath.row
        let rat = Int(Dic.starRatings)
        cell.ratingView.current = CGFloat(rat ?? 0)
        cell.lblUserName.text = Dic.firstName + " " + Dic.lastName
        cell.lblCountry.text = Dic.country
        let chat = Dic.videoChat ?? "No"
        if chat == "Yes"{
            cell.lblOnline.text = "Online"
            cell.lblOnline.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        }else{
            cell.lblOnline.text = "Offline"
            cell.lblOnline.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        let placeholderImage = UIImage(named: "girl")!
        cell.imgUserProfile.sd_setImage(with: URL(string: Dic.profilePhoto), placeholderImage: placeholderImage)
        let isBlock = Dic.userFriend
        if isBlock == "accept"{
            cell.btnBlock.setTitle("Make a call", for: .normal)
            cell.btnInfo.setImage(#imageLiteral(resourceName: "call-answer"), for: .normal)
            cell.btnBlock.isUserInteractionEnabled = true
        }else if isBlock == "pending"{
            cell.btnBlock.setTitle("Pending", for: .normal)
            cell.btnInfo.setImage(#imageLiteral(resourceName: "hourglass"), for: .normal)
            cell.btnBlock.isUserInteractionEnabled = false
        }else if isBlock == "decline"{
            cell.btnBlock.setTitle("Decline", for: .normal)
            cell.btnInfo.setImage(#imageLiteral(resourceName: "dnd"), for: .normal)
            cell.btnBlock.isUserInteractionEnabled = false
        }else{
            cell.btnBlock.setTitle("Send Call Request", for: .normal)
            cell.btnInfo.setImage(#imageLiteral(resourceName: "call-request"), for: .normal)
            cell.btnBlock.isUserInteractionEnabled = true
        }
        cell.btnInfo.addTarget(self, action: #selector(MemberAreaVC.btnInfoAction(_sender:)), for: .touchUpInside)
        cell.btnBlock.addTarget(self, action: #selector(MemberAreaVC.btnBlockAction(_sender:)), for: .touchUpInside)
        return cell
    }
    
    //MARK:- Table View Did Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let Tag = indexPath.row
        //        let indexPath = IndexPath(row: Tag, section: 0)
        //        let cell:cellMemberArea = tblView.cellForRow(at: indexPath) as! cellMemberArea
        let Dict = self.ArrNotificationList.object(at: Tag) as? NSDictionary
        let Dic =  LadiesDetail(fromDictionary: Dict as! [String : Any])
        let strTitle = Dic.userFriend
        if strTitle == ""{
            guard let UserID = Dic.id else { return }
            self.WebServiceForAcceptNotification(strFriendID: UserID)
        }else if strTitle == "accept"{
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "CallAndRatingVC") as! CallAndRatingVC
            vc.comeFrom = "MemberArea"
            vc.Dict = Dict!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

