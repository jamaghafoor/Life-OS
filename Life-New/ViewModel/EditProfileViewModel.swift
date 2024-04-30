//
//  EditProfileViewModel.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 10/01/24.
//

import Foundation
import Alamofire
import UIKit

class EditProfileViewModel : BaseViewModel {
    @Published var fullname = SessionManager.shared.getUser().fullname ?? ""
    @Published var userId = "\(SessionManager.shared.getUser().id ?? 0)"
    @Published var image : UIImage?
    @Published var isShowImagePicker = false
       
    
    func updateProfile() {
        self.startLoading()
        let params = [Params.user_id: "\(SessionManager.shared.getUser().id ?? 0)", Params.fullname: "\(fullname)"]
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                multipartFormData.append(value.data(using: .utf8)!, withName: key.rawValue)
            }
            
            if let data = self.image{
                multipartFormData.append(data.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            
        }, to: "\(WebServices.baseURL)\(APIs.editprofile.rawValue)",method: .post,headers: HTTPHeaders([WebServices.HeaderKey: WebServices.HeaderValue]))
        .responseString { response in
            print(response)
            if let data = response.data {
                do {
                    let jsonData = try JSONDecoder().decode(RegisterUserModel.self, from: data)
                    if let user = jsonData.data {
                        SessionManager.shared.setUser(datum: user)
                        self.stopLoading()
                        Navigation.pop()
                    }
                }
                catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
