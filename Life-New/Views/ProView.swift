//
//  ProView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 23/12/23.
//

import SwiftUI
import RevenueCat

struct ProView: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @StateObject var vm = ProViewModel()
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                BackButton()
                Spacer()
                Text(String.restore.localized(language))
                    .poppinsMedium(17)
                    .foregroundColor(.lessOpSecondary)
                    .onTap {
                        vm.restorePurchases()
                    }
            }
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack(alignment: .center){
                        Image.logo
                            .resizeFitTo(height: 70)
                        HStack(spacing: 5) {
                            Text(String.subscribeTo.localized(language))
                                .poppinsMedium(16)
                                .foregroundColor(.mySecondary)
                            Text(String.pro.localized(language))
                                .poppinsBold(16)
                                .foregroundColor(.customBlue)
                        }
                        .padding(.vertical,5)
                        Text(String.subscribeToDes.localized(language))
                            .poppinsRegular(15)
                            .foregroundColor(.myLightText.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,30)
                            .padding(.bottom)
                    }
                    VStack(spacing: 5) {
                        ForEach(vm.allPackages, id: \.identifier) { package in
                            PurchaseOptionCard(package: package, isSelected: package.identifier == vm.selectedPackage?.identifier)
                                .onTap {
                                    vm.selectedPackage = package
                                }
                        }
                    }
                    .padding(.bottom,30)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(String.whyGoWith.localized(language))
                                .poppinsMedium(16)
                                .foregroundColor(.mySecondary)
                            Text(String.proQ.localized(language))
                                .poppinsBold(16)
                                .gradientForeground(colors: Constant.lightGredientColor)
                            Spacer()
                        }
                        PurchaseBenefitsField(title: .fullyAdFree.localized(language))
                        PurchaseBenefitsField(title: .accessToAll.localized(language))
                        PurchaseBenefitsField(title: .technicalSupport.localized(language))
                        PurchaseBenefitsField(title: .cancelAnyTime.localized(language))
                    }
                    .padding(.bottom)
                    .padding(.horizontal,10)
                    Text(String.proRegulations.localized(language))
                        .poppinsRegular(9)
                        .foregroundColor(.myLightText.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                        .padding(.horizontal)
                }
                .padding(.top,30)
                .padding(.bottom,15)
                
            }
            CustomGradientButton(title: .subscribe){
                vm.makePurchases()
            }
        }
        .onAppear(perform: {
            vm.getOffering()
        })
        .showLoader(isLoading: vm.isLoading)
        .padding()
        .addDarkBackGround()
        .hideNavigationbar()
    }
}

struct CustomGradientButton : View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    var title: String
    var onTap: ()->() = {}
    var backgroundColor: LinearGradient = Constant.lightLinearGradient
    var textColor: Color = .myWhite
    var borderColor: Color = .clear
    var body: some View {
        Text(title.localized(language))
            .poppinsMedium(16)
            .foregroundColor(textColor)
            .padding(21)
            .maxWidth()
            .background(backgroundColor)
            .customCornerRadius(radius: 15)
            .padding(1)
            .background(borderColor)
            .customCornerRadius(radius: 16)
            .onTap(completion: onTap)
    }
}

struct PurchaseBenefitsField: View {
    let title: String
    var body: some View {
        HStack{
            Image.checkBox
                .resizeFitTo(renderingMode: .template, height: 16,radius: 6)
                .foregroundColor(.mySecondary)
            Text(title)
                .poppinsRegular(11)
                .foregroundColor(.mySecondary)
        }
    }
}


struct PurchaseOptionCard: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    var package : Package
    var isSelected = false
    
    
    var body: some View {
        HStack() {
            HStack {
                VStack(alignment: .leading) {
                    Text(package.storeProduct.localizedTitle)
                        .poppinsSemiBold(18)
                        .foregroundColor(.mySecondary)
                    Text(package.storeProduct.localizedDescription)
                        .poppinsRegular(11)
                        .foregroundColor(.mySecondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Text(package.storeProduct.localizedPriceString)
                    .poppinsBold(23)
                    .gradientForeground(colors: isSelected ? Constant.lightGredientColor : [Color.white])
                    .frame(width: 120,alignment: .trailing)
            }
            .padding(.horizontal,15)
        }
        .padding(.vertical)
        .maxWidth()
        .overlay(
            RoundedRectangle(cornerRadius: 25,style: .continuous)
                .stroke(isSelected ?  Color.lightGredientOne : Color.gray, lineWidth: 0.8)
        )
        .padding(.vertical,8)
        .padding(.horizontal,5)

    }
}

#Preview {
    ProView()
}
