//
//  HomeVIewModel.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 04/01/24.
//

import Foundation

// MARK: - HomeVIewModels
struct HomeModel: Codable {
    let status: Bool?
    let message: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let featured: [Sound]?
    let quotes: [Quote]?
    let category: [Category]?
}

// MARK: - Sound
struct Sound: Codable {
    let id, categoryID: Int?
    let title: String?
    let plays: Int?
    let sound: String?
    let type, featured: Int?
    let image, createdAt, updatedAt: String?
    let category: Category?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case title, plays, sound, type, featured, image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case category
    }
}

// MARK: - Category
struct Category: Codable {
    var id: Int?
    var title, image, createdAt, updatedAt: String?
    var sound: [Sound]?
    var sound_count : Int?
    var articles_count : Int?

    enum CodingKeys: String, CodingKey {
        case id, title, image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case sound,sound_count,articles_count
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

extension Sound {
    func toAQPlayerItem() -> AQPlayerItemInfo {
        AQPlayerItemInfo(id: self.id ?? 0, url: self.sound.addBaseURL(), title: self.title ?? "", albumTitle: self.category?.title ?? "",coverImageURL: self.image.addBaseURL(), type: self.type ?? 0, startAt: 0)
    }
}
