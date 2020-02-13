//
//  GenderVC.swift
//  Conexcion
//
//  Created by admin on 03/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class GenderVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    // MARK: Setup Function
    func viewSetup(){
        let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(btnBackAction))
        self.navigationItem.leftBarButtonItem  = backBarButtonItem
        self.title = "Select Gender"
    }
    // MARK: Back Button Action
    @objc func btnBackAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Gender Man Button Action
    @IBAction func btnMan(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationMan") as! RegistrationMan
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Gender Woman Button Action
    @IBAction func btnWoman(_ sender: Any) {
        self.showCustomAlertWith(
            message: "Sorry!!",
            descMsg: "This is under development",
            itemimage: nil,
            actions: nil)
    }
}
