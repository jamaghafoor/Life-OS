//
//  ColorExtension.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 20/12/23.
//

import Foundation
import SwiftUI

extension ShapeStyle where Self == Color {
//    static var myWhite : Color {
//        Color.white
//    }
//    
//    static var myBlack : Color {
//        Color.black
//    }
//    
//    static var mySecondary : Color {
//        Color(hexString: "#D0D7FF")
//    }
//    
//    static var lessOpSecondary : Color {
//        Color.mySecondary.opacity(0.6)
//    }
//    
//    static var bgSecondary : Color {
//        Color.mySecondary.opacity(0.1)
//    }
//    static var bgBorder : Color {
//        Color(hexString: "#222746")
//    }
//    
//    static var bgFrame : Color {
//        Color(hexString: "#141A37")
//    }
//    
//    static var myPrimary: Color {
//        Color(hexString: "#040C3D")
//    }
//    
//    static var darkBlueOne : Color {
//        Color(hexString: "#00041A")
//    }
//    
//    static var darkBlueTwo : Color {
//        Color(hexString: "#000318")
//    }
//    
//    static var darkBlueThree : Color {
//        Color(hexString: "#050E45")
//    }
    
}

extension Color {
    static var mySecondaryColor = Color(#colorLiteral(red: 0.3124583152, green: 0.7932861637, blue: 0.9764705896, alpha: 0.3692364839))
    static let darkPrimary = Color(#colorLiteral(red: 0.211533894, green: 0.4864295182, blue: 0.5369179537, alpha: 1))
    static let redGrad = LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9901739955, green: 0.6174576879, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.7942389599, green: 0.2180945365, blue: 0.03030905461, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}
