//
//  RequestService.swift
//  SwiftMoya
//
//  Created by macxjn on 2021/8/28.
//

import Foundation
import Moya
import CryptoSwift

public enum RequestService {
    /// Get Method
    case get(_ path: String, parameter: [String: Any]? = nil, base: String? = nil)
    
    /// Post Method
    case post(_ path: String, parameter: [String: Any]?, base: String? = nil)
    
    /// Put Method
    case put(_ path: String, parameter: [String: Any]? = nil, base: String? = nil)
    
    /// Delete Method
    case delete(_ path: String, parameter: [String: Any]? = nil, base: String? = nil)
    
    /// 加密请求
    case encrypt(_ path: String, parameter: [String: Any]?, base: String? = nil)
    
    /// 上传图片
    case uploadImage(_ imgs: [UIImage])

}

extension RequestService: TargetType {
    public var baseURL: URL {
        let defaultBase = URL(string: NetworkManager.manager.serverType.baseUrl())!
        
        switch self {
        case .get(_, _, let base):
            return base == nil ? defaultBase : URL(string: base!)!
        case .post(_, _, let base):
            return base == nil ? defaultBase : URL(string: base!)!
        case .put(_, _, let base):
            return base == nil ? defaultBase : URL(string: base!)!
        case .delete(_, _, let base):
            return base == nil ? defaultBase : URL(string: base!)!
        case .encrypt(_, _, let base):
            return base == nil ? defaultBase : URL(string: base!)!
        case .uploadImage(_):
            return URL(string: ServerConfig.imgUrl)!
        }
    }
    
    public var path: String {
        switch self {
        case .get(let path, _, _):
            return path
        case .post(let path, _, _):
            return path
        case .put(let path, _, _):
            return path
        case .delete(let path, _, _):
            return path
        case .encrypt(let path, _, _):
            return path
        case .uploadImage(_):
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .get(_, _, _):
            return .get
        case .post( _, _, _):
            return .post
        case .put( _, _, _):
            return .put
        case .delete( _, _, _):
            return .delete
        case .encrypt( _, _, _):
            return .post
        case .uploadImage(_):
            return .post
        }
    }
        
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .get(_, _, _):
            return URLEncoding(destination: .queryString)
      
        default: break
        }
        
        return JSONEncoding.default // Send parameters as JSON in request body
    }
    
    public var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    public var task: Task {
        switch self {
        case .get(_, let params, _):
            return .requestParameters(parameters: params ?? [:], encoding: URLEncoding(destination: .queryString))
            
        case .post(_, let params, _), .put(_, let params, _), .delete(_, let params, _):
            return .requestParameters(parameters: mergeBaseParam(params),
                                      encoding: JSONEncoding.default)
        case .encrypt(_, let params, _):
            let enParams = ["data": AesCryptor.encrypt(mergeBaseParam(params).json ?? "")]
            return .requestParameters(parameters: enParams, encoding: JSONEncoding.default)
            
        case .uploadImage(let imgs):
            var arr :[MultipartFormData] = []
            for (i,image) in imgs.enumerated(){
                arr.append(MultipartFormData(provider: .data(image.pngData()!), name: "file", fileName: "\(i).jpg", mimeType: "image/jpg"))
            }
            return .uploadMultipart(arr)
        }
    }
    
    public var headers: [String : String]? {
        return NetworkManager.manager.defaultHeaders?()
    }
    
    private func mergeBaseParam(_ parameter: [String: Any]?) -> [String: Any] {
        var baseParams = NetworkManager.manager.baseParams?() ?? [:]
        if let parameter = parameter {
            baseParams.merge(parameter, uniquingKeysWith: {$1})
        }
        return baseParams
    }
}
