//
//  DialogView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 24/12/23.
//

import SwiftUI

struct DialogCard: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    let icon: Image
    let title: String
    let subTitle: String
    let buttonTitle: String
    var onClose: ()->() = {}
    var onButtonTap: ()->() = {}
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                icon
                    .resizeFitTo(renderingMode: .template,height: 60)
                    .foregroundColor(.myPrimary)
                Text(title)
                    .poppinsSemiBold(20)
                    .foregroundColor(.myPrimary)
                    .padding(.top,10)
                    .padding(.bottom,8)
                Text(subTitle)
                    .poppinsMedium(15)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.myLightText)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom,12)
                Text(buttonTitle)
                    .poppinsMedium(15)
                    .foregroundColor(.mySecondary)
                    .maxWidth()
                    .padding(.vertical)
                    .background(Color.myPrimary)
                    .clipShape(.capsule(style: .continuous))
                    .padding(.bottom,12)
                    .onTap(completion: onButtonTap)
            }
            .padding(.horizontal)
            .padding(.vertical,10)
            .background(Color.mySecondary)
            .customCornerRadius(radius: 35)
            .padding(.horizontal,10)
            .padding(.vertical,11)
            
            Image.close
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.black)
                .padding(5)
                .background(Color.mySecondary)
                .clipShape(.circle)
                .padding(3)
                .background(Color.myPrimary)
                .clipShape(.circle)
                .padding(.top,5)
                .onTap (completion: onClose)
        }
        .maxFrame()
        
    }
}

