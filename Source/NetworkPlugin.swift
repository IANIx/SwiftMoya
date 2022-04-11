//
//  NetworkPlugin.swift
//  SwiftMoya
//
//  Created by macxjn on 2021/8/28.
//

import Foundation
import Moya
import SwiftyJSON

public final class NetworkPlugin {

}

// MARK: - PluginType
extension NetworkPlugin: PluginType {
    
    public func willSend(_ request: RequestType, target: TargetType) {
        
        /// Do Something
        

    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        print("[NetworkPlugin] request url: \(target.baseURL)\(target.path)")

        switch target.task {
        case .requestParameters( let parameters, _):
            print("[NetworkPlugin] request parameters: \(parameters))")
        default:
            break
        }
        
        switch result {
        case .success(let response):
            print("[NetworkPlugin] response data: \(JSON(response.data))")
            if let data = response.model, data.code == RequestStatusCode.expired.rawValue {
                let event = RequestEvent(.expired, message: data.message, data: data)
                NetworkManager.manager.requestEventCallBack?(event)
            }
        case .failure(let error):
            print("[NetworkPlugin] request error: \(error)")
        }
    }
    
    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {

        guard let target = target as? RequestService else {
            return result
        }

        /// 加密请求对data进行解密操作
        func decryptResult(_ result: Result<Response, MoyaError>) -> Result<Response, MoyaError> {
            switch result {
                case .success(let response):
                let en = AesCryptor.decrypt(response.data.string ?? "")
                let deResponse = Response(statusCode: response.statusCode, data: en.data ?? Data(), request: response.request, response: response.response)
                return .success(deResponse)
            default:
                return result
            }
        }
        
        switch target {
        case .encrypt(_, _, _):
            return decryptResult(result)
        default:
            return result
        }
    }
}
