//
//  NetworkManager.swift
//  SwiftMoya
//
//  Created by macxjn on 2021/11/11.
//

import Foundation
public typealias RequestBlock<T> = () -> T
public typealias RequestDataBlock<T> = (T) -> Void

public enum ServerType {
    /// 开发环境
    case dev
    
    /// 灰度环境
    case grey
    
    /// 预发布环境
    case pre
    
    /// 生产环境
    case pro
    
    public func baseUrl() -> String {
        return ServerConfig.baseUrl(self)
    }
    
    public func host() -> String {
        return ServerConfig.host(self)
    }
}

public enum RequestStatus {
    /// 账号在其他设备登录
    case expired
}

public class RequestEvent {
    public let status: RequestStatus
    public let message: String?
    public let data: Any?
    
    init(_ status: RequestStatus, message: String?, data: Any?) {
        self.status = status
        self.message = message
        self.data = data
    }
}



public class NetworkManager: NSObject {
    public static let manager = NetworkManager()
    
    /// 默认网络环境为生产环境
    public var serverType = ServerType.pro
    
    /// 通用请求头配置
    public var defaultHeaders: RequestBlock<[String : String]>?
    
    /// 基础请求参数配置
    public var baseParams: RequestBlock<[String : Any]>?

    /// 网络请求事件回调
    public var requestEventCallBack: RequestDataBlock<RequestEvent>?

    
}
