//
//  ArticleView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 25/12/23.
//

import SwiftUI
import SDWebImageSwiftUI
import ScalingHeaderScrollView
import Combine
import WebKit

struct ArticleDetailView: View {
    @State private var show: CGFloat = 0
    let webView = WKWebView()
    var cat: Category
    var article: Article
    @State var height = CGFloat.zero
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                ZStack(alignment:.topLeading) {
                    VStack(spacing: 0) {
                        ScalingHeaderScrollView  {
                            ZStack {
                                VStack(alignment: .leading) {
                                    Spacer()
                                    Text(cat.title ?? "")
                                        .poppinsMedium(15)
                                        .foregroundColor(.lessOpSecondary)
                                        .opacity(1 - show)
                                    //                                    Text(article.title ?? "")
                                    //                                        .poppinsMedium(30 - (10 * (show)))
                                    //                                        .foregroundColor(.mySecondary)
                                    //                                        .fixedSize(horizontal: false, vertical: true)
                                    //                                        .padding(.leading ,(40 * show))
                                    Text(article.title ?? "")
                                        .poppinsMedium(26)
                                        .foregroundColor(.mySecondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .opacity(1 - show)
                                }
                                .maxWidth(alignment: .leading)
                                
                                .padding(15)
                                .background(
                                    WebImage(url: article.image?.addBaseURL())
                                        .resizable()
                                        .placeholder(Image("logo"))
                                        .scaledToFill()
                                        .frame(width: Device.width)
                                        .clipped()
                                        .contentShape(Rectangle())
                                        .overlay(
                                            Color.darkBlueOne
                                                .opacity(show + 0.3)
                                        )
                                )
                            }
                        }
                        content : {
                            HtmlTextView(str: article.content ?? "", height: $height)
                                .frame(minHeight: Device.height)
                                .frame(height: height)
                                .padding(.horizontal,10)
                                .padding(.top,5)
                                .padding(.bottom,110)
                        }
                        .hideScrollIndicators()
                        .height(min: 50 + Device.topSafeArea,max: 300 + Device.topSafeArea)
                        .collapseProgress($show)
                        .allowsHeaderCollapse()
                        .ignoresSafeArea()
//                        .background(Color.white)
                    }
                    .ignoresSafeArea()
                    VStack(alignment: .center,spacing: 0) {
                        HStack(spacing: 0) {
                            Image.backArrow
                                .resizeFitTo(height: 22)
                                .foregroundColor(.mySecondary)
                                .padding(.horizontal)
                                .onTap {
                                    Navigation.pop()
                                }
                            Text(article.title ?? "")
                                .poppinsMedium(18)
                                .foregroundColor(.mySecondary)
                                .padding(.leading,10)
                                .lineLimit(1)
                                .opacity(show)
                            Spacer()
                            Text(article.createdAt?.databaseDateToDate ?? "")
                                .poppinsMedium(13)
                                .foregroundColor(.mySecondary.opacity(0.7))
                                .padding(.trailing)
                        }
                        .padding(.top,10)
                        .frame(height: 50 + Device.topSafeArea,alignment: .top)
                        .maxWidth()
                        Spacer()
                    }
                }
            }
            MiniPlayerView()
        }
        .background(Color.myPrimary.ignoresSafeArea())
        .hideNavigationbar()
    }
}

struct HtmlTextView: View {
    @State var str : String
    @Binding var height: CGFloat
    var body: some View {
        WebView(text: str, dynamicHeight: $height)
            .frame(height: height)
    }
}

struct WebView: UIViewRepresentable {
    
    @State var text: String
    @Binding var dynamicHeight: CGFloat
    var webview: WKWebView = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webview.scrollView.bounces = false
        webview.navigationDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let bgColor = UIColor(Color.myPrimary).toHex() ?? ""
        let setText = "<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head><body style=\"background-color: \(bgColor); color: #ffffff\">\(text)</body></html>"
        uiView.loadHTMLString(setText, baseURL: nil)
    }
    
    class Coordinator : NSObject,WKNavigationDelegate {
        var parent : WebView
        init(parent: WebView) {
            self.parent = parent
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            
            if self.parent.dynamicHeight == .zero {
                
                self.parent.dynamicHeight = 300
                
                webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.parent.dynamicHeight = height as! CGFloat
                    }
                })
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let js = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='100%'"
                webView.evaluateJavaScript(js, completionHandler: nil)
            }
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

extension UIColor {
    func toHex(alpha: Bool = false) -> String? {
            guard let components = cgColor.components, components.count >= 3 else {
                return nil
            }

            let r = Float(components[0])
            let g = Float(components[1])
            let b = Float(components[2])
            var a = Float(1.0)

            if components.count >= 4 {
                a = Float(components[3])
            }

            if alpha {
                return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
            } else {
                return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
            }
        }
}
