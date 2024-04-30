//
//  ProViewModel.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 13/01/24.
//

import SwiftUI
import RevenueCat

class ProViewModel: BaseViewModel {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language

    @Published var selectedPackage : Package?
    @Published var allPackages = [Package]()

    func getOffering() {
        Purchases.shared.getOfferings { (offerings, error) in
            if let offering = offerings?.current , error == nil {
                self.allPackages = offering.availablePackages
                self.selectedPackage = self.allPackages.first
            }
        }
    }
    
    func makePurchases() {
        startLoading()
        if let package = selectedPackage {
            Purchases.shared.purchase(package: package) { (transaction, customerInfo, error, userCancelled) in
                self.stopLoading()
                self.checkUserIsPro(customerInfo: customerInfo)
                if self.isPro {
                    Navigation.popToRootView()
                    makeToast(title: .youHaveSuccessfullyBecomePro.localized(self.language))
                }
            }
        }
    }
    
    func restorePurchases() {
        Purchases.shared.restorePurchases { customerInfo, error in
            self.checkUserIsPro(customerInfo: customerInfo)
            if self.isPro {
                Navigation.popToRootView()
                makeToast(title: .youHaveSuccessfullyBecomePro.localized(self.language))
            }
        }
    }
    
    func passUserIdToRevenueCat() {
        startLoading()
        Purchases.shared.logIn("\(SessionManager.shared.getUser().id ?? 0)") { (customerInfo, created, error) in
            self.stopLoading()
            self.checkUserIsPro(customerInfo: customerInfo)
        }
    }
}
