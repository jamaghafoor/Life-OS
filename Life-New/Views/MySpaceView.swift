//
//  MySpaceView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 22/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct MySpaceView: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @AppStorage(SessionKeys.isPro) var isPro = false
    @StateObject var vm = MySpaceViewModel()
    @StateObject var editProfileVm = EditProfileViewModel()
    @EnvironmentObject var player : PlayerViewModel
    @State var user = SessionManager.shared.getUser()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                VStack(spacing: 12) {
                    HStack(alignment: .top,spacing: 20) {
                        if let image = editProfileVm.image {
                            Image(uiImage: image)
                                .resizeFillTo(width: 80,height: 80,radius: 20)
                        } else if user.image != nil {
                            WebImage(url: user.image?.addBaseURL())
                                .resizeFillTo(width: 80,height: 80,radius: 20)
                        } else {
                            Image.person
                                .resizeFitTo(width: 80,height: 80)
                                .padding(5)
                                .background(Color.mySecondary)
                                .customCornerRadius(radius: 20)
                        }
                        VStack {
                            Spacer()
                            Text(SessionManager.shared.getUser().fullname ?? String.yourName.localized(language))
                                .poppinsMedium(20)
                                .foregroundColor(.mySecondary)
                            Spacer()
                        }
                        Spacer()
                        Image.edit
                            .resizeFitTo(height: 20)
                            .onTap {
                                Navigation.pushToSwiftUiView(EditProfileView())
                            }
                    }
                    .frame(height: 70)
                    .padding()
                    Rectangle()
                        .fill(.bgFrame)
                        .frame(height: 1)
                        .padding(.bottom,15)
                    ProfileProCard()
                        .onTap {
                            if !isPro {
                                Navigation.pushToSwiftUiView(ProView())
                            }
                        }
                    MySpaceFieldCardWithSwitch(icon: Image.notification, title: .notifications.localized(language),isNotificationCard: true)
                    MySpaceFieldCardWithSwitch(icon: Image.timer, title: .timer.localized(language),isTimerCard: true,onTap: {
                        Navigation.pushToSwiftUiView(TimerView())
                    })
                    MySpaceFieldCard(icon: Image.language, title: .language){
                        Navigation.pushToSwiftUiView(LanguageView())
                    }
                    MySpaceFieldCard(icon: Image.privacyPolicy, title: .privacyPolicy){
                        vm.isPrivacyURLSheet = true
                    }
                    .sheet(isPresented: $vm.isPrivacyURLSheet) {
                        WebUrl(url: privacyPolicyURL, title: .privacyPolicy.localized(language)){
                            vm.isPrivacyURLSheet = false
                        }
                        .ignoresSafeArea()
                    }
                    
                    MySpaceFieldCard(icon: Image.terms, title: .termsOfUse){
                        vm.isTermsURLSheet = true
                    }
                    .sheet(isPresented: $vm.isTermsURLSheet) {
                        WebUrl(url: termsOfUseURL, title: .termsOfUse.localized(language)){
                            vm.isTermsURLSheet = false
                        }
                        .ignoresSafeArea()
                    }
                    
                    MySpaceFieldCard(icon: Image.rate, title: .rateThisApp) {
                        if let url = URL(string: rateThisAppURL) {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    MySpaceFieldCard(icon: Image.logOut, title: .logOut){
                        vm.isLogOutDialogShow = true
                    }
                    MySpaceFieldCard(icon: Image.delete, title: .deleteMyAccount){
                        vm.isDeleteDialogShow = true
                    }
                }
            }
            .padding(.bottom,170)
            .padding(.top,10)
        }
        .onAppear(perform: {
            user = SessionManager.shared.getUser()
        })
        .hideNavigationbar()
        .customAlert(isPresented: $vm.isLogOutDialogShow){
            DialogCard(icon: Image.logOutTwo, title: .areYouSure.localized(language), subTitle: .logOutDes.localized(language), buttonTitle: .logOut.localized(language), onClose: {
                withAnimation {
                    vm.isLogOutDialogShow = false
                }
            },onButtonTap: {
                player.pause()
                player.currentItem = nil
                vm.logOutMyAc()
            }
            )
        }
        .customAlert(isPresented: $vm.isDeleteDialogShow){
            DialogCard(icon: Image.darkBlueDelete, title: .areYouSure.localized(language), subTitle: .deleteDes.localized(language), buttonTitle: .deleteMyAccount.localized(language),onClose: {
                withAnimation {
                    vm.isDeleteDialogShow = false
                }
            },onButtonTap: {
                player.pause()
                player.currentItem = nil
                vm.deleteMyAc()
            }
            )
        }
        .showLoader(isLoading: vm.isLoading)
    }
}

