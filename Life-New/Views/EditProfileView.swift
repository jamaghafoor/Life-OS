//
//  EditProfileView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 23/12/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct EditProfileView: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @StateObject var vm = EditProfileViewModel()
    @EnvironmentObject var player : PlayerViewModel
    let user = SessionManager.shared.getUser()
    var body: some View {
        VStack(alignment: .leading,spacing: 0) {
            CommonTopView(title: .editProfile)
                .padding(.horizontal)
            ScrollView(showsIndicators: false) {
                ZStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            if let image = vm.image {
                                Image(uiImage: image)
                                    .resizeFillTo(width: 250,height: 250,radius: 50)
                            } else if user.image != nil {
                                WebImage(url: user.image?.addBaseURL())
                                    .resizeFillTo(width: 250,height: 250,radius: 50)
                            } else {
                                Image.person
                                    .resizeFitTo(width: 250,height: 250)
                                    .padding(5)
                                    .background(Color.mySecondary)
                                    .customCornerRadius(radius: 50)
                            }
                            Spacer()
                        }
                        .padding(.bottom,30)
                        Text(String.fullName.localized(language))
                            .poppinsRegular(14)
                            .foregroundColor(.myLightText)
                            .foregroundColor(.mySecondary)
                        CustomTextField(placeholder: Text(""), text: $vm.fullname, size: 20)
                            .padding(.bottom,10)
                            .padding(.top,10)
                            .border(width: 0.5, edges: [.top,.bottom], color: .mySecondary.opacity(0.1))
                            .padding(.bottom,10)
                    }
                    .maxWidth()
                    Text(String.edit.localized(language))
                        .poppinsRegular(12)
                        .foregroundColor(.mySecondary)
                        .padding(.horizontal,30)
                        .padding(.vertical,8)
                        .background(Color.darkBlue)
                        .clipShape(.capsule(style: .continuous))
                        .onTap {
                            vm.isShowImagePicker = true
                        }
                        .offset(y: 68)
                }
                .padding(.horizontal)
                .padding(.vertical,40)
            }
            LessCornerRadiusNavigationButton(title: .update) {
                vm.updateProfile()
            }
        }
        .addDarkBackGround()
        .hideNavigationbar()
        .sheet(isPresented: $vm.isShowImagePicker) {
            ImagePicker(image: $vm.image)
                .ignoresSafeArea()
        }
        .showLoader(isLoading: vm.isLoading)
    }
}

struct LessCornerRadiusNavigationButton: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    var title: String
    var onTap: ()->() = {}
    var body: some View {
        Text(title.localized(language))
            .poppinsMedium(16)
            .foregroundColor(.myPrimary)
            .padding()
            .maxWidth()
            .background(Color.mySecondary)
            .customCornerRadius(radius: 12)
            .padding()
            .onTap (completion: onTap)
    }
}

#Preview {
    EditProfileView()
}
