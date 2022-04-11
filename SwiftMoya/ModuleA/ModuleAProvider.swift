//
//  ModuleAProvider.swift
//  SwiftMoya
//
//  Created by macxjn on 2022/4/11.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

struct ModuleAProvider {
    
    /// 在没有错误的情况下返回ModelA类型对象
    static func fetechA() -> Observable<ModelA> {
        return requestProvider.rx.request(.get("xxx",
                                                parameter: ["xx": "123"]))
            .asObservable()
            .filterCodes()
            .mapObject(type: ModelA.self)
    }
    
    /// 在没有错误的情况下返回ModelB泛型数组
    static func fetechB() -> Observable<[ModelB]> {
        return requestProvider.rx.request(.post("xxx",
                                                parameter: ["xxx": 1234]))
            .asObservable()
            .filterCodes()
            .mapArray(type: ModelB.self)
    }
    
    
    /// 在没有错误的情况下返回原始Response数据
    static func fetechC() -> Observable<Response> {
        return requestProvider.rx.request(.post("",
                                                parameter: [:]))
            .asObservable()
            .filterSuccessfulStatusCodes()
    }
    
    /// 返回原始Response数据，不过滤数据
    static func fetechD() -> Observable<Response> {
        return requestProvider.rx.request(.post("",
                                                parameter: [:]))
            .asObservable()
    }
    
}
