//
//  SettingDataModel.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 06/01/24.
//

import Foundation

// MARK: - SettingDataModel
struct SettingDataModel: Codable {
    let status: Bool?
    let message: String?
    let admobs: Admobs?
    let miscs: Miscs?
    let facebooks: Facebooks?
    let socials: Socials?
}

// MARK: - Admobs
struct Admobs: Codable {
    let id: Int?
    let publisherID, admobAppID, bannerID, intersialID: String?
    let nativeID, rewardedID: String?
    let type: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case publisherID = "publisher_id"
        case admobAppID = "admob_app_id"
        case bannerID = "banner_id"
        case intersialID = "intersial_id"
        case nativeID = "native_id"
        case rewardedID = "rewarded_id"
        case type
    }
}

// MARK: - Facebooks
struct Facebooks: Codable {
    let id: Int?
    let facebookAppID, fbBannerID, fbIntersialID, fbNativeID: String?
    let fbRewardedID: String?
    let type: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case facebookAppID = "facebook_app_id"
        case fbBannerID = "fb_banner_id"
        case fbIntersialID = "fb_intersial_id"
        case fbNativeID = "fb_native_id"
        case fbRewardedID = "fb_rewarded_id"
        case type
    }
}

// MARK: - Miscs
struct Miscs: Codable {
    let id: Int?
    let moreApp, privcyURL, terms: String?
    let googleplaylicensekey: String?
    let type: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case moreApp = "more_app"
        case privcyURL = "privcy_url"
        case terms, googleplaylicensekey, type
    }
}

// MARK: - Socials
struct Socials: Codable {
    let id: Int?
    let facebook, youTube, instagram, twitter: String?
    let type: Int?

    enum CodingKeys: String, CodingKey {
        case id, facebook
        case youTube = "you_tube"
        case instagram, twitter, type
    }
}
