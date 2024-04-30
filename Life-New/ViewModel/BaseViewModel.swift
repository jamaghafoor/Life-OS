//
//  BaseViewModel.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 20/12/23.
//

import SwiftUI
import RevenueCat

class BaseViewModel : NSObject, ObservableObject {
    @AppStorage(SessionKeys.isPro) var isPro = false
    @Published var isLoading = false
    @Published var dummy = false
    
    func startLoading(){
        isLoading = true
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    func reset() {
        self.dummy.toggle()
    }
    
    func checkUserIsPro(customerInfo: CustomerInfo?) {
        //        self.isPro = customerInfo?.entitlements.all["Pro"]?.isActive == true
        if let date = customerInfo?.latestExpirationDate, date >= Date() {
            isPro = true
        } else {
            isPro =  false
        }
    }
}
