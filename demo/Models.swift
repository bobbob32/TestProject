//
//  Models.swift
//  TestProject
//
//  Created by BOB on 2020/11/12.
//

import Foundation
import RxSwift
struct TestModel {
    let data = Observable.just([Music(name: "", signa: ""),
                                Music(name: "", signa: ""),
                                Music(name: "", signa: ""),
                                Music(name: "", signa: ""),
                                Music(name: "", signa: "")
    ])
    
}

class Music: NSObject {
    var name:String?
    var signar:String?
    override init() {
        super.init()
    }
    convenience init(name:String,signa:String){
        self.init()
        self.name = name
        self.signar = signa
    }
}
