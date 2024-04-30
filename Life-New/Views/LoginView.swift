//
//  LoginScreen.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 20/12/23.
//

import SwiftUI

struct LoginScreen: View, KeyboardReadable {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @StateObject var vm = LoginViewModel()
    @EnvironmentObject var tabBarModel : SplashScreenViewModel
    @State var shouldShowLogo = true
    @State var sheetView: Bool = false
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                if sheetView == true {
                 if shouldShowLogo {
                        HStack {
                            Spacer()
                            CloseButton() {
                                tabBarModel.showLoginSheet = false
                            }
                            .padding(.top)
                        }
                    }
                }
                if vm.activeLoginPage != .signInToContinue {
                    if shouldShowLogo {
                        HStack {
                            BackButton(){
                                vm.activeLoginPage = .signInToContinue
                            }
                            Spacer()
                        }
                    }
                }
                if shouldShowLogo {
                    LogoAndSloganCard()
                        .padding(.top, Device.height / 13)
                        .padding(.bottom,10)
                }
                Spacer()
                Spacer()
                Spacer()
                
                loginPage()
            }
            .padding(.horizontal)
            .addDarkBackGround()
            .hideNavigationbar()
            .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                withAnimation {
                    shouldShowLogo = !newIsKeyboardVisible
                }
            }
        }
        .hideNavigationbar()
        .showLoader(isLoading: vm.isLoading)
        
    }
    
    @ViewBuilder func loginPage() -> some View {
        switch vm.activeLoginPage {
        case .signInToContinue:
            SignInToContinue(vm: vm,sheetView: $sheetView)
        case .SignIn:
            SignInPage(vm: vm)
        case .SignUp:
            SignUpPage(vm: vm)
        case .forgetPassword:
            ForgetPassword(vm: vm)
        }
    }
}

struct ForgetPassword: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @StateObject var vm: LoginViewModel
    var body: some View {
        VStack {
            Text(String.forgetPasswordDes.localized(language))
                .multilineTextAlignment(.center)
                .poppinsMedium(16)
                .foregroundColor(.mySecondary)
                .padding()
            
            Text("\(String.forgetPassword.localized(language))?")
                .poppinsMedium(24)
                .foregroundColor(.mySecondary)
                .padding(.bottom,20)
            
            CommonTextField(placeHolder: .email.localized(language), textBinding: $vm.email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .textCase(.lowercase)
            
            SimpleNavigationButton(title: String.reset.localized(language)){
                vm.forgotPassword()
            }
            HStack {
                Spacer()
                Text("\(String.signIn.localized(language))?")
                    .poppinsMedium(15)
                    .foregroundColor(.mySecondary)
                    .onTap {
                        vm.activeLoginPage = .SignIn
                    }
            }
        }
        .padding(.horizontal)
        .padding(.bottom,30)
    }
}

struct SignInToContinue: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @StateObject var vm: LoginViewModel
    @Binding var sheetView: Bool
    var body: some View {
        VStack {
            
            Text(String.loginDes.localized(language))
                .poppinsMedium(16)
                .multilineTextAlignment(.center)
                .foregroundColor(.mySecondary)
                .padding(.bottom,10)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal,-10)
            Text(String.signInToContinue.localized(language))
                .poppinsMedium(25)
                .foregroundColor(.mySecondary)
                .padding(.bottom)
            
            SimpleNavigationButton(title: .signInWithApple.localized(language), image: .apple) {
                vm.performAppleSignIn()
            }
            SimpleNavigationButton(title: .signInWithGoogle.localized(language), image: .google){
                vm.signInWithGoogle()
            }
            SimpleNavigationButton(title: .signInWithEmail.localized(language), image: .email) {
                vm.activeLoginPage = .SignIn
            }
            if sheetView == false {
                Text(String.skip.localized(language))
                    .poppinsMedium(16)
                    .foregroundColor(.mySecondary)
                    .onTap {
                        vm.isLogin = 1
                    }
            }
        }
        .padding(.vertical)
        .padding()
        .padding(.bottom,20)
    }
    
}

struct SignInPage: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @StateObject var vm: LoginViewModel
    
    var body: some View {
        VStack {
            Text(String.signIn.localized(language))
                .poppinsMedium(30)
                .foregroundColor(.mySecondary)
                .padding(.bottom,30)
            CommonTextField(placeHolder: .email.localized(language), textBinding: $vm.email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
            
            CommonTextField(placeHolder: .password.localized(language), textBinding: $vm.password,showHideUnhideBtn: true)
            HStack {
                Spacer()
                Text("\(String.forgetPassword.localized(language))")
                    .poppinsMedium(16)
                    .foregroundColor(.mySecondary)
                    .onTap {
                        vm.activeLoginPage = .forgetPassword
                    }
            }
            SimpleNavigationButton(title: String.signIn.localized(language)) {
                vm.signIn()
            }
            Text("\(String.signUp.localized(language))?")
                .poppinsMedium(18)
                .foregroundColor(.mySecondary)
                .onTap {
                    vm.activeLoginPage = .SignUp
                }
        }
        .padding(.bottom,30)
    }
}

struct SignUpPage: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @StateObject var vm: LoginViewModel
    
    var body: some View {
        
            VStack {
                Text(String.signUp.localized(language))
                    .poppinsMedium(30)
                    .foregroundColor(.mySecondary)
                    .padding(.bottom,30)
                ScrollView(showsIndicators: false) {
                    VStack {
                        CommonTextField(placeHolder: .email.localized(language), textBinding: $vm.email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                        
                        CommonTextField(placeHolder: .fullName.localized(language), textBinding: $vm.fullName)
                            .keyboardType(.namePhonePad)
                        CommonTextField(placeHolder: .password.localized(language), textBinding: $vm.password,showHideUnhideBtn: true)
                        CommonTextField(placeHolder: .confirmPassword.localized(language), textBinding: $vm.confirmPassword,showHideUnhideBtn: true)
                        SimpleNavigationButton(title: String.signUp.localized(language)){
                            if vm.password == vm.confirmPassword {
                                vm.signUpWithEmail()
                            } else {
                                makeToast(title: .passNotMatch.localized(language))
                            }
                        }
                        Text("\(String.signIn.localized(language))?")
                            .poppinsMedium(18)
                            .foregroundColor(.mySecondary)
                            .onTap {
                                vm.activeLoginPage = .SignIn
                            }
                            .padding(.bottom,30)
                    }
            }
        }
    }
}

struct CommonTextField : View {
    var placeHolder: String
    @Binding var textBinding: String
    var showHideUnhideBtn: Bool = false
    
    var body: some View {
        CustomTextField(placeholder: Text(placeHolder).foregroundColor(.mySecondary.opacity(0.8)), text: $textBinding,showHideUnHideButton: showHideUnhideBtn)
            .poppinsMedium()
            .foregroundColor(.myWhite)
            .padding(.horizontal,8)
            .padding(18)
            .background(Color.myWhite.opacity(0.08))
            .clipShape(.capsule(style: .continuous))
            .padding(.bottom,8)
    }
}

struct SimpleNavigationButton: View {
    var title: String
    var image: Image?
    var textColor: Color = .myPrimary
    var backgroundColor: Color = Color.mySecondary
    var onTap: ()->() = {}
    
    var body: some View {
        HStack(spacing: 15) {
            image?
                .resizeFitTo(height: 25)
            Text(title)
                .poppinsMedium(18)
                .foregroundColor(textColor)
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .clipShape(.capsule(style: .continuous))
        .padding(.bottom,10)
        .onTap(completion: onTap)
    }
}

#Preview {
    LoginScreen()
}
