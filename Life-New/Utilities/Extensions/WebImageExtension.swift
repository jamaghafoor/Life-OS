//
//  WebImageExtension.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 18/01/24.
//

import Foundation
import SDWebImageSwiftUI
import SwiftUI

extension WebImage {
    
    func customCornerRadius(radius: CGFloat) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
    
    func resizeFitTo(width: CGFloat? = nil,height: CGFloat? = nil,radius: CGFloat = 0) -> some View {
        self.resizable()
            .placeholder {
                Color.myWhite.opacity(0.1)
            }
            .scaledToFit()
            .frame(width: width,height: height)
            .clipped()
            .contentShape(Rectangle())
            .customCornerRadius(radius: radius)
    }
    
    func resizeFillTo(width: CGFloat? = nil,height: CGFloat? = nil,radius: CGFloat = 0) -> some View {
        self.resizable()
            .placeholder {
                Color.myWhite.opacity(0.1)
            }
            .scaledToFill()
            .frame(width: width,height: height)
            .clipped()
            .contentShape(Rectangle())
            .customCornerRadius(radius: radius)
    }
}


