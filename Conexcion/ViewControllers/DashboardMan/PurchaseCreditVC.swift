//
//  PurchaseCreditVC.swift
//  Conexcion
//
//  Created by admin on 21/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PurchaseCreditVC: UIViewController {
    var strPlan = ""
    var planSel = 0;
    @IBOutlet weak var btnPlan1: UIButton!
    @IBOutlet weak var btnPlan2: UIButton!
    @IBOutlet weak var btnPlan3: UIButton!
    @IBOutlet weak var btnPlan4: UIButton!
    @IBOutlet weak var btnPlan5: UIButton!
    @IBOutlet weak var btnPlan6: UIButton!
    @IBOutlet weak var btnPlan7: UIButton!
    @IBOutlet weak var btnPlan8: UIButton!
    @IBOutlet weak var btnPlan9: UIButton!
    @IBOutlet weak var viewPaymentOption: UIView!
    @IBOutlet weak var btnStripe: UIButton!
    @IBOutlet weak var btnPaypal: UIButton!
    var strPayoutType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    // MARK: Setup Function
    func viewSetup(){
        self.viewPaymentOption.isHidden = true
        let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(btnBackAction))
        self.navigationItem.leftBarButtonItem  = backBarButtonItem
        self.title = "Purchase Credits"
    }
    // MARK: Back Button Action
    @objc func btnBackAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: Close Popup Button Action
    @IBAction func btnClosePopup(_ sender: Any) {
        self.viewPaymentOption.isHidden = true
    }
    // MARK: Stripe Payout Button Action
    @IBAction func btnStripePayout(_ sender: Any) {
        self.strPayoutType = "Stripe"
        btnPaypal.setImage(#imageLiteral(resourceName: "payoutuncheck"), for: .normal)
        btnStripe.setImage(#imageLiteral(resourceName: "payoutCheck"), for: .normal)
    }
    // MARK: Paypal Payout Button Action
    @IBAction func btnPaypalPayout(_ sender: Any) {
        self.strPayoutType = "Paypal"
        btnPaypal.setImage(#imageLiteral(resourceName: "payoutCheck"), for: .normal)
        btnStripe.setImage(#imageLiteral(resourceName: "payoutuncheck"), for: .normal)
    }
    // MARK: Done Button Action
    @IBAction func btnDone(_ sender: Any) {
        if(strPayoutType == ""){
            spaceDescr = "Please Select One Payment Option"
            MethodForErrorShow()
            return
        }
        self.viewPaymentOption.isHidden = true
    }
    //Mark:- BtnSelectValvue Action
    @IBAction func BtnSelectValvue(_ sender: UIButton) {
        strPlan = ""
        planSel = 0;
        let Tag = sender.tag
        btnPlan1.backgroundColor = #colorLiteral(red: 0.07022539526, green: 0.6320771575, blue: 0.7816361785, alpha: 1)
        btnPlan2.backgroundColor = #colorLiteral(red: 0.07022539526, green: 0.6320771575, blue: 0.7816361785, alpha: 1)
        btnPlan3.backgroundColor = #colorLiteral(red: 0.07022539526, green: 0.6320771575, blue: 0.7816361785, alpha: 1)
        btnPlan4.backgroundColor = #colorLiteral(red: 0.07022539526, green: 0.6320771575, blue: 0.7816361785, alpha: 1)
        btnPlan5.backgroundColor = #colorLiteral(red: 0.07022539526, green: 0.6320771575, blue: 0.7816361785, alpha: 1)
        btnPlan6.backgroundColor = #colorLiteral(red: 0.07022539526, green: 0.6320771575, blue: 0.7816361785, alpha: 1)
        btnPlan7.backgroundColor = #colorLiteral(red: 0.07022539526, green: 0.6320771575, blue: 0.7816361785, alpha: 1)
        btnPlan8.backgroundColor = #colorLiteral(red: 0.07022539526, green: 0.6320771575, blue: 0.7816361785, alpha: 1)
        btnPlan9.backgroundColor = #colorLiteral(red: 0.07022539526, green: 0.6320771575, blue: 0.7816361785, alpha: 1)
        if Tag == 1 {
            btnPlan1.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            planSel = 1;
        }else if Tag == 2 {
            btnPlan2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            planSel = 2;
        }else if Tag == 3 {
            btnPlan3.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            planSel = 3;
        }else if Tag == 4 {
            btnPlan4.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            planSel = 4;
        }else if Tag == 5 {
            btnPlan5.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            planSel = 5;
        }else if Tag == 6 {
            btnPlan6.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            planSel = 6;
        }else if Tag == 7 {
            btnPlan7.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            planSel = 7;
        }else if Tag == 8 {
            btnPlan8.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            planSel = 8;
        }else if Tag == 9 {
            btnPlan9.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            planSel = 9;
        }
    }
    //Mark:- Btn Proceed Action
    @IBAction func BtnProceed(_ sender: UIButton) {
        if planSel == 0 {
            spaceDescr = PleaseSelectCredits
            MethodForErrorShow()
            return
        }
        if(strPayoutType == ""){
            self.viewPaymentOption.isHidden = false
        }else{
            //Webservice
        }
    }
}
