//
//  File.swift
//  SwiftMoya
//
//  Created by macxjn on 2022/4/11.
//

import Foundation

public extension Dictionary {
    
    /// Dictionary - > Json String
    var json: String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions()) {
            let jsonStr = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            return String(jsonStr ?? "")
        }
        return nil
    }
}


public extension Data {
    
    /// data - > String
    var string: String? {
        return String(data: self, encoding: .utf8)
    }
}


public extension String {
    
    /// String - > Data
    var data: Data? {
        return self.data(using: .utf8)
    }
}
