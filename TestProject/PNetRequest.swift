//
//  PNetRequest.swift
//  TestProject
//
//  Created by BOB on 2020/11/4.
//

import UIKit
import Alamofire
class PNetRequest: NSObject {
    typealias ResponseCallback = ((Bool,Any?)->())
    static var instance:PNetRequest = PNetRequest()
    private override init() {
        super.init()
    }
    //不做任何验证，直接信任服务器
      static private func trustServer(challenge: URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?) {
          let disposition = URLSession.AuthChallengeDisposition.useCredential
          let credential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
        
          return (disposition, credential)
          
      }
    
    public func request(urlstr:String,callback:@escaping ResponseCallback){
        let newUrlStr:String = urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: newUrlStr)
       
        guard url != nil else {
            callback(false,nil)
            return
        }
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let configuration:URLSessionConfiguration = URLSessionConfiguration.default
        let session:URLSession = URLSession(configuration: configuration)
        let task:URLSessionDataTask = session.dataTask(with: request) { (data, response, error)->Void in
            if error == nil{
                do{
                    let responseData:NSDictionary = try JSONSerialization.jsonObject(with: data!, options:   JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    //                           print("responseData:\(responseData)")
                    callback(true,responseData)
                }catch{
                    //                           print("catch")
                    callback(false,"解析失败")
                }
            }else{
                //                       print("error:\(error)")
                callback(false,error?.localizedDescription)
            }
        }
        task.resume()
    }
    
    
}
