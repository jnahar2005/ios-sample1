//
//  TermAndConditionVC.swift
//  Conexcion
//
//  Created by admin on 04/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import WebKit

protocol TermDelegate
{
    func isAcceptTermCondition(type: Bool)
}

class TermAndConditionVC: UIViewController ,WKNavigationDelegate,WKUIDelegate{
    
    @IBOutlet weak var viewForFrame: UITextView!
    var webView: WKWebView!
    var delegate:TermDelegate?
    var isSelect = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //Mark:- Button Accept Action
    @IBAction func btnAccept(_ sender: Any) {
        delegate?.isAcceptTermCondition(type: true)
        self.dismiss(animated: true, completion: nil)
    }
    //Mark:- Button Close Action
    @IBAction func btnClose(_ sender: Any) {
        delegate?.isAcceptTermCondition(type: false)
        self.dismiss(animated: true, completion: nil)
    }
}
