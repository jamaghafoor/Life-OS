//
//  FavouriteView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 22/12/23.
//

import SwiftUI

struct FavouriteView: View {
    @EnvironmentObject var vm : SplashScreenViewModel
    @EnvironmentObject var player : PlayerViewModel
    @State var favIds = SessionManager.shared.separateMusicId()
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @AppStorage(SessionKeys.isPro) var isPro = false
    
    //    var index = 0
    var commonSounds: [Sound] {
        vm.allSounds.filter { sound in
            return favIds.contains { soundId in
                soundId == sound.id
            }
        }
    }
    var body: some View {
        if commonSounds.isEmpty {
            VStack(alignment: .center) {
                Spacer()
                Text(String.noFavoirites.localized(language))
                    .poppinsMedium(20)
                    .foregroundColor(.myLightText)
                    .padding(.bottom,60)
                Spacer()
            }
            .hideNavigationbar()
        } else {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(0..<commonSounds.count,id: \.self) { index in
                        let sound = commonSounds[index]
                        HorizontalSoundCard(isFavouriteScreen: true,sound: sound,onDislike: {
                            let isLiked = SessionManager.shared.separateMusicId().contains(where: {$0 == sound.id})
                            if isLiked {
                                player.makeUnfavourite(soundId: sound.id)
                            } else {
                                player.makeFavourite(soundId: sound.id)
                            }
                        })
                        .onTap {
                            player.setSongs(sounds: commonSounds, index: index)
                        }
                    }
                    
                }
                .padding(.bottom,170)
            }
            .addDarkBackGround()
            .hideNavigationbar()
        }
    }
}

#Preview {
    FavouriteView()
}

