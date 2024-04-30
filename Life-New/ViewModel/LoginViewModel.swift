//
//  LoginViewModel.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 20/12/23.
//

import Foundation
import SwiftUI
import Firebase
import AuthenticationServices
import Alamofire
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

class LoginViewModel: ProViewModel {
    
    enum ActiveLoginPage {
        case signInToContinue, SignIn, SignUp, forgetPassword
    }
    
    @Published var activeLoginPage : ActiveLoginPage = .signInToContinue
    @AppStorage(SessionKeys.isLogin) var isLogin = 0
    @Published var email = ""
    @Published var password = ""
    @Published var fullName = ""
    @Published var confirmPassword = ""
    @Published var isLoginComplited: Bool = true
    let model = SplashScreenViewModel.shared

    func signUpWithEmail() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if authResult != nil {
                print("User added")
                self.registerUser(identity: self.email, fullname: self.fullName, login_type: 2)
            } else {
                makeToast(title: "\(error?.localizedDescription ?? .invalidEmailNPass.localized(self.language))")
            }
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                makeToast(title: "\(error?.localizedDescription ?? .invalidEmailNPass.localized(self.language))")
                print(error?.localizedDescription ?? "")
            } else {
                print("success")
                self.registerUser(identity: self.email, fullname: self.fullName, login_type: 2)
            }
        }
    }
    
    func forgotPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                makeToast(title: .passwordResetLinkSent.localized(self.language))
                self.activeLoginPage = .SignIn
            } else {
                makeToast(title: .noAcFoundWithThisEmail.localized(self.language))
            }
        }
    }

    // Sign In With Google
    func signInWithGoogle() {
        // get client id
        self.startLoading()
        guard let clintId = FirebaseApp.app()?.options.clientID else { return }
        //get configuration
        let config = GIDConfiguration(clientID: clintId)
        GIDSignIn.sharedInstance.configuration = config
        //signIn
        GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.shared.windows.first!.rootViewController!) { signResult, error in
            self.stopLoading()
            if let error = error {
                print(error.localizedDescription)
               return
            }
             guard let user = signResult?.user,
                   let _ = user.idToken else { return }
            _ = user.accessToken
            print(user.profile?.name ?? "")
            print(user.profile?.email ?? "")
                self.isLoginComplited = true
            if let user = signResult?.user.profile {
                self.registerUser(identity: user.email, fullname: user.name, login_type: 0)
            }
        }
    }
    
    func registerUser(identity: String, fullname: String, login_type: Int, device_type: Int = 1) {
        self.startLoading()

        NetworkManager.callWebService(url: .registerUser, params: [.identity: identity, .fullname: fullname, .login_type: login_type, .device_type: device_type, .device_token:  WebServices.notificationToken]){(obj: RegisterUserModel) in
            self.stopLoading()
            if let user = obj.data {
                SessionManager.shared.setUser(datum: user)
                self.isLogin = 2
                self.model.showLoginSheet = false
                self.passUserIdToRevenueCat()
            }
        }
    }
}

//MARK: - Signin with Apple

extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let fullName = "\(appleIdCredential.fullName?.givenName ?? "John") \(appleIdCredential.fullName?.familyName ?? "Deo")"
            self.registerUser(identity: appleIdCredential.user, fullname: fullName, login_type: 1)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
    
    public func performAppleSignIn() {
        self.startLoading()
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
        
        self.stopLoading()
    }
}