struct ProfileProCard: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @AppStorage(SessionKeys.isPro) var isPro = false
    var body: some View {
        HStack {
            Image.bluePremium
                .resizeFitTo(height: 26)
            HStack(spacing: 5) {
                Text(isPro ? String.youAre.localized(language) : String.becomeA.localized(language))
                    .foregroundColor(.mySecondary)
                Text(String.pro.localized(language))
                    .poppinsSemiBold(13)
                    .foregroundColor(.customBlue)
            }
            .poppinsMedium(13)
            Spacer()
        }
        .padding(17)
        .background(
            Image.bgPremium
                .resizable()
                .scaledToFill()
        )
        .clipped()
        .contentShape(Rectangle())
        .background(Color.bgFrame)
        .customCornerRadius(radius: 15)
        .padding(0.8)
        .background(Color.customBlue)
        .customCornerRadius(radius: 15.5)
        .padding(.horizontal)
    }
}

struct MySpaceFieldCard: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    let icon: Image
    let title: String
    var onTap: ()->() = {}
    
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                icon
                    .resizeFitTo(renderingMode: .template, width: 25, height: 25)
                    .foregroundColor(.mySecondary)
                    .frame(width: 25)
                Text(title.localized(language))
                    .foregroundColor(.mySecondary)
                    .poppinsMedium(13)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .onTap(completion: onTap)
        }
        .padding(17)
        .addbgToProfileCard()
    }
}

struct MySpaceFieldCardWithSwitch: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @AppStorage(SessionKeys.isNotificationOn) var isNotificationOn = true
    @EnvironmentObject var player : PlayerViewModel
    @AppStorage(SessionKeys.selectedTime) var selectedTime = 0.0
    @StateObject var vm = MySpaceViewModel()
    let icon: Image
    let title: String
    var isNotificationCard: Bool = false
    var isTimerCard : Bool = false
    var appDelegateModel = AppDelegate.shared
    var onTap: ()->() = {}
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                HStack(spacing: 12) {
                    icon
                        .resizeFitTo(renderingMode: .template, width: 20, height: 20)
                        .foregroundColor(.mySecondary)
                        .frame(width: 20)
                    VStack(alignment: .leading) {
                        Text(title)
                            .foregroundColor(.mySecondary)
                            .poppinsMedium(13)
                            .fixedSize(horizontal: true, vertical: false)
                        if isTimerCard && player.isTimerOn && player.timerTime != 0.0 {
                            Text("\(player.stringFromTimeInterval(interval: TimeInterval(player.selectedTime),timer: true))")
                                .poppinsRegular(10)
                                .foregroundColor(.lessOpSecondary)
                        }
                    }
                    .frame(maxHeight: 30)
                    Spacer()
                }
            }
            .onTap(completion: onTap)
            if isNotificationCard {
                Toggle("", isOn: $isNotificationOn)
                    .toggleStyle(SwitchToggleStyle(tint: .myPrimary))
                    .onChange(of: isNotificationOn) { _ in
                        if isNotificationOn {
                            appDelegateModel.subscribeTopic()
                        } else {
                            appDelegateModel.unSubscribeTopic()
                        }
                    }
            } else if isTimerCard {
                Toggle("", isOn: $player.isTimerOn)
                    .toggleStyle(SwitchToggleStyle(tint: .myPrimary))
                    .onChange(of: player.isTimerOn) { _ in
                         timerSwitchChange()
                    }
            }
        }
        .padding(.vertical,15)
        .padding(.horizontal,20)
        .addbgToProfileCard()
    }
    func timerSwitchChange() {
        player.timerTime = selectedTime
        if player.timerTime == 0.0 && player.isTimerOn{
            Navigation.pushToSwiftUiView(TimerView())
            player.isTimerOn = false
        } else if player.isTimerOn {
            player.timerTime = selectedTime
            if !player.isAlreadyStartTimer {
                player.startTimer()
            }
        } else if !player.isTimerOn {
            player.stopTimer()
        }
    }
}

#Preview {
    MySpaceView()
}
