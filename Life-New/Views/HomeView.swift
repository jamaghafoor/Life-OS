//
//  HomeView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 21/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @EnvironmentObject var vm :  SplashScreenViewModel
    @EnvironmentObject var player :  PlayerViewModel
//    @AppStorage(SessionKeys.timerTime) var timerTime = 0.0

    var filterBannerSounds: [Sound] {
        return vm.allSounds.filter { sound in
            sound.isFeatured == 1
        }
    }
    
    @State var quote : Quote?
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading,spacing: 0) {
                if vm.allSounds.contains(where: {$0.isFeatured == 1}) {
                    BannerSliderView(sounds: filterBannerSounds)
                }
                QuoteCard(quote: quote)
//                BannerAd()
                ForEach(vm.categories, id: \.id) { cat in
                    HomeCategoryView(cat: cat)
                }
            }
            .padding(.bottom,170)
            .hideNavigationbar()
        }
        .onAppear {
            if quote == nil {
                quote = vm.quotes.randomElement()
            }
        }
    }
}

struct HomeCategoryView: View {
    @EnvironmentObject var player : PlayerViewModel
    @EnvironmentObject var vm : SplashScreenViewModel
    @AppStorage(SessionKeys.isPro) var isPro = false
    var cat : Category
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(cat.title ?? "")
                        .poppinsMedium(24)
                        .foregroundColor(.mySecondary)
                    Spacer()
                    Image.nextArrow
                        .resizeFitTo(height: 24)
                        .foregroundColor(.mySecondary)
                        .padding(.horizontal,10)
                        .onTap {
                            Navigation.pushToSwiftUiView(CategoryView(cat: cat))
                        }
                }
            }
            .padding(.top,12)
            .padding(.bottom,5)
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top,spacing: 10){
                    ForEach(0..<(cat.sounds.count),id: \.self) { index in
                        let sound = cat.sounds[index]
                        SoundCard(isHomeMusicCard: true, sound: sound)
                            .onTap{
                                    player.setSongs(sounds: cat.sounds, index: index)
                            }
                    }
                }
                .padding(.horizontal)
            }
            Rectangle()
                .fill(.mySecondary.opacity(0.1))
                .frame(height: 1)
                .padding(.horizontal)
                .padding(.top,10)
        }
    }
}

struct SoundCard: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    var isHomeMusicCard: Bool = false
    @AppStorage(SessionKeys.isPro) var isPro = false
    var sound: Sound
    var size = Device.width / 2 - 50
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .top) {
                WebImage(url: sound.image?.addBaseURL())
                    .resizeFillTo(width: size,height: size,radius: 25)
                VStack(alignment: .leading) {
                    HStack() {
                        Spacer()
                        PlayButton(playSize: 10,bgSize: 14)
                    }
                    Spacer()
                    if sound.type == 1 && !isPro {
                        PremiumButton(iconSize: 24,bgSize: 8)
                    }
                }
                .padding(7)
            }
            .frame(width: size, height: size)
            if isHomeMusicCard {
                Text("\(sound.plays?.roundedWithAbbreviations ?? "") \(String.plays.localized(language))")
                    .foregroundColor(.mySecondary.opacity(0.6))
                    .poppinsMedium(13)
                Text(sound.title ?? "")
                    .poppinsMedium(15)
                    .foregroundColor(.mySecondary)
                    .frame(width: size - 5,alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                VStack(alignment: .leading,spacing: 5) {
                    Text(sound.category?.title ?? "")
                        .foregroundColor(.mySecondary.opacity(0.6))
                        .poppinsMedium(14)
                    Text(sound.title ?? "")
                        .poppinsMedium(14)
                        .foregroundColor(.mySecondary)
                        .frame(width: size - 10,alignment: .leading)
                        .multilineTextAlignment(.leading)
                    
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.leading,10)
            }
        }
    }
}


