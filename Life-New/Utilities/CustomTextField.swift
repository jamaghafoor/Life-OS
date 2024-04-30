//
//  CustomTextField.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 21/12/23.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    var showHideUnHideButton: Bool = false
    @State var isShow = false
    var size: CGFloat = 16
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                if text.isEmpty { placeholder.poppinsRegular(16) }
                if showHideUnHideButton == false || isShow {
                    TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                        .font(.custom(MyFont.PoppinsMedium, size: size))
                        .foregroundColor(.mySecondary)
                } else {
                    SecureField("", text: $text,onCommit: commit)
                        .font(.custom(MyFont.PoppinsMedium, size: size))
                        .foregroundColor(.mySecondary)
                }
            }
            if showHideUnHideButton {
                Image(isShow ? "slashEye" : "eye")
                    .resizeFitTo(renderingMode: .template, width: 25,height : 30)
                    .padding(.top, isShow ? 4 : 0)
                    .foregroundColor(.mySecondary)
                    .onTap {
                        isShow.toggle()
                    }
                    .frame(maxWidth: 30,maxHeight: 30)
            }
        }
    }
}
