//
//  ServerConfig.swift
//  SwiftMoya
//
//  Created by macxjn on 2021/11/11.
//

import Foundation

class ServerConfig: NSObject {
    
    /// 生产环境
    static let proUrl = "https://xxx.com";
    
    /// 开发环境
    static let devUrl = "https://xxx.com";
    
    /// 预发布环境
    static let preUrl = "https://xxx.com";
    
    /// 灰度环境
    static let uatUrl = "https://xxx.com";

    /// Project Path
    static let projectPath = "/xxx/xxx";
    
    /// 图片上传固定地址
    static let imgUrl = "https://xxx.com";



    static func baseUrl(_ serverType: ServerType) -> String {
        
        switch serverType {
        case .dev:
            return devUrl + projectPath
        case .grey:
            return uatUrl + projectPath
        case .pre:
            return preUrl + projectPath
        case .pro:
            return proUrl + projectPath
        }
    }
    
    static func host(_ serverType: ServerType) -> String {
        
        switch serverType {
        case .dev:
            return devUrl
        case .grey:
            return uatUrl
        case .pre:
            return preUrl
        case .pro:
            return proUrl
        }
    }
}
