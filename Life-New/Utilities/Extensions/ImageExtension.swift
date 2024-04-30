//
//  ImageExtension.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 20/12/23.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
 
extension Image {
    static let logo                          = Image("logo")
    static let starImage                     = Image("starImage")
    static let apple                         = Image("apple")
    static let google                        = Image("google")
    static let email                         = Image("email")
    static let home                          = Image("home")
    static let category                      = Image("category")
    static let article                       = Image("article")
    static let favourite                     = Image("favourite")
    static let favouriteFill                 = Image("favouriteFill")
    static let profile                       = Image("profile")
    static let eye                           = Image("eye")
    static let hideEye                       = Image("slashEye")
    static let search                        = Image("search")
    static let play                          = Image(systemName: "play.fill")
    static let pause                         = Image(systemName: "pause.fill")
    static let nextArrow                     = Image("nextArrow")
    static let premium                       = Image("premium")
    static let bluePremium                   = Image("bluePremium")
    static let darkBluePremium               = Image("darkBluePremium")
    static let backArrow                     = Image("backArrow")
    static let heartFill                     = Image(systemName: "heart.fill")
    static let edit                          = Image("edit")
    static let person                        = Image("person")
    static let bgPremium                     = Image("bgPremium")
    static let notification                  = Image("notification")
    static let language                      = Image("language")
    static let privacyPolicy                 = Image("privacyPolicy")
    static let rate                          = Image("starCircle")
    static let logOut                        = Image("logOut")
    static let logOutTwo                     = Image("logOutTwo")
    static let delete                        = Image("delete")
    static let darkBlueDelete                = Image("darkBlueDelete")
    static let checkBox                      = Image("checkBox")
    static let close                         = Image(systemName: "xmark")
    static let lines                         = Image("lines")
    static let nextSong                      = Image("nextSong")
    static let previousSong                  = Image("previousSong")
    static let share                         = Image("share")
    static let timer                         = Image("timer")
    static let addWithCircle                 = Image(systemName: "plus.circle")
    static let minusWithCircle               = Image(systemName: "minus.circle")
    static let terms                         = Image("terms")
    
    func resizeFitTo(renderingMode: TemplateRenderingMode = .original,width: CGFloat? = nil,height: CGFloat? = nil,radius: CGFloat = 0) -> some View {
        self.resizable()
            .renderingMode(renderingMode)
            .scaledToFit()
            .frame(width: width,height: height)
            .clipped()
            .contentShape(Rectangle())
            .customCornerRadius(radius: radius)
    }
    
    func resizeFillTo(renderingMode: TemplateRenderingMode = .original ,width: CGFloat? = nil,height: CGFloat? = nil,radius: CGFloat = 0) -> some View {
        self.resizable()
            .renderingMode(renderingMode)
            .scaledToFill()
            .frame(width: width,height: height)
            .clipped()
            .contentShape(Rectangle())
            .customCornerRadius(radius: radius)
    }
}


