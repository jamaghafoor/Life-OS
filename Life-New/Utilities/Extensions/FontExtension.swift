//
//  FontExtension.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 20/12/23.
//

import Foundation
import SwiftUI

struct MyFont {
    
        static var PoppinsBlack             = "Poppins-Black"
        static var PoppinsBold              = "Poppins-Bold"
        static var PoppinsLight             = "Poppins-Light"
        static var PoppinsMedium            = "Poppins-Medium"
        static var PoppinsRegular           = "Poppins-Regular"
        static var PoppinsThin              = "Poppins-Thin"
        static var PoppinsExtraBold         = "Poppins-ExtraBold"
        static var PoppinsExtraLight        = "Poppins-ExtraLight"
        static var PoppinsSemiBold          = "Poppins-SemiBold"
    
}

extension Text {
    
    func poppinsBlack(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsBlack,size: CGFloat(size)))
    }
    func poppinsBold(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsBold,size: CGFloat(size)))
    }
    func poppinsLight(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsLight,size: CGFloat(size)))
    }
    func poppinsMedium(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsMedium,size: CGFloat(size)))
    }
    func poppinsRegular(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsRegular,size: CGFloat(size)))
    }
    func poppinsThin(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsThin,size: CGFloat(size)))
    }
    func poppinsExtraBold(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsExtraBold,size: CGFloat(size)))
    }
    func poppinsExtraLight(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsExtraLight,size: CGFloat(size)))
    }
    func poppinsSemiBold(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsSemiBold,size: CGFloat(size)))
    }
    
}


extension View {
    
    func poppinsBlack(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsBlack,size: CGFloat(size)))
    }
    func poppinsBold(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsBold,size: CGFloat(size)))
    }
    func poppinsLight(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsLight,size: CGFloat(size)))
    }
    func poppinsMedium(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsMedium,size: CGFloat(size)))
    }
    func poppinsRegular(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsRegular,size: CGFloat(size)))
    }
    func poppinsThin(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsThin,size: CGFloat(size)))
    }
    func poppinsExtraBold(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsExtraBold,size: CGFloat(size)))
    }
    func poppinsExtraLight(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsExtraLight,size: CGFloat(size)))
    }
    func poppinsSemiBold(_ size : CGFloat = 16) -> some View {
        return self.font(Font.custom(MyFont.PoppinsSemiBold,size: CGFloat(size)))
    }
    
}
