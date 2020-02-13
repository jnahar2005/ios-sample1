//
//  NotificationListDict.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 19, 2019

import Foundation


class NotificationListDict : NSObject, NSCoding{

    var additionalData : String!
    var barcode : String!
    var country : String!
    var createdDate : String!
    var createdAt : String!
    var creditAmount : String!
    var currentStatus : String!
    var deviceType : String!
    var emailId : String!
    var expiredDate : String!
    var firstName : String!
    var friendRequestId : String!
    var friendRequestStatus : String!
    var gender : String!
    var id : String!
    var languageSpoken : String!
    var lastName : String!
    var latitude : String!
    var location : String!
    var loginType : String!
    var longitude : String!
    var memberId : String!
    var opponentId : String!
    var otpVerificationCode : String!
    var otpVerificationStatus : String!
    var passportNumber : String!
    var password : String!
    var phoneNumber : String!
    var profilePhoto : String!
    var servicePlanId : String!
    var starRatings : String!
    var state : String!
    var status : String!
    var twilioToken : String!
    var updatedDate : String!
    var updatedAt : String!
    var userId : String!
    var videoChat : String!
    var womenDeviceToken : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        additionalData = dictionary["additional_data"] as? String
        barcode = dictionary["barcode"] as? String
        country = dictionary["country"] as? String
        createdDate = dictionary["created_date"] as? String
        createdAt = dictionary["createdAt"] as? String
        creditAmount = dictionary["credit_amount"] as? String
        currentStatus = dictionary["current_status"] as? String
        deviceType = dictionary["device_type"] as? String
        emailId = dictionary["email_id"] as? String
        expiredDate = dictionary["expired_date"] as? String
        firstName = dictionary["first_name"] as? String
        friendRequestId = dictionary["friendRequestId"] as? String
        friendRequestStatus = dictionary["friendRequestStatus"] as? String
        gender = dictionary["gender"] as? String
        id = dictionary["id"] as? String
        languageSpoken = dictionary["language_spoken"] as? String
        lastName = dictionary["last_name"] as? String
        latitude = dictionary["latitude"] as? String
        location = dictionary["location"] as? String
        loginType = dictionary["login_type"] as? String
        longitude = dictionary["longitude"] as? String
        memberId = dictionary["member_id"] as? String
        opponentId = dictionary["opponentId"] as? String
        otpVerificationCode = dictionary["otp_verification_code"] as? String
        otpVerificationStatus = dictionary["otp_verification_status"] as? String
        passportNumber = dictionary["passport_number"] as? String
        password = dictionary["password"] as? String
        phoneNumber = dictionary["phone_number"] as? String
        profilePhoto = dictionary["profile_photo"] as? String
        servicePlanId = dictionary["service_plan_id"] as? String
        starRatings = dictionary["star_ratings"] as? String
        state = dictionary["state"] as? String
        status = dictionary["status"] as? String
        twilioToken = dictionary["twilio_token"] as? String
        updatedDate = dictionary["updated_date"] as? String
        updatedAt = dictionary["updatedAt"] as? String
        userId = dictionary["userId"] as? String
        videoChat = dictionary["video_chat"] as? String
        womenDeviceToken = dictionary["women_device_token"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if additionalData != nil{
            dictionary["additional_data"] = additionalData
        }
        if barcode != nil{
            dictionary["barcode"] = barcode
        }
        if country != nil{
            dictionary["country"] = country
        }
        if createdDate != nil{
            dictionary["created_date"] = createdDate
        }
        if createdAt != nil{
            dictionary["createdAt"] = createdAt
        }
        if creditAmount != nil{
            dictionary["credit_amount"] = creditAmount
        }
        if currentStatus != nil{
            dictionary["current_status"] = currentStatus
        }
        if deviceType != nil{
            dictionary["device_type"] = deviceType
        }
        if emailId != nil{
            dictionary["email_id"] = emailId
        }
        if expiredDate != nil{
            dictionary["expired_date"] = expiredDate
        }
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if friendRequestId != nil{
            dictionary["friendRequestId"] = friendRequestId
        }
        if friendRequestStatus != nil{
            dictionary["friendRequestStatus"] = friendRequestStatus
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if id != nil{
            dictionary["id"] = id
        }
        if languageSpoken != nil{
            dictionary["language_spoken"] = languageSpoken
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
        if latitude != nil{
            dictionary["latitude"] = latitude
        }
        if location != nil{
            dictionary["location"] = location
        }
        if loginType != nil{
            dictionary["login_type"] = loginType
        }
        if longitude != nil{
            dictionary["longitude"] = longitude
        }
        if memberId != nil{
            dictionary["member_id"] = memberId
        }
        if opponentId != nil{
            dictionary["opponentId"] = opponentId
        }
        if otpVerificationCode != nil{
            dictionary["otp_verification_code"] = otpVerificationCode
        }
        if otpVerificationStatus != nil{
            dictionary["otp_verification_status"] = otpVerificationStatus
        }
        if passportNumber != nil{
            dictionary["passport_number"] = passportNumber
        }
        if password != nil{
            dictionary["password"] = password
        }
        if phoneNumber != nil{
            dictionary["phone_number"] = phoneNumber
        }
        if profilePhoto != nil{
            dictionary["profile_photo"] = profilePhoto
        }
        if servicePlanId != nil{
            dictionary["service_plan_id"] = servicePlanId
        }
        if starRatings != nil{
            dictionary["star_ratings"] = starRatings
        }
        if state != nil{
            dictionary["state"] = state
        }
        if status != nil{
            dictionary["status"] = status
        }
        if twilioToken != nil{
            dictionary["twilio_token"] = twilioToken
        }
        if updatedDate != nil{
            dictionary["updated_date"] = updatedDate
        }
        if updatedAt != nil{
            dictionary["updatedAt"] = updatedAt
        }
        if userId != nil{
            dictionary["userId"] = userId
        }
        if videoChat != nil{
            dictionary["video_chat"] = videoChat
        }
        if womenDeviceToken != nil{
            dictionary["women_device_token"] = womenDeviceToken
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        additionalData = aDecoder.decodeObject(forKey: "additional_data") as? String
        barcode = aDecoder.decodeObject(forKey: "barcode") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        createdDate = aDecoder.decodeObject(forKey: "created_date") as? String
        createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
        creditAmount = aDecoder.decodeObject(forKey: "credit_amount") as? String
        currentStatus = aDecoder.decodeObject(forKey: "current_status") as? String
        deviceType = aDecoder.decodeObject(forKey: "device_type") as? String
        emailId = aDecoder.decodeObject(forKey: "email_id") as? String
        expiredDate = aDecoder.decodeObject(forKey: "expired_date") as? String
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String
        friendRequestId = aDecoder.decodeObject(forKey: "friendRequestId") as? String
        friendRequestStatus = aDecoder.decodeObject(forKey: "friendRequestStatus") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        languageSpoken = aDecoder.decodeObject(forKey: "language_spoken") as? String
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        location = aDecoder.decodeObject(forKey: "location") as? String
        loginType = aDecoder.decodeObject(forKey: "login_type") as? String
        longitude = aDecoder.decodeObject(forKey: "longitude") as? String
        memberId = aDecoder.decodeObject(forKey: "member_id") as? String
        opponentId = aDecoder.decodeObject(forKey: "opponentId") as? String
        otpVerificationCode = aDecoder.decodeObject(forKey: "otp_verification_code") as? String
        otpVerificationStatus = aDecoder.decodeObject(forKey: "otp_verification_status") as? String
        passportNumber = aDecoder.decodeObject(forKey: "passport_number") as? String
        password = aDecoder.decodeObject(forKey: "password") as? String
        phoneNumber = aDecoder.decodeObject(forKey: "phone_number") as? String
        profilePhoto = aDecoder.decodeObject(forKey: "profile_photo") as? String
        servicePlanId = aDecoder.decodeObject(forKey: "service_plan_id") as? String
        starRatings = aDecoder.decodeObject(forKey: "star_ratings") as? String
        state = aDecoder.decodeObject(forKey: "state") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        twilioToken = aDecoder.decodeObject(forKey: "twilio_token") as? String
        updatedDate = aDecoder.decodeObject(forKey: "updated_date") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String
        userId = aDecoder.decodeObject(forKey: "userId") as? String
        videoChat = aDecoder.decodeObject(forKey: "video_chat") as? String
        womenDeviceToken = aDecoder.decodeObject(forKey: "women_device_token") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if additionalData != nil{
            aCoder.encode(additionalData, forKey: "additional_data")
        }
        if barcode != nil{
            aCoder.encode(barcode, forKey: "barcode")
        }
        if country != nil{
            aCoder.encode(country, forKey: "country")
        }
        if createdDate != nil{
            aCoder.encode(createdDate, forKey: "created_date")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "createdAt")
        }
        if creditAmount != nil{
            aCoder.encode(creditAmount, forKey: "credit_amount")
        }
        if currentStatus != nil{
            aCoder.encode(currentStatus, forKey: "current_status")
        }
        if deviceType != nil{
            aCoder.encode(deviceType, forKey: "device_type")
        }
        if emailId != nil{
            aCoder.encode(emailId, forKey: "email_id")
        }
        if expiredDate != nil{
            aCoder.encode(expiredDate, forKey: "expired_date")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
        }
        if friendRequestId != nil{
            aCoder.encode(friendRequestId, forKey: "friendRequestId")
        }
        if friendRequestStatus != nil{
            aCoder.encode(friendRequestStatus, forKey: "friendRequestStatus")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "gender")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if languageSpoken != nil{
            aCoder.encode(languageSpoken, forKey: "language_spoken")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "last_name")
        }
        if latitude != nil{
            aCoder.encode(latitude, forKey: "latitude")
        }
        if location != nil{
            aCoder.encode(location, forKey: "location")
        }
        if loginType != nil{
            aCoder.encode(loginType, forKey: "login_type")
        }
        if longitude != nil{
            aCoder.encode(longitude, forKey: "longitude")
        }
        if memberId != nil{
            aCoder.encode(memberId, forKey: "member_id")
        }
        if opponentId != nil{
            aCoder.encode(opponentId, forKey: "opponentId")
        }
        if otpVerificationCode != nil{
            aCoder.encode(otpVerificationCode, forKey: "otp_verification_code")
        }
        if otpVerificationStatus != nil{
            aCoder.encode(otpVerificationStatus, forKey: "otp_verification_status")
        }
        if passportNumber != nil{
            aCoder.encode(passportNumber, forKey: "passport_number")
        }
        if password != nil{
            aCoder.encode(password, forKey: "password")
        }
        if phoneNumber != nil{
            aCoder.encode(phoneNumber, forKey: "phone_number")
        }
        if profilePhoto != nil{
            aCoder.encode(profilePhoto, forKey: "profile_photo")
        }
        if servicePlanId != nil{
            aCoder.encode(servicePlanId, forKey: "service_plan_id")
        }
        if starRatings != nil{
            aCoder.encode(starRatings, forKey: "star_ratings")
        }
        if state != nil{
            aCoder.encode(state, forKey: "state")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if twilioToken != nil{
            aCoder.encode(twilioToken, forKey: "twilio_token")
        }
        if updatedDate != nil{
            aCoder.encode(updatedDate, forKey: "updated_date")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updatedAt")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }
        if videoChat != nil{
            aCoder.encode(videoChat, forKey: "video_chat")
        }
        if womenDeviceToken != nil{
            aCoder.encode(womenDeviceToken, forKey: "women_device_token")
        }
    }
}