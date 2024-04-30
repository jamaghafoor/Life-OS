//
//  StringExtension.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 05/01/24.
//

import Foundation

extension String {
    var databaseDateToDate : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from:self)!
        dateFormatter.dateFormat = "dd MMM yyyy"
        let srt = dateFormatter.string(from: date)
        return srt
    }
    
    
}

func timeString(time: TimeInterval) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60

        // return formated string
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }

