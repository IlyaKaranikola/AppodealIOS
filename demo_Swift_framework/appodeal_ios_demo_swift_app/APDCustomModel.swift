//
//  APDCustomModel.swift
//  appodeal_ios_demo_swift_app
//
//  Created by Lozhkin Ilya on 2/15/17.
//  Copyright © 2017 Lozhkin Ilya. All rights reserved.
//

import UIKit
import Appodeal

class APDDemoModel: NSObject {
    var interstitial : Bool
    var banner : Bool
    var rewardedVideo : Bool
    var MREC : Bool
    var nativeAds : Bool
    var nonSkipVideo : Bool
    
    var adType : AppodealAdType = []
    var locationTracking : Bool
    var autoCache : Bool
    
    var testMode : Bool
    var toastMode : Bool
    
    var bannerSmartSize : Bool
    var bannerAnimation : Bool
    var bannerBackground : Bool
    
    override init() {
        interstitial = true
        banner = true
        rewardedVideo = true
        MREC = true
        nativeAds = true
        nonSkipVideo = true
        
        adType = [.interstitial, .rewardedVideo, .banner, .MREC, .nativeAd, .nonSkippableVideo]
        locationTracking = false
        autoCache = true
        
        testMode = false
        toastMode = true
        
        bannerSmartSize = true
        bannerAnimation = false
        bannerBackground = false
    }
}

class APDUserDataModel: NSObject {
    var userSettings : Bool

    var userId : String
    var userEmail :String
    var userBirthday : Date
    var userAge : UInt
    var userGender : AppodealUserGender
    var userOccupation : AppodealUserOccupation
    var userRelationship : AppodealUserRelationship
    var userSmokingAttitude : AppodealUserSmokingAttitude
    var userAlcoholAttitude : AppodealUserAlcoholAttitude
    var userInterests : String
    
    override init () {
        userSettings = true
        userId = "1"
        userEmail = "test@test.net"
        userBirthday = Date.init(timeIntervalSince1970: 123123)
        userAge = 22
        userGender = AppodealUserGender.male
        userOccupation = AppodealUserOccupation.work
        userRelationship = AppodealUserRelationship.married
        userSmokingAttitude = AppodealUserSmokingAttitude.neutral
        userAlcoholAttitude = AppodealUserAlcoholAttitude.neutral
        userInterests = "cars"
    }
}