struct QuoteCard: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    
    var quote : Quote?
    
    var body: some View {
        if let quotes = quote?.quotes {
            VStack(alignment: .leading,spacing: 5) {
                Text(String.inspirationForYou.localized(language))
                    .poppinsMedium(15)
                    .foregroundColor(.mySecondary.opacity(0.5))
                Text(quotes)
                    .poppinsMedium(19)
                    .foregroundColor(.mySecondary)
            }
            .maxWidth(alignment: .leading)
            .padding(.vertical,15)
            .padding(.horizontal)
            .background(Color.bgFrame)
            .padding(.bottom,10)
        }
    }
}

struct BannerSliderView: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    var sounds : [Sound]
    @EnvironmentObject var vm: SplashScreenViewModel
    @EnvironmentObject var player: PlayerViewModel
    @State private var currentIndex : Int = 0
    @AppStorage(SessionKeys.isPro) var isPro = false
        @GestureState private var dragOffset: CGFloat = 0
    @State var timer : Timer?
    
    var body: some View {
        VStack(alignment: .leading) {
            PagingView(config: .init(margin: 146,constrainedDeceleration: false), page: $currentIndex, {
                ForEach(0..<sounds.count, id: \.self){ index in
                    let sound = sounds[index]
                    BannerCard(sound: sound)
                        .frame(width: 210,height: 310,alignment: .leading)
                        .onTap {
                            player.setSongs(sounds: sounds, index: index)
                        }
                }
            })
            .padding(.leading, -130)
            .frame(height: 310)

                
            HStack(spacing: 4) {
                ForEach(0..<sounds.count, id: \.self){ index in
                    RoundedRectangle(cornerRadius: 25,style: .continuous)
                        .fill(currentIndex == index ? .mySecondary : .bgFrame)
                        .frame(width: currentIndex == index ? 16 : 7,height: 7)
                }
            }
            .padding([.horizontal,.bottom])
        }
        .onAppear {
            nextPage()
        }
        .onChange(of: currentIndex, perform: { newValue in
            nextPage()
        })
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func nextPage(){
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { timer in
            withAnimation {
                if currentIndex < sounds.count - 1 {
                    currentIndex += 1
                } else {
                    currentIndex = 0
                }
            }
        })
    }
}

struct BannerCard: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @AppStorage(SessionKeys.isPro) var isPro = false
    var sound : Sound
    
    var body: some View {
        ZStack(alignment:.leading) {
            WebImage(url: sound.image?.addBaseURL())
                .resizeFillTo(radius: 40)
                .frame(width: 210,height: 280)
            VStack {
                HStack {
                    Spacer()
                    if !isPro && sound.type == 1 {
                        PremiumButton(iconSize: 26,bgSize: 16)
                            .padding(.vertical,10)
                            .padding(.horizontal,10)
                        
                    } else {
                        PlayButton(playSize: 18, bgSize: 20)
                            .padding(.vertical,10)
                            .padding(.horizontal,10)
                    }
                }
                Spacer()
                VStack(alignment: .leading,spacing: 0) {
                    Text(sound.category?.title ?? "")
                        .poppinsSemiBold(11)
                        .foregroundColor(.mySecondary)
                        .padding(.horizontal,16)
                        .padding(.vertical,5)
                        .background(Color.myPrimary)
                        .clipShape(.capsule(style: .continuous))
                        .padding(.leading,20)
                        .offset(y: 13)
                        .zIndex(1)
                    VStack(alignment: .leading) {
                        Text(sound.title ?? "")
                            .poppinsMedium(20)
                            .foregroundColor(.myWhite)
                            .lineLimit(1)
                        Text("\(sound.plays?.roundedWithAbbreviations ?? "") \(String.plays.localized(language))")
                            .poppinsMedium(14)
                            .foregroundColor(.myWhite.opacity(0.7))
                    }
                    .padding(.leading,26)
                    .frame(width: 210,alignment: .leading)
                    .padding(.vertical)
                    .background(Blur(style: .systemUltraThinMaterialDark)
                        .frame(maxWidth: .infinity))
                }
            }
            
        }
        .frame(width: 210,height: 280)
        .customCornerRadius(radius: 40)
        
    }
}
