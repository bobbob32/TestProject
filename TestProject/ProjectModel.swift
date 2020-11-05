//
//  ProjectModel.swift
//  TestProject
//
//  Created by BOB on 2020/11/4.
//

import UIKit
class ProjectModel: NSObject {
    static  var instance:ProjectModel = ProjectModel()
    private override init() {
        super.init()
    }
    private lazy var timer:Timer = {
        let timer = Timer(timeInterval: 5, repeats: true) { [weak self](timer) in
            guard self != nil else{
                return
            }
            DispatchQueue.global().async {
                PNetRequest.instance.request(urlstr: Common.githubUrlStr) { (isSuccess, retData) in
                    if(isSuccess){
                      let retDic = retData as? Dictionary<String,Any>
                        guard retDic != nil else {
                            return
                        }
                        LocalDataModel.instance.insertToTable(responseDa: retDic!.toJsonString()!)
                    }else{
                        LocalDataModel.instance.insertToTable(responseDa:"Error")
                    }
                    
                    self!.notificationUpdate(userInfo: ["state":isSuccess,"retData":retData as Any])
                }
            }
        }
        RunLoop.current.add(timer, forMode: .default)
        return timer
    }()
    
    private func notificationUpdate(userInfo:Dictionary<AnyHashable,Any>?){
        let notification =  Notification(name: Notification.Name(rawValue: Common.UpdatUiNotification), object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
    }
    public func startTimerForRequest()  {
        self.timer.fire()
    }
    public func stopTimer()  {
        self.timer.invalidate()
    }
}


extension Dictionary {
    
    func toJsonString() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self,
                                                     options: []) else {
            return nil
        }
        guard let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return str
     }
    
}
