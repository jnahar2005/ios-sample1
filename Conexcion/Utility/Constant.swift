//
//  Constant.swift
//  Shared
//
//  Created by admin on 4/09/19.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

var timeToAutoHide = 2.0
var shouldAutoHide = true
var leftSwipeAccepted = true
var topSwipeAccepted = true
var rightSwipeAccepted = true
var botSwipeAccepted = true
var spaceStyle: SpaceStyles? = nil
var spaceTitle = ""
var spaceDescr = "Description"
var withImage = false
var spacePosition: SpacePosition = .bot
var possibleDirectionsToHide: [HideDirection] = []

let ERROR_NO_RECORD = "Server Error."
let DEFAULT_TOKEN = "adadadfgfhgdhjsfgjsdgfhjgdsfhjgsjhfg"
let kTokenExpireDate = "kTokenExpireDate"
let kAccessToken = "kAccessToken"
let kDeviceToken = "kDeviceToken"
let KUser_Id = "user_id"
let kOTP = "OTP"
let kPLAN_ID = "PLAN_ID"
let kENTRY_VIEW = "ENTRY_VIEW"
let kService_Plan_ID = "service_plan_id"
let kRegisterType = "kRegisterType"
let kPofileURL = "kPofileURL"
let kUserName = "kUserName"
let kCountry = "kCountry"
let kPasssportNumber = "kPasssportNumber"

let GOOGLE_CLIENT_KEY = "911006028042-bb5e965b35ia3d5h1v183ij7n464pka9.apps.googleusercontent.com"
// MARK:- Login / Sign UP Parameter
let API_USER_NAME = "user_name"
let API_EMAIL = "email_id"
let API_New_Pass = "new_pwd"
let EMAIL = "email"
let API_gmailId = "gmailId"
let API_PASSWORD = "password"
let API_DEVICE_TYPE = "DeviceType"
let GCM_TOKEN = "GCM_TOKEN"
let Women_Device_Token = "WomenDeviceToken"
let STATUS = "status"
let RESULT = "result"
let RESPONSE = "Response"
let MESSAGE = "Message"
let DATA = "data"
let Status_Code200 = "200"
let Status_Code100 = "100"
let Status_Code0 = "0"
let Status_Code500 = "500"
let ERROR = "error"
let url = "url"
let DISCRIPTION = "description"
let Screen_Name = "screen_name"
let API_First_Name = "first_name"
let API_Last_Name = "last_name"
let API_Country = "country"
let API_Passport_Number = "passport_number"
let API_Login_Type = "login_type"
let API_Service_Plan = "service_plan"
let API_Phone_Number = "phone_number"
let API_AMO_NEW = "AMO_NEW"
let Normal = "Normal"
let API_OtpCode = "OtpCode"
var API_UserId = "userId"
var API_CountryId = "countryId"
var API_language_spoken = "language_spoken"
var API_State = "state"
var API_about_me = "about_me"
var API_Video_chat = "video_chat"
var API_Current_status = "current_status"
var API_Profile_photo = "profile_photo"
var API_Location = "location"
var API_Latitude = "latitude"
var API_Longitude = "longitude"
let API_FriendRequestId = "friendRequestId"

// MARK:- Login / APIs Base URLs 
let ApiBaseURL  = "http://203.100.68.130:88/conexcion_web/conexcion/api/"

// MARK:-Sub API URLs
let AppUserLogin = "AppUserLogin"
let CheckMemberID = "checkMemberID"
let MenRegister = "MenRegister"
let RequestOtpTwo = "RequestOtpTwo"
let SuccessOtpVerification = "SuccessOtpVerification"
let GetCountries = "getCountries"
let GetState = "getState"
let UploadImage = "uploadImage"
let forgetPassword = "forgetPassword"
let OtherAppLogin = "OtherAppLogin"
let UserDetailProfile = "UserDetailProfile"
let ManageConnexion = "manageConnexion"
let LocationUpdate = "LocationUpdate"
let getUserFriendList = "getUserFriendList"
let actionFriendRequest = "actionFriendRequest"
let LadiesUserList = "LadiesUserList"
let SendFriendRequest = "sendFriendRequest"
let GetUserFriendMaleList = "getUserFriendMaleList"
let MenProfile = "MenProfile"
let GiveRatings = "GiveRatings"

// MARK:- Validation Error Messages
let emailMessage            = "Email is required."
let passwordMessage         = "Password is required."
let emailInvalidMessage     = "Please enter valid email."
let FirstNameMessage            = "First name is required."
let OTPMessage            = "Please enter OTP."
let OTPErrorMessage            = "OTP code incorrect, please enter correct OTP code."
let LastNameMessage         = "Last name is required."
let PhoneNumberMessage     = "Phone number is required."
let PassportIDMessage     = "Passport ID is required."
let UserNameAvailablityMessage     = "Please check user name availablity"
let ScreenNameMessage     = "Please enter screen name"
let TermAndConditionMessage     = "Please accept term and condition"
let passwordRange         = "Password must be between 8 to 20 characters."
let ScreenAvailable         = "Great! Your Screen Name Available"
let ScreenNotAvailable         = "Screen Name Not Available"
let ProfileImageMessage         = "Please choose profile image"
let CountryMessage         = "Please select country"
let StateMessage         = "Please select state"
let LanguageMessage         = "Please select atleast one language"
let UnavailableMessage         = "Unavailable States"
let AboutMeMessage            = "Please Enter About Me"
let oldpasswordMessage         = "Old password is required."
let newPasswordMessage         = "New password is required."
let confirmPasswordMessage         = "Confirm password is required."
let misMatchMessage         = "Password mismatch."
let PleaseSelectCredits = "Please select a Credits"



//let API_USER_TYPE_ID = "UserTypeID"
//let API_FIRST_NAME = "FirstName"
//let API_LAST_NAME = "LastName"
//let API_USER_NAME = "Username"
//
//let API_GENDER = "Gender"
//let API_DOB = "BirthDate"
//let API_ADDRESS = "Address"
//let API_PHONE_NUMBER = "PhoneNumber"
//let API_SOURCE = "Source"
//let API_SOURCE_GUID = "SourceGUID"
//
//let API_DEVICE_GUID = "DeviceGUID"
//let API_DEVICE_TOKEN = "DeviceToken"
//let API_IP_ADDRESS = "IPAddress"


