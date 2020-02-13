//
//  FAQVCLadies.swift
//  Conexcion
//
//  Created by admin on 17/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class FAQVCLadies: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    // MARK: Setup Function
    func viewSetup(){
        let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(btnBackAction))
        self.navigationItem.leftBarButtonItem  = backBarButtonItem
        self.title = "FAQ"
    }
    // MARK: Back Button Action
    @objc func btnBackAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
