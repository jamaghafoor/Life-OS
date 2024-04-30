//
//  CustomAlert.swift
//  Woomeout
//
//  Created by Aniket Vaddoriya on 16/09/23.
//

import SwiftUI


/// Custom Alert
struct CustomAlert<Content, Actions>: View where Content: View, Actions: View {
    var title: Text?
    @Binding var isPresented: Bool
    @ViewBuilder var content: () -> Content
    @ViewBuilder var actions: () -> Actions
    
    // Size holders to enable scrolling of the content if needed
    @State private var viewSize: CGSize = .zero
    @State private var contentSize: CGSize = .zero
    @State private var actionsSize: CGSize = .zero
    
    @State private var fitInScreen = false
    
    // Used to animate the appearance
    @State private var isShowing = false
    
    var body: some View {
        ZStack {
            Blur(style: .dark)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
//                .background(BlurView(style: .systemMaterialDark).opacity(0.5))
            
            VStack(spacing: 0) {
                Spacer()
                if isShowing {
                    alert
                        .animation(nil, value: height)
                }
                Spacer()
            }
        }
        .captureSize($viewSize)
        .onAppear {
            withAnimation {
                isShowing = true
            }
        }
    }
    
    var height: CGFloat {
        // View height - padding top and bottom - actions height
        let maxHeight = viewSize.height - 60 - actionsSize.height
        let min = min(maxHeight, contentSize.height)
        return max(min, 0)
    }
    
    var minWidth: CGFloat {
        // View width - padding leading and trailing
        let maxWidth = viewSize.width - 20
        // Make sure it fits in the content
        let min = min(maxWidth, contentSize.width)
        return max(min, 0)
    }
    
    var maxWidth: CGFloat {
        // View width - padding leading and trailing
        let maxWidth = viewSize.width - 20
        // Make sure it fits in the content
        let min = min(maxWidth, contentSize.width)
        // Smallest AlertView should be 270
        print(max(min, 270))
        return max(min, 270)
    }
    
    var alert: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                ScrollView(.vertical,showsIndicators: false) {
                    VStack(spacing: 4) {
                        title?
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        
                        content()
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }
                    .foregroundColor(.primary)
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 20)
//                    .frame(maxWidth: .infinity)
                    .captureSize($contentSize)
                    // Force `Environment.isEnabled` to `true` because outer ScrollView is most likely disabled
                    .environment(\.isEnabled, true)
                }
                .frame(height: height)
                .onUpdate(of: contentSize) { contentSize in
                    fitInScreen = contentSize.height <= proxy.size.height
                }
                .disabled(fitInScreen)
            }
            .frame(height: height)
            
            _VariadicView.Tree(ContentLayout(isPresented: $isPresented), content: actions)
//                .buttonStyle(.alert)
                .captureSize($actionsSize)
        }
//        .frame(minWidth: minWidth, maxWidth: maxWidth)
//        .frame(width: UIScreen.main.bounds.width - 82)
//        .background(BlurView(style: .systemMaterialDark))
        .clipShape(RoundedRectangle(cornerRadius: 25,  style: .continuous))
        .padding(30)
        .transition(.opacity.combined(with: .scale(scale: 1.1)))
        .animation(.default, value: isPresented)
    }
}

struct ContentLayout: _VariadicView_ViewRoot {
    @Binding var isPresented: Bool
    
    func body(children: _VariadicView.Children) -> some View {
        VStack(spacing: 0) {
            ForEach(children) { child in
                Divider()
                child
                    .simultaneousGesture(TapGesture().onEnded { _ in
                        isPresented = false
                        // Workaround for iOS 13
                        if #available(iOS 15, *) { } else {
                            AlertWindow.dismiss()
                        }
                    })
            }
        }
    }
}
