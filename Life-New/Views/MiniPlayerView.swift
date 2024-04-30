//
//  MiniPlayerView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 22/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct MiniPlayerView: View {
    @EnvironmentObject var player : PlayerViewModel
    @EnvironmentObject var vm : SplashScreenViewModel
    var body: some View {
        let currentCategory = vm.categories.first(where: {$0.id == player.currentItem?.categoryId})
        if player.currentItem != nil {
            VStack {
                HStack(alignment: .center,spacing: 14) {
                    WebImage(url: player.currentItem?.imageURL)
                        .resizeFillTo(width: 55,height: 55,radius: 12)
                    VStack(alignment: .leading) {
                        Text(player.currentItem?.title ?? "")
                            .poppinsSemiBold(16)
                            .lineLimit(1)
                            .foregroundColor(.mySecondary)
                        Text(currentCategory?.title ?? "")
                            .poppinsMedium(12)
                            .foregroundColor(.lessOpSecondary)
                    }
                    Spacer()
                    
                    PlayerIconButton(icon: player.isPlaying ? Image.pause : Image.play, height: 12)
                        .padding()
                        .animation(nil)
                    .onTap {
                        player.playPause()
                    }
                }
                .padding(.vertical,10)
                .padding(.horizontal,10)
                .background(Blur())
                .customCornerRadius(radius: 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20,style: .continuous)
                        .stroke(.bgBorder, lineWidth: 1)
                )
                .padding(15)
            }
            .onTap {
                Navigation.pushToSwiftUiView(PlayerView())
            }
        }
    }
}

#Preview {
    MiniPlayerView()
}
