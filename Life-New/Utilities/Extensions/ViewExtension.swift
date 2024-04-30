//
//  ViewExtension.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 20/12/23.
//

import SwiftUI
import Combine
import SDWebImageSwiftUI

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: .top,
                endPoint: .bottom)
        )
        .mask(self)
    }
    
    
    func addBaseForegroundGrad() -> some View {
        self.gradientForeground(colors: Constant.commonGradientColors)
    }
    
    func addDarkBackGround() -> some View {
        self
            .background(VStack{
                Image.starImage
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .contentShape(Rectangle())
                Spacer()
            })
            .background(Constant.linearGradient.maxFrame().ignoresSafeArea())
    }
    
    
    
    func maxWidth(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func maxFrame(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity,alignment: alignment)
    }
    
    @ViewBuilder
    func hideNavigationbar() -> some View {
        if #available(iOS 16, *) {
            self.toolbar(.hidden, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
        } else {
            self.navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func onTap(completion: @escaping ()->()) -> some View {
        Button(action: completion, label: {
            self
                .contentShape(Rectangle())
        })
                .buttonStyle(MyButtonStyle())
    }
    
    func addBgWithBorder() -> some View {
        self.padding(10)
            .background(Color.bgFrame)
            .customCornerRadius(radius: 35)
            .padding(1)
            .background(Color.bgBorder)
            .customCornerRadius(radius: 37)
            .padding(.horizontal)
    }
    
    func addBgWithBoderOnHzCard() -> some View {
        self.background(Color.bgFrame)
            .customCornerRadius(radius: 18)
            .padding(1)
            .background(Color.bgBorder)
            .customCornerRadius(radius: 18.5)
            .padding(.horizontal)
    }
    
    func addBgToSelectionCard() -> some View {
        self.padding(.leading,18)
            .padding(.vertical,8)
            .maxWidth(alignment: .leading)
            .background(Color.bgSecondary)
            .customCornerRadius(radius: 10)
    }
    
    func addbgToProfileCard() -> some View {
        self.background(Color.bgFrame)
            .customCornerRadius(radius: 15)
            .padding(1)
            .background(Color.bgBorder)
            .customCornerRadius(radius: 15.5)
            .padding(.horizontal)
    }
}


struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            
//            .opacity(configuration.isPressed ? 0.5 : 1)
        
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}

extension View where Self: KeyboardReadable {
    func onKeyboardVisibilityChanged(_ action: @escaping (Bool) -> Void) -> some View {
        return self.onReceive(keyboardPublisher) { newIsKeyboardVisible in
            action(newIsKeyboardVisible)
        }
    }
}

extension View {
    func customCornerRadius(radius: CGFloat) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}

extension String {
    func htmlToString() -> String {
        return  try! NSAttributedString(data: self.data(using: .utf8)!,
                                        options: [.documentType: NSAttributedString.DocumentType.html],
                                        documentAttributes: nil).string
    }
}

extension View {
  func disableBounces() -> some View {
    modifier(DisableBouncesModifier())
  }
}

struct DisableBouncesModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .onAppear {
        UIScrollView.appearance().bounces = false
      }
      .onDisappear {
        UIScrollView.appearance().bounces = true
      }
  }
}
   

