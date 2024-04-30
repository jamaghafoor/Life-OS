//
//  AQPlayerItemInfo.swift
//  AQPlayer
//
//  Created by Ahmad Amri on 3/13/19.
//  Copyright © 2019 Amri. All rights reserved.
//
import SwiftUI
import SDWebImageSwiftUI
import AVFoundation

public class AQPlayerItemInfo: Equatable,Comparable {
    public static func < (lhs: AQPlayerItemInfo, rhs: AQPlayerItemInfo) -> Bool {
        return true
    }
    
    public var id: Int!
    public var categoryId: Int!
     var category: Category!
    public var url: URL!
    public var title: String!
    public var albumTitle: String!
    public var coverImage: UIImage!
    public var imageURL : URL?
    public var startAt: TimeInterval!
    public var type: Int
    
     init(id: Int!,categoryId: Int!,category: Category!, url: URL!, title: String!, albumTitle: String!, coverImageURL: URL!,type: Int,startAt: TimeInterval!) {
        self.id = id
        self.categoryId = categoryId
         self.category = category
        self.url = url
        self.title = title
        self.albumTitle = albumTitle
        self.coverImage = UIImage(named: "logo")!
        self.imageURL = coverImageURL
        self.type = type
        if let url = coverImageURL {
            SDWebImageManager().loadImage(with: url, context: nil) { _, _, _ in
                
            } completed: { image, _, _, _, _, _ in
                if let image = image {
                    self.coverImage = image
                }
            }
        }
        
        self.startAt = startAt
    }
    
    public static func == (lhs: AQPlayerItemInfo, rhs: AQPlayerItemInfo) -> Bool {
        return lhs.id == rhs.id || lhs.url == rhs.url
    }
}

