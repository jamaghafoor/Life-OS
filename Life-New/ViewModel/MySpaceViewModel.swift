//
//  MySpaceViewModel.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 07/02/24.
//

import SwiftUI

class MySpaceViewModel : BaseViewModel {
    @Published var isNotificationOn: Bool = true
    @Published var isLogOutDialogShow: Bool = false
    @Published var isDeleteDialogShow: Bool = false
    @Published var isPrivacyURLSheet = false
    @Published var isTermsURLSheet = false
    @Published var isRatingAppSheet = false
    
    func deleteMyAc() {
        startLoading()
        NetworkManager.callWebService(url: .deleteMyAc,params: [.user_id: SessionManager.shared.getUser().id ?? 0]) {(obj: DeleteAccountModel) in
            self.stopLoading()
            if obj.status == true {
                self.isDeleteDialogShow = false
                SessionManager.shared.clear()
            }
        }
    }
    
    func logOutMyAc() {
        startLoading()
        NetworkManager.callWebService(url: .logOut,params: [.user_id: SessionManager.shared.getUser().id ?? 0]) {(obj: DeleteAccountModel) in
            self.stopLoading()
            if obj.status == true {
                self.isLogOutDialogShow = false
                SessionManager.shared.clear()
            }
        }
    }
}
