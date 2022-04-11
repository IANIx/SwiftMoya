//
//  ViewController.swift
//  SwiftMoya
//
//  Created by macxjn on 2022/4/11.
//

import UIKit
import RxSwift
import SwiftyJSON

class ViewController: UIViewController {

    private let dispose = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    private func loadData() {
        
        /// 只考虑正常拿到数据的情况
        ModuleAProvider.fetechA().subscribe { event in
            if let model = event.element {
                // do something
            }
        }.disposed(by: dispose)
        
        /// 正常数据以及异常数据情况分开处理
        ModuleAProvider.fetechB().subscribe { element in
            // do something
        } onError: { error in
            // error toast
            print(error.localizedDescription)
        }.disposed(by: dispose)
        
        /// 不做模型解析，单独从response中读取某个字段，借助SwiftJson
        ModuleAProvider.fetechC().subscribe { event in
            if let data = event.element?.model?.data,
               let url = JSON(data)["url"].string {
                // do something
            }
        }.disposed(by: dispose)
    }
}

