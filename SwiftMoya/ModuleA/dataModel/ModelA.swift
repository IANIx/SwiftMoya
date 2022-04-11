//
//  ModelA.swift
//  SwiftMoya
//
//  Created by macxjn on 2022/4/11.
//

import Foundation
import ObjectMapper

struct ModelA: Mappable {
    var age: Int?

    init?(map: Map) {
    
    }
    
    mutating func mapping(map: Map) {
        age <- map["age"]
    }
}
