//
//  PlayerView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 25/12/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Sliders

struct PlayerView: View {
    @EnvironmentObject var player : PlayerViewModel
    @EnvironmentObject var vm : SplashScreenViewModel
    @AppStorage(SessionKeys.isLogin) var isLogin = 0
    @AppStorage(SessionKeys.isPro) var isPro = false
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                PlayerTopView()
                VStack(alignment: .leading) {
                    Text(player.currentItem?.title ?? "")
                        .poppinsMedium(50)
                        .foregroundColor(.mySecondary)
                        .padding(.top,30)
                    Spacer()
                    ValueSlider(value: $player.percentage) { isEditing in
                        player.pause()
                        player.isEditing = isEditing
                        if !isEditing {
                            player.playSeek()
                        }
                    }
                    .onChange(of: player.percentage ) { newValue in
                        player.sliderScroll()
                    }
                    .valueSliderStyle(
                        HorizontalValueSliderStyle(
                            track: HorizontalTrack(view: Color.mySecondary)
                                .frame(height: 5)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10),
                            thumb: Color.mySecondary
                                .clipShape(.circle),
                            thumbSize: CGSize(width: 12, height: 12),
                            options: .interactiveTrack
                        )
                    )
                    .frame(height: 5)
                    .padding(.bottom,5)
                    HStack {
                        Text(player.currentTime)
                            .foregroundColor(.mySecondary)
                        Spacer()
                        Text(player.duration)
                            .foregroundColor(.mySecondary)
                    }
                    .poppinsMedium(15)
                    .padding(.bottom)
                    HStack() {
                        Spacer()
                        HStack(spacing: 20) {
                            PlayerIconButton(icon: .previousSong, height: 46)
                                .onTap {
                                    player.previous()
                                }
                            PlayerIconButton(icon: player.isPlaying ? .pause : .play, height: 18)
                                .padding(.leading, player.isPlaying ? 0 : 2)
                                .padding(.all,player.isPlaying ? 2 : 0)
                                .padding(20)
                                .background(Blur().opacity(0.8))
                                .clipShape(.circle)
                                .animation(nil)
                                .onTap {
                                    player.playPause()
                                }
                                .frame(width: 55, height: 55)
                                .fixedSize(horizontal: true, vertical: true)
                            PlayerIconButton(icon: .nextSong, height: 46)
                                .onTap {
                                    player.next()
                                }
                        }
                        Spacer()
                    }
                    if player.isTimerOn && player.isShowPlayerTime{
                        HStack(alignment: .center) {
                            Spacer()
                            Text("\(String.musicWillBePause.localized(language)) \(player.stringFromTimeInterval(interval: TimeInterval(player.timerTime),timer: true))")
                                .poppinsMedium(16)
                                .foregroundColor(.myLightText)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                    }
                }
                .padding([.horizontal,.bottom])
                BannerAd()

            }
            .padding(.bottom)
            .padding(.top,5)
            .maxFrame()
            .background(
                ZStack {
                    WebImage(url: player.currentItem?.imageURL)
                        .resizeFillTo(width: Device.width)
                        .animation(.easeIn)
                    Rectangle()
                        .fill(LinearGradient(colors: [.black.opacity(0.2),.black.opacity(0.3),.black.opacity(0.4),.black.opacity(0.6),.black.opacity(0.8),.black], startPoint: .top, endPoint: .bottom))
                        .maxFrame()
                    
                    Image.lines
                        .resizeFitTo()
                        .maxWidth()
                }
                    .ignoresSafeArea()
            )
        }
        .sheet(isPresented: $vm.showLoginSheet) {
            LoginScreen(sheetView: true)
        }
        .onAppear {
            player.percentage = player.playerManager.currentTime / player.playerManager.duration
            player.isPlayerView = true
            if !isPro {
                Interstitial.shared.loadInterstitial()
            }
        }
        .onDisappear {
            player.isPlayerView = false
            if !isPro {
                Interstitial.shared.showInterstitialAds()
            }
        }
        .hideNavigationbar()
    }
}

struct PlayerIconButton: View {
    let icon: Image
    let height: CGFloat
    var body: some View {
        icon
            .resizeFitTo(renderingMode: .template,height: height)
            .foregroundColor(.mySecondary)
    }
}

struct PlayerTopView: View {
    @EnvironmentObject var player : PlayerViewModel
    @EnvironmentObject var vm : SplashScreenViewModel
    @AppStorage(SessionKeys.isLogin) var isLogin = 0
    var body: some View {
        HStack {
            BackButton()
                .frame(width: 26,height: 26)
            Spacer()
            Text(player.currentItem?.category.title ?? "")
                .poppinsMedium(15)
                .foregroundColor(.myPrimary)
                .padding(10)
                .padding(.horizontal,22)
                .background(Color.mySecondary)
                .clipShape(.capsule(style: .continuous))
            
            Spacer()
            
            PlayerIconButton(icon: player.isFav ? .favouriteFill : .favourite, height: 26)
                .onTap {
                    if isLogin == 2 {
                        player.favouriteToggle(soundId: player.currentItem?.id ?? 0)
                    } else {
                        vm.showLoginSheet = true
                    }
                }
        }
        .padding(.horizontal)
    }
}

