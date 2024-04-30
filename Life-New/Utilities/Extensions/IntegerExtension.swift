//
//  IntegerExtension.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 18/01/24.
//

import Foundation

extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        let billion = number / 1000000000
        let trillion = number / 1000000000000
        
        if trillion >= 1.0 {
            return "\(round(trillion*10)/10)T"
        } 
        else if billion >= 1.0 {
            return "\(round(billion*10)/10)B"
        }
        else if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)k"
        }
        else {
            return "\(self)"
        }
    }
    
  
}
