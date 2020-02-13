//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//
import LGSideMenuController
import MBProgressHUD
import Alamofire
import AlamofireImage
//import AlamofireImage

class LeftViewController: UITableViewController {
    
    private let titlesArrayWomen = [["img": "user-silhouette" ,"title" : "Profile"],["img": "phone-call" ,"title" : "My Contact"],["img": "money" ,"title" : "My Balance"],["img": "q" ,"title" : "FAQ"],["img": "key-silhouette-security-tool-interface-symbol-of-password" ,"title" : "Change Password"],["img": "power" ,"title" : "Logout"]]
    
    private let titlesArrayMan = [["img": "users-solid" ,"title" : "Member Area"],["img": "user-silhouette" ,"title" : "Profile"],["img": "search" ,"title" : "Search"],["img": "credit-card" ,"title" : "Purchase Credits"],["img": "q" ,"title" : "FAQ"],["img": "key-silhouette-security-tool-interface-symbol-of-password" ,"title" : "Change Password"],["img": "power" ,"title" : "Logout"]]
    
    init() {
        super.init(style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.07022539526, green: 0.6320771575, blue: 0.7816361785, alpha: 1)// #colorLiteral(red: 18.0, green: 161.0, blue: 199.0, alpha: 1.0) //12A1C7
        registerNotifications()
        // view.backgroundColor = .clear
        // self.tableView.sectionHeaderHeight = 70
        // tableView.register(LeftViewCell.self, forCellReuseIdentifier: "cell")
        // tableView.separatorStyle = UIColor.lightGray
        // tableView.contentInset = UIEdgeInsets(top: 44.0, left: 0.0, bottom: 44.0, right: 0.0)
        // tableView.showsVerticalScrollIndicator = false
        // tableView.backgroundColor = .clear
        //tableView.separatorColor = UIColor(red: 250.0/255.0, green: 80.0/255.0, blue: 41.0/255.0, alpha: 1.0)
    }
    
    deinit {
        self.unregisterNotifications()
    }
    
    // ----------------------------------
    //  MARK: - Notifications -
    //
    private func registerNotifications() {
        //NotificationCenter.default.addObserver(self, selector: #selector(updateMyProfile(_:)), name: Notification.Name.UpdateMyProfile, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func updateMyProfile(_ notification: Notification) {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    
    func buttonAction(_ sender: UIButton!) {
        print("Button tapped")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    //  MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        tableView.bounces = false
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==1 {
            if UserDefaults_FindData(keyName: kRegisterType) as! String == "Man"{
                return titlesArrayMan.count
            }else{
                return titlesArrayWomen.count
            }
        }
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        
        //        if "\(UserDefaults_FindData(keyName: kAccessToken))" == "" {
        //            if indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 9 {
        //                return 0
        //            }
        //        }
        
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //-----------User Profile---------------
        if indexPath.section == 0 {
            let CellIdentifier = "Cell"
            var cell = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier)) as? LeftProfileTopCell
            
            if cell == nil {
                var nib = Bundle.main.loadNibNamed("LeftProfileTopCell", owner: self, options: nil)
                cell = nib?[0] as? LeftProfileTopCell
            }
            if "\(UserDefaults_FindData(keyName: kPofileURL))" != "" {
                let strURL = UserDefaults_FindData(keyName: kPofileURL) as! String
                if strURL != ""{
                    let placeholderImage = UIImage(named: "man2")!
                    cell?.imgProfile.sd_setImage(with: URL(string: strURL), placeholderImage: placeholderImage)
                }
            }
            if "\(UserDefaults_FindData(keyName: kUserName))" != "" {
                let strName = UserDefaults_FindData(keyName: kUserName) as? String
                cell?.lblUserName.text = strName ?? "NA"
            }else {
                cell?.lblUserName.text = "NA"
            }
            if "\(UserDefaults_FindData(keyName: kCountry))" != "" {
                let strName = UserDefaults_FindData(keyName: kCountry) as? String
                cell?.lblStates.text = strName ?? "NA"
            }else {
                cell?.lblStates.text = "NA"
            }
            //cell?.imgLogo.image = AppLogoConst
            //let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: (cell?.imgProfile.frame.size)!,radius: (cell?.imgProfile.frame.size.width)! / 2)
            
            cell?.btnProfile.addTarget(self, action: #selector(ClickONProfile), for: .touchUpInside)
            cell?.tag = 111;
            return cell!
        }
        
        //-----------Other Item---------------
        if indexPath.section != 0 {
            let CellIdentifier = "Cell"
            var cell = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier)) as? LeftProfileTopCell
            
            if cell == nil {
                var nib = Bundle.main.loadNibNamed("LeftCell", owner: self, options: nil)
                cell = nib?[0] as? LeftProfileTopCell
            }
            if UserDefaults_FindData(keyName: kRegisterType) as! String == "Man"{
                let dict = titlesArrayMan[indexPath.row] as NSDictionary
                cell?.imgIcon.image = UIImage.init(named: dict["img"] as! String)
                cell?.lblTitle.text = dict["title"] as? String
                return cell!
            }else {
                let dict = titlesArrayWomen[indexPath.row] as NSDictionary
                cell?.imgIcon.image = UIImage.init(named: dict["img"] as! String)
                cell?.lblTitle.text = dict["title"] as? String
                return cell!
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.rootVC_bySelection(indexPath: indexPath)
    }
    
