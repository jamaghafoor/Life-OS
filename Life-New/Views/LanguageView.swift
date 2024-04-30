//
//  LanguageView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 05/01/24.
//

import SwiftUI

struct LanguageView: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @State private var selectedLanguage: Language = LocalizationService.shared.language
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                CommonTopView(title: .selectLanguage)
                ScrollView(showsIndicators: false) {
                    ForEach(languages, id: \.self) { lang in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(lang.LocalName)
                                .poppinsMedium(16)
                                .foregroundColor(.mySecondary)
                            
                            Text(lang.englishName)
                                .poppinsMedium(14)
                                .foregroundColor(.myLightText)
                        }
                        .addBgToSelectionCard()
                        .overlay(
                            RoundedRectangle(cornerRadius: 11, style: .continuous)
                                .stroke(selectedLanguage == lang.languageCode ? Constant.lightLinearGradient : LinearGradient(colors: [.bgBorder], startPoint: .top, endPoint: .bottom), lineWidth: 1)
                        )
                        .onTapGesture {
                            selectedLanguage = lang.languageCode
                        }
                        .padding([.vertical, .horizontal], 1.5)
                    }
                    .padding(.bottom, Device.bottomSafeArea + 90)
                    .padding(.top,20)
                }
            }
            LessCornerRadiusNavigationButton(title: .change){
                changeLanguage()
            }
        }
        .padding(.bottom, Device.bottomSafeArea)
        .padding(.horizontal)
        .addDarkBackGround()
        .hideNavigationbar()
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func changeLanguage() {
        LocalizationService.shared.language = selectedLanguage
        Navigation.pop()
    }
}

#Preview {
    LanguageView()
}
