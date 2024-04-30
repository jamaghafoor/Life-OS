//
//  SearchView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 22/12/23.
//

import SwiftUI
import SDWebImageSwiftUI
import WaterfallGrid

struct SearchView: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @EnvironmentObject var vm : SplashScreenViewModel
    @EnvironmentObject var player : PlayerViewModel
    @AppStorage(SessionKeys.isPro) var isPro = false
    
    //    var sound : Sound
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                VStack {
                    SearchTopView()
                    if vm.filterdSounds.isNotEmpty {
                        ScrollView(showsIndicators: false) {
                            WaterfallGrid(0..<vm.filterdSounds.count,id: \.self) { index in
                                SoundCard(sound: vm.filterdSounds[index])
                                    .addBgWithBorder()
                                    .onTap {
                                        player.setSongs(sounds: vm.filterdSounds, index: index)
                                    }
                            }
                            .padding(.bottom,110)
                            .gridStyle(
                                columnsInPortrait: 2,
                                spacing: 15,
                                animation: .easeInOut(duration: 0.5)
                            )
                            .padding()
                            
                        }
                    } else {
                        VStack(alignment: .center) {
                            Text(String.noDataFound.localized(language))
                                .poppinsMedium(20)
                                .foregroundColor(.myLightText)
                        }
                        .maxFrame()
                        .hideNavigationbar()
                    }
                }
                MiniPlayerView()
                
            }
            BannerAd()
        }
        .onAppear{
            vm.changOfQuery(word: vm.searchQuery)
        }
        .addDarkBackGround()
        .hideNavigationbar()
    }
}

struct SearchTopView : View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @EnvironmentObject var vm : SplashScreenViewModel
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack {
                BackButton()
            }
            HStack{
                CustomTextField(
                    placeholder:
                        Text(String.searchHear.localized(language))
                        .foregroundColor(.mySecondary.opacity(0.4))
                        .poppinsRegular(15) as! Text
                    , text: $vm.searchQuery)
                .onChange(of: vm.searchQuery){ newValue in
                    vm.changOfQuery(word: newValue )
                }
                Spacer()
                Image.search
                    .resizeFitTo(renderingMode: .template,height: 15)
                    .foregroundColor(.mySecondary)
            }
            .padding(10)
            .padding(.horizontal,10)
            .background(Color.bgSecondary)
            .clipShape(.capsule(style: .continuous))
        }
        .padding(.horizontal)
    }
}
