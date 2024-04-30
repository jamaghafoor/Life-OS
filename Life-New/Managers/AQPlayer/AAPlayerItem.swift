//
//  AQPlayerItem.swift
//  AQPlayer
//
//  Created by Ahmad Amri on 3/11/19.
//  Copyright © 2019 Amri. All rights reserved.
//

import Foundation
import AVFoundation

class AQPlayerItem: AVPlayerItem {
    var index: Int!
    var itemInfo: AQPlayerItemInfo!
    

    func setup(index: Int, itemInfo: AQPlayerItemInfo! = nil) {
        if let startAt = itemInfo.startAt {
            self.seek(to: CMTime(seconds: startAt, preferredTimescale: D.preferredTimescale), completionHandler: nil)
        }
        self.index = index
        self.itemInfo = itemInfo
    }
}


