//
//  HomeVCMan.swift
//  Conexcion
//
//  Created by admin on 07/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class HomeVCMan: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    var isNotificationAvailable = false
    var DicNotification = NSDictionary()
    @IBOutlet private weak var btnTab1: UIButton!
    @IBOutlet private weak var btnTab2: UIButton!
    @IBOutlet private weak var constantViewLeft: NSLayoutConstraint!
    var tab1VC:MemberAreaVC! = nil
    var tab2VC:SearchAreaVC! = nil
    private var pageController: UIPageViewController!
    @IBOutlet private weak var viewLine: UIView!
    private var arrVC:[UIViewController] = []
    private var currentPage: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
        currentPage = 0
        createPageViewController()
    }
    // MARK: Setup Function
    func viewSetup(){
        self.title = "Member Area"
        let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .done, target: self, action: #selector(btnMenuAction))
        let otherBarItemCart = UIBarButtonItem(image: #imageLiteral(resourceName: "pencil-edit-button"), style: .done, target: self, action: #selector(btnEdit))
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1439727247, green: 0.3993673921, blue: 0.4678213596, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationItem.leftBarButtonItem  = backBarButtonItem
        self.navigationItem.rightBarButtonItems  = [otherBarItemCart] //,otherBarItemSearch
        self.navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.redirectionInstroction(_:)), name: NSNotification.Name(rawValue: "SideMenuGetClickEvent"), object: nil)
    }
    // MARK: Menu Action Function
    @objc func btnMenuAction() {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    @objc func redirectionInstroction(_ notification: NSNotification) {
        if let type = notification.userInfo?["MenuOption"] as? String {
            // do something with your image
            print(type)
            if type == "MyProfile"
            {
                
            }else if type == "FAQ"
            {
                let cartController = mainStoryboard.instantiateViewController(withIdentifier: "FAQVCLadies") as! FAQVCLadies
                self.navigationController?.pushViewController(cartController, animated: true)
            }else if type == "PurchaseCredit"
            {
                let cartController = mainStoryboard.instantiateViewController(withIdentifier: "PurchaseCreditVC") as! PurchaseCreditVC
                self.navigationController?.pushViewController(cartController, animated: true)
            }else if type == "ChangePassword"
            {
               
            }
            else
            {
                print("\n\nNo Menu Option Find out\n\n")
            }
        }
    }
    //MARK: - Btn Option Clicked IBaction Methods
    @IBAction private func btnOptionClicked(btn: UIButton) {
        pageController.setViewControllers([arrVC[btn.tag-1]], direction: UIPageViewController.NavigationDirection.reverse, animated: false, completion: {(Bool) -> Void in
        })
        resetTabBarForTag(tag: btn.tag-1)
    }
    //MARK: - selectedButton Methods
    private func selectedButton(btn: UIButton) {
        btn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.007061382756, green: 0.9281100631, blue: 0.9999017119, alpha: 1)
        constantViewLeft.constant = btn.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    //MARK: - unSelectedButton Methods
    private func unSelectedButton(btn: UIButton) {
        btn.setTitleColor(#colorLiteral(red: 0.007061382756, green: 0.9281100631, blue: 0.9999017119, alpha: 1), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    //MARK: - Create Pagination
    private func createPageViewController() {
        pageController = UIPageViewController.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        pageController.view.backgroundColor = UIColor.clear
        pageController.delegate = self
        pageController.dataSource = self
        for svScroll in pageController.view.subviews as! [UIScrollView] {
            svScroll.delegate = self
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pageController.view.frame = CGRect(x: 0, y: 112, width: self.view.frame.size.width, height: self.view.frame.size.height - 112)
        }
        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
        tab1VC = homeStoryboard.instantiateViewController(withIdentifier: "MemberAreaVC") as? MemberAreaVC
        tab2VC = homeStoryboard.instantiateViewController(withIdentifier: "SearchAreaVC") as? SearchAreaVC
        arrVC = [tab1VC,tab2VC]
        pageController.setViewControllers([tab1VC], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        self.addChild(pageController)
        self.view.addSubview(pageController.view)
        pageController.didMove(toParent: self)
    }
    // MARK:index of view Controller Delegate Method
    private func indexofviewController(viewCOntroller: UIViewController) -> Int {
        if(arrVC .contains(viewCOntroller)) {
            return arrVC.firstIndex(of: viewCOntroller)!
        }
        return -1
    }
    //MARK: - Pagination Delegate Methods
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = indexofviewController(viewCOntroller: viewController)
        if(index != -1) {
            index = index - 1
        }
        if(index < 0) {
            return nil
        }
        else {
            return arrVC[index]
        }
    }
    // MARK:Page ViewController Delegate Method
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = indexofviewController(viewCOntroller: viewController)
        if(index != -1) {
            index = index + 1
        }
        if(index >= arrVC.count) {
            return nil
        }
        else {
            return arrVC[index]
        }
    }
    // MARK: Page ViewController Delegate Method
    func pageViewController(_ pageViewController1: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(completed) {
            currentPage = arrVC.firstIndex(of: (pageViewController1.viewControllers?.last)!)
            resetTabBarForTag(tag: currentPage)
        }
    }
    //MARK: - Set Top bar after selecting Option from Top Tabbar
    private func resetTabBarForTag(tag: Int) {
        var sender: UIButton!
        if(tag == 0) {
            sender = btnTab1
        }
        else if(tag == 1) {
            sender = btnTab2
        }
        currentPage = tag
        unSelectedButton(btn: btnTab1)
        unSelectedButton(btn: btnTab2)
        selectedButton(btn: sender)
    }
    //MARK: - UIScrollView Delegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xFromCenter: CGFloat = self.view.frame.size.width-scrollView.contentOffset.x
        let xCoor: CGFloat = CGFloat(viewLine.frame.size.width) * CGFloat(currentPage)
        let xPosition: CGFloat = xCoor - xFromCenter/CGFloat(arrVC.count)
        constantViewLeft.constant = xPosition
    }
    // MARK: Edit Function
    @objc func btnEdit() {
        let cartController = mainStoryboard.instantiateViewController(withIdentifier: "ManEditVC") as! ManEditVC
        self.navigationController?.pushViewController(cartController, animated: true)
    }
    // MARK: Notification Function
    @objc func btnNotification() {
        
    }
}
