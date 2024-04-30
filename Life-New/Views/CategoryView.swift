//
//  CategoryItemView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 22/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryView: View {
    var cat : Category
    @EnvironmentObject var vm : SplashScreenViewModel
    @EnvironmentObject var player : PlayerViewModel
    @State var isArticleView : Bool = false
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    CommonTopView(title: cat.title ?? "")
                        .padding(.horizontal)
                    VStack(spacing: 15) {
                        if isArticleView {
                            if cat.articles.isNotEmpty {
                                ScrollView(showsIndicators: false) {
                                    ForEach(cat.articles,id: \.id) { article in
                                        HorizontalArticleCard(article: article)
                                            .onTap {
                                                Navigation.pushToSwiftUiView(ArticleDetailView(cat: cat, article: article))
                                            }
                                    }
                                    .padding(.top,20)
                                    .padding(.bottom,110)
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
                        } else {
                            if cat.sounds.isNotEmpty {
                                ScrollView(showsIndicators: false) {
                                    ForEach(0..<cat.sounds.count,id: \.self) { index in
                                        let sound = cat.sounds[index]
                                        HorizontalSoundCard(sound: sound)
                                            .onTap {
                                                player.setSongs(sounds: cat.sounds, index: index)
                                            }
                                    }
                                    .padding(.top,20)
                                    .padding(.bottom,110)
                                }
                            }
                            else {
                                VStack(alignment: .center) {
                                    Text(String.noDataFound.localized(language))
                                        .poppinsMedium(20)
                                        .foregroundColor(.myLightText)
                                }
                                .maxFrame()
                                .hideNavigationbar()
                            }
                        }
                    }
                   
                }
                MiniPlayerView()
            }
            BannerAd()
        }
        .addDarkBackGround()
        .hideNavigationbar()
    }
}

struct HorizontalSoundCard: View {
    var isFavouriteScreen: Bool = false
    @EnvironmentObject var player : PlayerViewModel
    @AppStorage(SessionKeys.isPro) var isPro = false
    var sound : Sound?
    var onDislike : ()->() = {}
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    var body: some View {
        HStack(alignment:isFavouriteScreen ? .center : .top) {
            ZStack {
                WebImage(url: sound?.image?.addBaseURL())
                    .resizeFillTo(width: 70,height: 70,radius: 15)
                PlayButton(playSize: 8,bgSize: 10)
            }
            .padding(.trailing,4)
            VStack(alignment: .leading) {
                Text(sound?.category?.title ?? "")
                    .poppinsMedium(12)
                    .foregroundColor(.lessOpSecondary)
                Text(sound?.title ?? "")
                    .poppinsMedium(14)
                    .foregroundColor(.mySecondary)
                    .padding(.bottom,5)
                    .lineLimit(1)
                Text("\(sound?.plays?.roundedWithAbbreviations ?? "") \(.plays.localized(language))")
                    .poppinsMedium(12)
                    .foregroundColor(.lessOpSecondary)
            }
            Spacer()
            if !isFavouriteScreen {
                if sound?.type == 1 && !isPro {
                    PremiumButton(iconSize: 15,bgSize: 6,bgColor: Color.bgSecondary.opacity(0.5))
                        .overlay(
                            Circle()
                                .stroke(.lightBorder, lineWidth: 1)
                        )
                }
            } else {
                let isLiked = SessionManager.shared.separateMusicId().contains(where: {$0 == sound?.id})
                PlayerIconButton(icon: isLiked ? Image.favouriteFill : Image.favourite , height: 22)
                    .onTap(completion: onDislike)
                    .padding(.trailing,10)
            }
        }
        .padding(8)
        .addBgWithBoderOnHzCard()
    }
}

struct HorizontalArticleCard: View {
    var article: Article
    var body: some View {
        HStack(alignment: .center,spacing: 12) {
            WebImage(url: article.image?.addBaseURL())
                .resizeFillTo(width: 70,height: 70,radius: 15)
            
            VStack(alignment: .leading,spacing: 4) {
                Text(article.title ?? "")
                    .poppinsMedium(16)
                    .foregroundColor(.mySecondary)
                    .lineLimit(1)
                    .padding(.bottom,6)
                Text(article.createdAt?.databaseDateToDate ?? "")
                    .poppinsMedium(14)
                    .foregroundColor(.lessOpSecondary)
            }
            Spacer()
            
        }
        .padding(7)
        .addBgWithBoderOnHzCard()
        
    }
}


