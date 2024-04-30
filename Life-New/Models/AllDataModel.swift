//
//  AllDataModel.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 09/01/24.
//

import Foundation

struct AllDataModel: Codable {
    let status: Bool?
    let message: String?
    let musics: [Sound]?
    let categories: [Category]?
    let articles: [Article]?
    let quotes: [Quote]?
    let settings: Setting?
}

// MARK: - Article
struct Article: Codable {
    let id, categoryID: Int?
    let title, image: String?
    let content: String?
    let createdAt, updatedAt: String?
    var category: Category?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case title, image, content
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let title, image, createdAt, updatedAt: String?
    var sounds : [Sound] {
        SplashScreenViewModel.shared.allSounds.filter({ $0.categoryID == self.id })
    }
    
    var articles : [Article] {
        SplashScreenViewModel.shared.articles.filter({ $0.categoryID == self.id })
    }

    enum CodingKeys: String, CodingKey {
        case id, title, image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Music
struct Sound: Codable {
    var id, categoryID: Int?
    var title: String?
    var plays: Int?
    var sound: String?
    var type, isFeatured: Int?
    var image, createdAt, updatedAt: String?
    var category: Category?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case title, plays, sound, type
        case isFeatured = "is_featured"
        case image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Quote
struct Quote: Codable {
    let id: Int?
    let quotes, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, quotes
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Setting
struct Setting: Codable {
    let id: Int?
    let appName, bannerIDAndroid, intersialIDAndroid, nativeIDAndroid: String?
    let bannerIDIos, intersialIDIos, nativeIDIos, createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case appName = "app_name"
        case bannerIDAndroid = "banner_id_android"
        case intersialIDAndroid = "intersial_id_android"
        case nativeIDAndroid = "native_id_android"
        case bannerIDIos = "banner_id_ios"
        case intersialIDIos = "intersial_id_ios"
        case nativeIDIos = "native_id_ios"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


extension Sound {
    func toAQPlayerItem() -> AQPlayerItemInfo {
        AQPlayerItemInfo(id: self.id ?? 0, categoryId: self.categoryID ?? 0, category: self.category, url: self.sound.addBaseURL(), title: self.title ?? "", albumTitle: "", /*albumTitle: self.category?.title ?? "",*/ coverImageURL: self.image.addBaseURL(), type: self.type ?? 0, startAt: 0)
        
    }
}
