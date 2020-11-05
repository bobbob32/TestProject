//
//  LocalDataModel.swift
//  TestProject
//
//  Created by BOB on 2020/11/4.
//

import UIKit
import SQLite
class LocalDataModel: NSObject {
    static var instance:LocalDataModel = LocalDataModel()
    private override init() {
        super.init()
    }
    let datas = Table("data")
    let id = Expression<Int64>("id")
    let time = Expression<String?>("time")
    let responseData = Expression<String>("responseData")
    var db:Connection?
    
    private func getPath()->String{
        let path = NSSearchPathForDirectoriesInDomains(
            .cachesDirectory, .userDomainMask, true
            ).first!
        let patn = path + "/mydb.sqlite"
        return patn
    }
    
    func getDbConnection()->Bool{
            do{
                let path = getPath()
                self.createNewPath(newPath: path)
                self.db = try Connection(path)
            }catch{
                return false
            }
        return true
    }
    fileprivate func createNewPath(newPath: String) {
        // 创建新的路径
        if !FileManager.default.fileExists(atPath: newPath) {
            
            do {
                try FileManager.default.createDirectory(atPath: newPath,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch  let error{
                print("createDirectory error: \(newPath)")
            }
        }
    }
    
    func createTable() {
        if self.getDbConnection() == false {
            return
        }
        do{
            try db?.run(datas.create { t in
                t.column(id, primaryKey: true)
                t.column(time)
                t.column(responseData, unique: true)
            })
        }catch{
            print("异常")
        }
    }
    func insertToTable(responseDa:String)  {
        if self.getDbConnection() == false {
            return
        }
        let currentTime = TimeManager.getCurrentTime()
        let insert = datas.insert(time <- currentTime, responseData <- responseDa)
        do{
            let rowid = try db?.run(insert)
        }catch{
            
        }
       
    }
        
        // INSERT INTO "datas" ("time", "responseData") VALUES ('Alice', 'alice@mac.com')

    func searchAllDatas()->Array<Any>{
       
        var array = Array<Any>()
        if self.getDbConnection() == false {
            return array
        }
        do{
            //读取所有数据
            for data in try db!.prepare(datas) {
                print("id: \(data[id]), time: \(data[time]), responseData: \(data[responseData])")
                // id: 1, time: Optional("Alice"), responseData: alice@mac.com
                array.append(data)
            }
        }catch{
            
        }
        return array
    }
    
        // SELECT * FROM "datas"
    func test() throws{
        
        let alice = datas.filter(id == rowid)

        try db!.run(alice.update(responseData <- responseData.replace("mac.com", with: "me.com")))
        // UPDATE "datas" SET "responseData" = replace("responseData", 'mac.com', 'me.com')
        // WHERE ("id" = 1)

        try db!.run(alice.delete())
        // DELETE FROM "datas" WHERE ("id" = 1)

        try db!.scalar(datas.count) // 0
        // SELECT count(*) FROM "datas"
    }
   
}
