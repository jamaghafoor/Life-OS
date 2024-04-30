//
//  TabBarView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 22/12/23.
//
import SwiftUI

struct TabBarView: View {
    
    @State private var isMiniplayerShown = true
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @AppStorage(SessionKeys.isLogin) var isLogin = 0
    @State var selectedTab = 0
    @EnvironmentObject var vm : SplashScreenViewModel
    @EnvironmentObject var player: PlayerViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                TopView()
                VStack {
                    switch selectedTab {
                    case 1:
                        CategoriesView(isArticleScreen: true)
                    case 2:
                        CategoriesView()
                    case 3:
                        FavouriteView()
                    case 4:
                        MySpaceView()
                    default:
                        HomeView()
                    }
                }
            }
            .addDarkBackGround()
            .onAppear{
                player.isPlayerView = false
                player.stopTimer()
                if player.isTimerOn && player.isAlreadyStartTimer == false{
                    player.startTimer()
                }
            }
            .sheet(isPresented: $vm.showLoginSheet) {
                LoginScreen(sheetView: true)
            }
            VStack {
                MiniPlayerView()
                HStack(alignment: .center, spacing: 0){
                    TabBarIcon(icon: Image.home, title: .home.localized(language),index: 0,selectedTab: $selectedTab)
                    TabBarIcon(icon: Image.article, title: .article.localized(language),index: 1,selectedTab: $selectedTab)
                    TabBarIcon(icon: Image.category, title: .category.localized(language),index: 2,selectedTab: $selectedTab)
                    TabBarIcon(icon: Image.favourite, title: .favourites.localized(language),index: 3,selectedTab: $selectedTab)
                    TabBarIcon(icon: Image.profile, title: .mySpace.localized(language),index: 4,selectedTab: $selectedTab)
                }
                .padding(.bottom,10)
                .frame(maxWidth: .infinity)
                .background(Blur()
                    .ignoresSafeArea()
                    .frame(height: 80))
            }
        }
        .customAlert(isPresented: $vm.isShowSubscriptionDialog) {
            CommonSubscriptionDialog()
        }
        .showLoader(isLoading: vm.isLoading)
    }
}

struct TabBarIcon: View {
    let icon: Image
    let title: String
    @State var index: Int
    @Binding var selectedTab: Int
    @AppStorage(SessionKeys.isLogin) var isLogin = 0
    @EnvironmentObject var vm : SplashScreenViewModel
 
        var body: some View {
        VStack {
            icon
                .resizeFitTo(renderingMode: .template,height: 22)
               
            Text(title)
                .poppinsMedium(12)
        }
        .foregroundColor(selectedTab == index ? .mySecondary : .mySecondary.opacity(0.5))
        .onTap {
            if index != 3 && index != 4 {
                selectedTab = index
            } else if isLogin == 2{
                selectedTab = index
            } else {
                vm.showLoginSheet = true
            }
        }
        .maxWidth()
    }
}

#Preview {
    TabBarView()
}

struct TopView: View {
    var body: some View {
        HStack {
            Image.logo
                .resizeFitTo(height: 45)
            Text(WebServices.appSlogan)
                .poppinsMedium(16)
                .foregroundColor(.mySecondary)
            Spacer()
            Image.search
                .resizeFitTo(height: 15)
                .foregroundColor(.mySecondary)
                .padding(15)
                .background(Color.bgSecondary)
                .clipShape(.circle)
                .onTap {
                    Navigation.pushToSwiftUiView(SearchView())
                }
        }
        .padding(.horizontal)
    }
}
