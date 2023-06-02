# SwiftMoya

基于Moya + RxSwift + ObjectMapper 的Swift网络工具层，经过多个项目不断实践完善。支持`get`、 `post` 、`put` 、`delete` 以及加密请求，上传图片，可灵活适应业务。

### How To Use

- Provider

  建议把整个项目按照不同模块划分，每个模块中包含一个该模块中的`Provider`，用来管理模块中的所有网络请求。

  e.g. 

```swift
import Foundation
import RxSwift
import SwiftyJSON
import Moya

struct ModuleAProvider {
    
    /// 在没有错误的情况下返回ModelA类型对象
    static func fetchA() -> Observable<ModelA> {
        return requestProvider.rx.request(.get("xxx",
                                                parameter: ["xx": "123"]))
            .asObservable()
            .filterCodes()
            .mapObject(type: ModelA.self)
    }
    
    /// 在没有错误的情况下返回ModelB泛型数组
    static func fetchB() -> Observable<[ModelB]> {
        return requestProvider.rx.request(.post("xxx",
                                                parameter: ["xxx": 1234]))
            .asObservable()
            .filterCodes()
            .mapArray(type: ModelB.self)
    }
    
    
    /// 在没有错误的情况下返回原始Response数据
    static func fetchC() -> Observable<Response> {
        return requestProvider.rx.request(.post("",
                                                parameter: [:]))
            .asObservable()
            .filterSuccessfulStatusCodes()
    }
    
    /// 返回原始Response数据，不过滤数据
    static func fetchD() -> Observable<Response> {
        return requestProvider.rx.request(.post("",
                                                parameter: [:]))
            .asObservable()
    }
    
}

```

  当然，这里的dataModel都是必须继承Mappable

- ViewModel

  在ViewModel中获取数据

  e.g. 

```swift
private let dispose = DisposeBag()

private func loadData() {
        
        /// 只考虑正常拿到数据的情况
        ModuleAProvider.fetchA().subscribe { event in
            if let model = event.element {
                // do something
            }
        }.disposed(by: dispose)
        
        /// 正常数据以及异常数据情况分开处理
        ModuleAProvider.fetchB().subscribe { element in
            // do something
        } onError: { error in
            // error toast
            print(error.localizedDescription)
        }.disposed(by: dispose)
        
        /// 不做模型解析，单独从response中读取某个字段，借助SwiftJson
        ModuleAProvider.fetchC().subscribe { event in
            if let data = event.element?.model?.data,
               let url = JSON(data)["url"].string {
                // do something
            }
        }.disposed(by: dispose)
    }
```