    func goNextCollection(index:Int){
        print(index)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectedIndexShop"), object: index)
        self.hideLeftViewAnimated(Any?.self)
    }
    
    
    func rootVC_bySelection(indexPath: IndexPath) {
        var imageDataDict:[String: String] = ["MenuOption": ""];
        if UserDefaults_FindData(keyName: kRegisterType) as! String == "Man"{
            if indexPath.section == 0 {//UserProfile
                
//                if "\(UserDefaults_FindData(keyName: kAccessToken))" == "" {
//                    self.LoginAction()
//                }
//                return
            }else if indexPath.row == 0 {//Dashboard
                self.hideLeftViewAnimated(Any?.self)
            }else if indexPath.row == 1 {
                imageDataDict = ["MenuOption": "MyProfile"];
               // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuGetClickEvent"), object: nil, userInfo: imageDataDict)
                self.hideLeftViewAnimated(Any?.self)
            }else if indexPath.row == 2 {
                self.hideLeftViewAnimated(Any?.self)
            }else if indexPath.row == 3 {
                imageDataDict = ["MenuOption": "PurchaseCredit"];
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuGetClickEvent"), object: nil, userInfo: imageDataDict)
                self.hideLeftViewAnimated(Any?.self)
            }else if indexPath.row == 4 {
                imageDataDict = ["MenuOption": "FAQ"];
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuGetClickEvent"), object: nil, userInfo: imageDataDict)
                self.hideLeftViewAnimated(Any?.self)
            }else if indexPath.row == 5 {
                imageDataDict = ["MenuOption": "ChangePassword"];
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuGetClickEvent"), object: nil, userInfo: imageDataDict)
                self.hideLeftViewAnimated(Any?.self)
            }else if indexPath.row == 6 {
                LogoutAction()
            }else {
                print("\n\nNothing\n\n")
            }
        }else{
            if indexPath.section == 0 {//UserProfile
                
                if "\(UserDefaults_FindData(keyName: kAccessToken))" == "" {
                    self.LoginAction()
                }
                return
            }else if indexPath.row == 0 {
                self.hideLeftViewAnimated(Any?.self)
            }else if indexPath.row == 1 {
                imageDataDict = ["MenuOption": "MyContact"];
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuGetClickEvent"), object: nil, userInfo: imageDataDict)
                self.hideLeftViewAnimated(Any?.self)
            }else if indexPath.row == 2 {
                imageDataDict = ["MenuOption": "MyBalance"];
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuGetClickEvent"), object: nil, userInfo: imageDataDict)
                self.hideLeftViewAnimated(Any?.self)
            }else if indexPath.row == 3 {
                imageDataDict = ["MenuOption": "FAQ"];
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuGetClickEvent"), object: nil, userInfo: imageDataDict)
                self.hideLeftViewAnimated(Any?.self)
            }else if indexPath.row == 4 {
                imageDataDict = ["MenuOption": "ChangePassword"];
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuGetClickEvent"), object: nil, userInfo: imageDataDict)
                self.hideLeftViewAnimated(Any?.self)
            }else if indexPath.row == 5 {
                LogoutAction()
            }else{
                print("\n\nNothing\n\n")
            }
        }
    }
    func share(message: String, link: String) {
        if let link = NSURL(string: link) {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func LogoutAction(){
        let alertController = UIAlertController(title: "Logout", message: "Are you sure want to logout?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: { (alertAction) -> Void in
        }))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (alertAction) -> Void in
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
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    fileprivate func LoginAction() {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "RootVC") as! RootVC
        let navigationController = UINavigationController(rootViewController: vc)
        appDelegate.window?.rootViewController = navigationController
        appDelegate.window?.makeKeyAndVisible()
        navigationController.setNavigationBarHidden(false, animated: false)
    }
}

//MARK: UIImagePickerControllerDelegate

//MARK:

extension LeftViewController: UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    // MARK: ------- MBProgressHUD Delegate methode -------
    private func MBProgressStart(){
        let HUD =  MBProgressHUD.showAdded(to: self.view, animated: true)
        //HUD.label.text = "Loading..."
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    private func MPProgressFinish(){
        _ = MBProgressHUD.hide(for: self.view, animated: true)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    @objc func ClickONProfile() {
        let camera = DSCameraHandler(delegate_: self)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
            camera.getCameraOn(self, canEdit: true)
        }
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoLibraryOn(self, canEdit: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        let indexPath = IndexPath(row: 0, section:0)
        let cell = self.tableView.cellForRow(at: indexPath) as! LeftProfileTopCell
        cell.imgProfile.image = selectedImage;
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //-----------User info Update------------
    func userSettingUpdate(imgURL: String){
        //        let dict =  (UserDefaults_FindData(keyName: USER_INFO) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        //        dict.setValue(imgURL, forKey: "ProfilePic")
        //        print(dict)
        //        UserDefaults_SaveData(dictData: dict, keyName: USER_INFO)
        //        appDelegate.user = User(dict: dict)
        //        print(appDelegate.user.profilePicURL)
        //        self.tableView.reloadData()
        //        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: (cell?.imgProfile.frame.size)!,radius: (cell?.imgProfile.frame.size.width)! / 2)
        //        cell?.imgProfile.af_setImage(withURL: URL(string: appDelegate.user.profilePicURL)!,placeholderImage: #imageLiteral(resourceName: "Logo"),filter: filter,imageTransition: .crossDissolve(0.2))
    }
}



