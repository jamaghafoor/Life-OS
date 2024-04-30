//
//  RegisterUserModel.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 10/01/24.
//

import Foundation


struct RegisterUserModel: Codable {
    let status: Bool?
    let message: String?
    let data: User?
}

// MARK: - DataClass
struct User: Codable, Hashable, Identifiable {
    let id, loginType, deviceType: Int?
    var identity, fullname, image, likedMusicIDS: String?
    let deviceToken, createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, identity, fullname, image
        case likedMusicIDS = "liked_music_ids"
        case loginType = "login_type"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
