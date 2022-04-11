//
//  ModelB.swift
//  SwiftMoya
//
//  Created by macxjn on 2022/4/11.
//

import Foundation
import ObjectMapper

struct ModelB: Mappable {
    var name: String?

    init?(map: Map) {
    
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
    }
}
