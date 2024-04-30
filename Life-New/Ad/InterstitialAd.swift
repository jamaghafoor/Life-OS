//
//  InterstitialAd.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 08/02/24.
//

import Foundation
import SwiftUI
import GoogleMobileAds


class Interstitial: NSObject, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    static var shared: Interstitial = Interstitial()
    
    /// Default initializer of interstitial class
    override init() {
        super.init()
        loadInterstitial()
    }
    
    /// Request AdMob Interstitial ads
    func loadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: SessionManager.shared.getSettingData().intersialIDIos ?? "", request: request, completionHandler: { [self] ad, error in
            if ad != nil { interstitial = ad }
            interstitial?.fullScreenContentDelegate = self
        }
        )
    }
    
    func showInterstitialAds() {
        if interstitial != nil, let root = rootController {
            interstitial?.present(fromRootViewController: root)
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        loadInterstitial()
    }
}

/// Root controller for the app
var rootController: UIViewController? {
    var root = UIApplication.shared.windows.first?.rootViewController
    if let presenter = root?.presentedViewController { root = presenter }
    return root
}
