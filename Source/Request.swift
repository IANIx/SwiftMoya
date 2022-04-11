//
//  Request.swift
//  SwiftMoya
//
//  Created by macxjn on 2021/8/28.
//

import Foundation
import CryptoSwift
import ObjectMapper
import SwiftyJSON
import RxSwift
import Moya

public enum ViewModelResult<T, K> {
    case loading
    case success(T)
    case failure(K)
}

public enum RequestStatusCode: Int {
    case expired = 666
}

let logPlugin = NetworkLoggerPlugin()
let Plugin = NetworkPlugin()
public let requestProvider = MoyaProvider<RequestService>(plugins: [Plugin])

private func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}

public struct Request {
}

public extension Response {
    var model: RequestModel? {
        
        let json = JSON(self.data)
        
        guard json.type != SwiftyJSON.Type.null,
              let code = json["code"].int ?? json["status"].int,
              let message = json["message"].string ?? (json["msg"].string ?? json["tip"].string) else {
            return nil
        }


        return RequestModel(code: code, message: message, data: json["data"].object)
    }
    
    func _filter<R: RangeExpression>(statusCodes: R) throws -> Response where R.Bound == Int {
        /// 请求状态码
        guard statusCodes.contains(statusCode) else {
            if let data = model {
                let errorSring = data.message
                throw MoyaError.underlying(RxSwiftMoyaError.StatusError(errorSring), nil)
            }
            throw RxSwiftMoyaError.OtherError
        }
        
        guard let _data = model else {
            throw RxSwiftMoyaError.OtherError
        }
        
        /// 业务处理码
        guard statusCodes.contains(_data.code) ||
            _data.code == RequestStatusCode.expired.rawValue else {
            throw MoyaError.underlying(RxSwiftMoyaError.StatusError(_data.message), nil)
        }

        return self
    }
}

public extension ObservableType where Element == Response {

    /// Filters out responses where `statusCode` falls within the range 200 - 299.
    func filterCodes() -> Observable<Element> {
        
        return flatMap { Observable.just(try $0._filter(statusCodes: 200...299)) }
    }
}

public extension Observable {
    
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { response in
            //if response is a dictionary, then use ObjectMapper to map the dictionary
            //if not throw an error
            guard let response = response as? Moya.Response else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            
            guard let dict = response.model?.data as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            
            guard let value = Mapper<T>().map(JSON: dict) else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            
            return value
        }
    }
    
    func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map { response in
            //if response is an array of dictionaries, then use ObjectMapper to map the dictionary
            //if not, throw an error
            guard let response = response as? Moya.Response else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            
            guard let array = response.model?.data as? [Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            
            guard let dicts = array as? [[String: Any]] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            
            return Mapper<T>().mapArray(JSONArray: dicts)
        }
    }
}

enum RxSwiftMoyaError {
    case ParseJSONError
    case StatusError(_ error: String)
    case OtherError
}

extension RxSwiftMoyaError: Swift.Error {
}

extension RxSwiftMoyaError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .ParseJSONError:
            return "数据解析失败"
        case .StatusError(let error):
            return error
        case .OtherError:
            return "请求异常"
        }
    }
}



class AesCryptor {
    static let aesKey = "123456";
    static let aesIv = "654321";
    
    /// AES加密
    public static func encrypt(_ string: String) -> String {
        // do-catch进行异常抛出
        do {
            print("[AesCryptor] 加密前： \(string)")
            // 出初始化AES
            let aes = try AES(key: aesKey.bytes,
                              blockMode: CBC(iv: aesIv.bytes))
            // 进行AES加密
            let encryptBytes = try aes.encrypt(string.bytes)
            print("[AesCryptor] 加密后： \(encryptBytes.toBase64())")
            return encryptBytes.toBase64()
        } catch {
            // 异常处理
            return ""
        }
    }
    
    /// AES解密
    public static func decrypt(_ string: String) -> String  {
        // do-catch进行异常抛出
        do {
            print("[AesCryptor] 解密前： \(string)")

            // 出初始化AES
            let aes = try AES(key: aesKey.bytes,
                              blockMode: CBC(iv: aesIv.bytes))
            // 进行AES解密
            let decryptBytes = try aes.decrypt(Array(base64: string))
            print("[AesCryptor] 解密后：\(String(data: Data(decryptBytes), encoding: .utf8)!)")
            return String(data: Data(decryptBytes), encoding: .utf8)!
        } catch {
            // 异常处理
            return ""
        }
    }
}
