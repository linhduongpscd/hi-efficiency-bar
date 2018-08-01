//
//  Define.swift
//  Hi-Efficiency Bar
//
//  Created by Colin Ngo on 1/22/18.
//  Copyright © 2018 QTS Coder. All rights reserved.
//
import UIKit

let APP_DELEGATE   = UIApplication.shared.delegate as! AppDelegate

let APP_NAME = "Hi-Efficiency Bar"

struct FONT_APP {
    static let AlrightSans_Regular  = "AlrightSans-Regular"
    static let AlrightSans_Bold  = "AlrightSans-Bold"
    static let AlrightSans_Medium  = "AlrightSans-Medium"
    static let AlrightSans_Light  = "AlrightSans-Light"
}


struct COLOR_TABBAR {
     static let TAB1  =   UIColor.init(red: 88/255.0, green:  86/255.0, blue:  214/255.0, alpha: 1)
     static let TAB2  =   UIColor.init(red: 255/255.0, green:  154/255.0, blue:  2/255.0, alpha: 1)
     static let TAB3  =   UIColor.init(red: 55/255.0, green:  179/255.0, blue:  2/255.0, alpha: 1)
     static let TAB4  =   UIColor.init(red: 52/255.0, green:  170/255.0, blue:  220/255.0, alpha: 1)
     static let TAB5  =   UIColor.init(red: 255/255.0, green:  45/255.0, blue:  85/255.0, alpha: 1)
    static let UNSELECT  = UIColor.lightGray
}

struct SERVER_CODE {
    static let CODE_200  = 200
    static let CODE_201  = 201
    static let CODE_400  = 400
    static let CODE_403  = 403
}
let COLOR_SELECTED   = UIColor.init(red: 72/255.0, green:  181/255.0, blue:  251/255.0, alpha: 1)
let COLOR_NORMAL   = UIColor.init(red: 89/255.0, green:  109/255.0, blue:  119/255.0, alpha: 1)

let ERROR_NAME  = "First Name is required"
let ERROR_LASTNAME  = "Last Name is required"
let ERROR_EMAIL  = "Email is required"
let ERROR_EMAIL_INVALID  = "Email is invalid"
let ERROR_PASSWORD  = "Password is required"
let ERROR_CONFIRM_PASSWORD = "Confirm password is required"
let ERROR_PASSWORD_NOTMATCH  = "Confirm password do not match"
let ERROR_BIRTHDAY   =  "Birthday is required"
let ERROR_AVATAR   =  "Please select avatar"
let ERROR_ACCEPT  = "Please accept terms or conditions"
let ERROR_CODE  = "Active code is required"
let ALERT_DELETE  = "Do you want to delete?"
let ERROR_NEWPASSWORD  = "New Password is required"
let ERROR_OLDPASSWORD  = "Old Password is required"
let ERROR_CONFIRM_NEW_PASSWORD = "Confirm new password is required"
let ERROR_PASSWORD_NEW_NOTMATCH  = "Confirm password do not match"
let ERROR_OLDPASSWORD_NOT_MATCH  = "The old password is incorrect"
// DEFINE URL
let URL_SERVER  = "http://hiefficiencybar.com/"
let kID   = "kID"
let kToken  = "kToken"
let kLoginApp  = "kLoginApp"
let kPassword  = "kPassword"
let kLimitPage = 20
let kSPEED_REODER = 0.7
let MAX_SECOND = 0.5
let KEY_STRIPE = "pk_test_KSMESnZKrSyuNxek4u6JmQPb"

let CONST_SEARCH_BASICS = 0
let CONST_SEARCH_SPIRITS = 10
let CONST_SEARCH_LIQUERS = 20
let CONST_SEARCH_MIXERS = 30
let CONST_SEARCH_OTHER = 40
let CONST_SEARCH_FRUITS = 50

let CONST_STATUS_ENABLED = 0
let CONST_STATUS_BLOCKED = 10

