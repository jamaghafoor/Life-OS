//
//  AppDelegate.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 10/01/24.
//

import SwiftUI
import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseMessaging
import RevenueCat
import GoogleMobileAds


class AppDelegate: NSObject, UIApplicationDelegate,PurchasesDelegate {
    @AppStorage(SessionKeys.isNotificationOn) var isNotificationOn = true
    static public let shared = AppDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        registerNotification()
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: RevenueCatApiKey, appUserID: "\(SessionManager.shared.getUser().id ?? 0)")
        Purchases.shared.delegate = self
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        BaseViewModel().checkUserIsPro(customerInfo: customerInfo)
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate, MessagingDelegate {
    func registerNotification(){
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in
        })
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken {
            WebServices.notificationToken = fcmToken
            let dataDict: [String: String] = ["token": fcmToken]
            print(dataDict)
            if isNotificationOn {
                self.subscribeTopic()
            } else {
                self.unSubscribeTopic()
            }
        }
    }
    
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
        
        completionHandler([[.banner, .badge, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func subscribeTopic() {
        Messaging.messaging().subscribe(toTopic: WebServices.notificationTopic) { (error) in
            if error != nil {
                print("error for subscribe topic",error?.localizedDescription as Any)
            } else {
                print("Subscribed Topic")
            }
        }
    }
    
    func unSubscribeTopic() {
        Messaging.messaging().unsubscribe(fromTopic: WebServices.notificationTopic) { (error) in
            if error != nil {
                print("error for unSubscribe topic",error?.localizedDescription as Any)
            } else {
                print("UnSubscribed Topic")
            }
        }
    }
}

