//
 //  SplashScreenView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 20/12/23.
//

import SwiftUI

struct SplashScreenView: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @EnvironmentObject var vm : SplashScreenViewModel
    @EnvironmentObject var player : PlayerViewModel
    @AppStorage(SessionKeys.isLogin) var isLogin = 0
    @State var isGoAhead = false
    var body: some View {
        if isGoAhead {
            if isLogin != 0 {
                TabBarView()
            } else {
                LoginScreen()
            }
        } else {
            VStack {
                Spacer()
                LogoAndSloganCard()
                Spacer()
                Spacer()
                Text(String.introDes.localized(language))
                    .poppinsMedium(16)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.mySecondary)
                    .padding(.bottom,20)
                HStack {
                    if vm.isDataLoaded {
                        Text(String.getStarted.localized(language))
                            .poppinsMedium(18)
                            .foregroundColor(.myPrimary)
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .myPrimary))
                            .scaleEffect(1.5)
                            .padding(.vertical,2.5)
                    }
                }
                .padding(18)
                .frame(maxWidth: .infinity)
                .background(Color.mySecondary)
                .clipShape(.capsule(style: .continuous))
                .padding(.bottom,10)
                .padding(.horizontal,45)
                .onTap {
                    if vm.isDataLoaded {
                        isGoAhead = true
                    }
                }
            }
            .padding()
            .padding(.bottom,40)
            .addDarkBackGround()
            .hideNavigationbar()
            .onAppear{
                vm.fetchAllData()
                vm.getProfile()
                if player.isTimerOn == true {
                    player.timerTime = player.selectedTime

                }
            }
        }
    }
}

struct LogoAndSloganCard: View {
    var body: some View {
        VStack {
            Image.logo
                .resizeFitTo(width: 115, height: 100)
                .padding(.bottom,5)
            Text(WebServices.appSlogan)
                .poppinsMedium(20)
                .foregroundColor(.mySecondary)
        }
    }
}
