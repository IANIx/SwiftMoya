//
//  NetworkStatusManager.swift
//  SwiftMoya
//
//  Created by macxjn on 2021/8/28.
//

import Foundation
import Alamofire

public enum NetworkStatus {
    case unknown
    case notReachable
    case reachableViaWiFi
    case reachableViaWWAN
}

class NetworkStatusManager: NSObject {
    
    static let shared = NetworkStatusManager()
    
    private override init() {}
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
    var isReachable: Bool { return isReachableOnWWAN || isReachableOnWiFi }
    
    var isReachableOnWWAN: Bool { return networkStatus == .reachableViaWWAN }

    var isReachableOnWiFi: Bool { return networkStatus == .reachableViaWiFi }
    
    var networkStatus: NetworkStatus {
        return .unknown
//        guard let status = reachabilityManager?.status else {
//            return .unknown
//        }
//        switch status {
//        case .unknown:
//            return NetworkStatus.unknown
//        case .notReachable:
//            return NetworkStatus.notReachable
//        case .reachable(.ethernetOrWiFi):
//            return NetworkStatus.reachableViaWiFi
//        case .reachable(.cellular):
//            return NetworkStatus.reachableViaWWAN
//        }
    }
}
