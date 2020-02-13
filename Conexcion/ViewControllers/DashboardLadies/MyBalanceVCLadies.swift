//
//  MyBalanceVCLadies.swift
//  Conexcion
//
//  Created by admin on 17/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MyBalanceVCLadies: UIViewController {
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
        self.title = "My Balance"
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
    // MARK: Withdraw Money Button Action
    @IBAction func btnWithdrawMoney(_ sender: Any) {
        if(strPayoutType == ""){
            self.viewPaymentOption.isHidden = false
        }else{
            //Webservice
        }
    }
}
