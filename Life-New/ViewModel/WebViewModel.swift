//
//  WebViewModel.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 19/01/24.
//

import Foundation
import SwiftUI
import WebKit
import SDWebImageSwiftUI

class WebViewModel: ObservableObject {
    @Published var url: String?
    @Published var isLoading: Bool = true
}

struct WebUrlView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    @StateObject var vm: WebViewModel
    let webView = WKWebView()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self.vm)
    }
    
    func goBack() {
        webView.goBack()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        private var vm: WebViewModel
        
        init(_ viewModel: WebViewModel) {
            self.vm = viewModel
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.vm.isLoading = false
        }
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<WebView>) { }
    
    func makeUIView(context: Context) -> UIView {
        self.webView.navigationDelegate = context.coordinator
        
        if let url = URL(string: self.vm.url ?? "") {
            self.webView.load(URLRequest(url: url))
        }
        
        return self.webView
    }
}


struct WebUrl: View {
    var url: String
    var title: String
    var onClose: ()->() = {}
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @StateObject var model = WebViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                CloseButton(onTap: onClose)
                Spacer()
                Text(title)
                    .poppinsMedium(17)
                    .foregroundColor(.mySecondary)
                Spacer()
                ActivityIndicator($model.isLoading)
            }
            .padding(.horizontal)
            .padding(.vertical)
            .background(Color.bgFrame)
            if model.url != nil {
                WebUrlView(vm: model)
            } else {
                Spacer()
            }
        }
        .onAppear {
            model.url = url
        }
    }
}
