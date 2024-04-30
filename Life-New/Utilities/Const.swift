//
//  Const.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 20/12/23.
//

import Foundation
import SwiftUI

let APP_ID = "6468493305"
let RevenueCatApiKey = ""
let privacyPolicyURL = "\(WebServices.base)privacyPolicy"
let termsOfUseURL = "\(WebServices.base)termsOfUse"
let rateThisAppURL = "https://apps.apple.com/us/app/id\(APP_ID)?action=write-review"

struct WebServices {
    static let base                     = "https://admin.alisdaily.com/"
    static let baseURL                  = base + "api/"
    static let uploadbaseURL            = base + "/public/storage/"
    static let HeaderValue              = "----"
    static let HeaderKey                = "apikey"   
    
    static let appSlogan = "SOUND FOR LIFE"
    static var notificationToken = "-"
    static var notificationTopic = "life"
}

struct SessionKeys {
    static let language = "language"
    static let isPro = "isPro"
    static let isLogin = "isLogin"
    static let isNotificationOn = "isNotificationOn"
    static let selectedTime = "selectedTime"
    static let isTimerOn = "isTimerOn"
}

struct Constant {
    static let lightLinearGradient = LinearGradient(colors: [.lightGredientOne, .lightGredientTwo], startPoint: .top, endPoint: .bottom)
    static let linearGradient = LinearGradient(stops: [.init(color: .darkBlueOne, location: 0.0),
                                             .init(color: .darkBlueTwo, location: 0.25),
                                             .init(color: .darkBlueThree, location: 1),
    ], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let commonGradientColors = [Color.darkBlueOne,Color.darkBlueTwo,Color.darkBlueThree]
    static let lightGredientColor = [Color.lightGredientOne,Color.lightGredientTwo]
}

struct Device {
    static let height = UIScreen.main.bounds.height
    static let width = UIScreen.main.bounds.width
    static var topSafeArea = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    static var bottomSafeArea = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
}

extension Optional where Wrapped == String {
    func addBaseURL() -> URL {
        let url = URL(string: "\(WebServices.uploadbaseURL)\(self?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") ?? URL(string: "www.google.com")!
       return url
    }
}

extension String {
    func addBaseURL() -> URL {
        let url = URL(string: "\(WebServices.uploadbaseURL)\(self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") ?? URL(string: "www.google.com")!
       return url
    }
}

