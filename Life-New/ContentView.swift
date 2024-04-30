//
//  ContentView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 12/12/23.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @StateObject var player = PlayerViewModel()
    @StateObject var allData = SplashScreenViewModel.shared
    var body: some View {
        NavigationView {
            SplashScreenView()
                .hideNavigationbar()
        }
        .hideNavigationbar()
        .environmentObject(player)
        .environmentObject(allData)
        .environment(\.layoutDirection, language == .Arabic ? .rightToLeft : .leftToRight)
    }
}

#Preview {
    ContentView()
}
