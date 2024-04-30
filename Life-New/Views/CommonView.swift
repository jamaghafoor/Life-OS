//
//  CommonView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 27/12/23.
//

import SwiftUI
import WebKit

struct BackButton: View {
    var onTap: ()->() = {Navigation.pop()}
    var body: some View {
        Image.backArrow
            .resizeFitTo(renderingMode: .template,height: 22)
            .foregroundColor(.mySecondary)
            .onTap(completion: onTap)
    }
}

struct PlayButton: View {
    
    var playSize: CGFloat = 15
    var bgSize: CGFloat = 20
    
    var body: some View {
        Image.play
            .resizeFitTo(height: playSize)
            .foregroundColor(.myWhite)
            .padding(bgSize)
            .padding(.leading,3)
            .background(Color.myPrimary)
            .clipShape(.circle)
        
    }
}

struct PremiumButton: View {
    
    var iconSize: CGFloat = 20
    var bgSize: CGFloat = 20
    var bgColor: Color = Color.myPrimary
    
    var body: some View {
        Image.premium
            .resizeFitTo(height: iconSize)
            .foregroundColor(.myWhite)
            .padding(bgSize)
            .background(bgColor)
            .clipShape(.circle)
            .padding(1)
            .background(Color.bgBorder)
            .clipShape(.circle)
        
    }
}

struct CommonTopView: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    var title: String
    var body: some View {
        HStack {
            BackButton()
            Spacer()
            Text(title.localized(language))
                .poppinsMedium(18)
                .foregroundColor(.mySecondary)
            Spacer()
            BackButton()
                .hidden()
        }
        .padding(.bottom,10)
//        .frame(height: 50)
    }
}

struct LoaderView : View {
    var body: some View {
        ZStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
                .padding(25)
                .background(Color.bgSecondary)
                .cornerRadius(7)
        }
    }
}

extension View {
    @ViewBuilder
    func showLoader(isLoading: Bool) -> some View {
        ZStack {
            self
                .disabled(isLoading)
            if isLoading {
                LoaderView()
            }
        }
    }
}

struct WebViewUrl: UIViewRepresentable {
    // 1
    let url: URL
    // 2
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    // 3
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

struct CommonSubscriptionDialog : View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @AppStorage(SessionKeys.isLogin) var isLogin = 0
    @EnvironmentObject var vm : SplashScreenViewModel
    var body: some View {
        DialogCard(icon: Image.darkBluePremium, title: .subscribeToPro.localized(language), subTitle: .subscribeToProDes.localized(language), buttonTitle: .becomeAPro.localized(language),onClose: {
            withAnimation {
                vm.isShowSubscriptionDialog = false
            }
        },onButtonTap: {
            vm.isShowSubscriptionDialog = false
            if isLogin == 2 {
                Navigation.pushToSwiftUiView(ProView())
            } else {
                vm.showLoginSheet = true
            }
        }
        )
    }
}

struct CloseButton : View {
    var onTap : ()->() = {}
    var body: some View {
        Image.close
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.mySecondary)
            .onTap(completion: onTap)
    }
}

struct CommonSheetTopView : View {
    var title: String
    var onClose: ()->() = {}
    var body: some View {
        VStack {
            HStack {
                CloseButton(onTap: onClose)
                Spacer()
                Text(title)
                    .poppinsMedium(17)
                    .foregroundColor(.mySecondary)
                Spacer()
                CloseButton()
                    .hidden()
            }
        }
    }
}
