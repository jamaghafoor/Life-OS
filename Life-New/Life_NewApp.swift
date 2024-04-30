//
//  Life_NewApp.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 12/12/23.
//

import SwiftUI
import GoogleMobileAds


@main
struct Life_NewApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
