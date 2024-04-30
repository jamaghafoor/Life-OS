//
//  CategoryView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 22/12/23.
//

import SwiftUI
import SDWebImageSwiftUI
import WaterfallGrid

struct CategoriesView: View {
    var isArticleScreen: Bool = false
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @EnvironmentObject var vm : SplashScreenViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .bottom) {
                VStack {
                    ScrollView(showsIndicators: false) {
                        WaterfallGrid(vm.categories,id: \.id) { index in
                                CategoryCard(category: index, isArticleScreen: isArticleScreen)
                            }
                        .gridStyle(
                            columnsInPortrait: 2,
                            spacing: 20,
                            animation: .none
                        )
                        .padding(.horizontal)
                    }
                }
            }
            .hideNavigationbar()
            .padding(.bottom,170)
        }
    }
}

#Preview {
    CategoriesView()
}

struct CategoryCard: View {
    var category: Category
    var isArticleScreen: Bool
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    var size = Device.width / 2 - 50

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .top) {
                WebImage(url: category.image?.addBaseURL())
                    .resizeFillTo(width: size, height: size, radius: 25)
            }
            .frame(width: size, height: size,alignment: .leading)
            VStack(alignment: .leading, spacing: 5) {
                Text(category.title ?? "")
                    .foregroundColor(.mySecondary.opacity(0.6))
                    .poppinsMedium(14)
                Text(isArticleScreen 
                     ? "\(category.articles.count) \(String.articles.localized(language))"
                     : "\(category.sounds.count) \(String.tracks.localized(language))")
                    .poppinsMedium(18)
                    .foregroundColor(.mySecondary)
                    .frame(width: size - 8, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.leading, 10)
        }
        .addBgWithBorder()
        .onTap {
            Navigation.pushToSwiftUiView(CategoryView(cat: category,isArticleView: isArticleScreen))
        }
    }
}
