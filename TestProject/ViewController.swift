//
//  ViewController.swift
//  TestProject
//
//  Created by BOB on 2020/11/4.
//

import UIKit
import SnapKit
class ViewController: UIBaseVc {
    private let indentifier = "ViewControllerCell"
    private var dataList:Array<String> = Array()
    private lazy var tabview:UITableView = {
        let tabview = UITableView()
        self.view.addSubview(tabview)
        tabview.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.view)
            make.bottom.left.equalTo(self.view)
        }
       
        return tabview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.addObserver()
        self.tabview.delegate = self
        self.tabview.dataSource = self
        self.tabview.tableFooterView = UIView()
        self.tabview.register(UITableViewCell.self, forCellReuseIdentifier: indentifier)
        self.addRightNavigationBtn(itemTitle: "HistoryData", selector: #selector(pushNewVc))
        initData()
    }
    func initData() {
        let datas = LocalDataModel.instance.searchAllDatas()
        if datas.count != 0 {
            let retData = datas.sorted { (data1, data2) -> Bool in
                return data1["time"] as! String > data2["time"] as! String
            }
          
            self.dataList.removeAll()
            let retdataStr = retData.last!["responseData"]
            let retDic = retdataStr!!.toDictionary() as? Dictionary<String, String>
            guard let mdic = retDic  else {
                return
            }
            self.dataList.append(contentsOf: mdic.values)
            //第一个是最早时间
            DispatchQueue.main.async {
                self.tabview.reloadData()
            }
        }
    }
    @objc
    private func pushNewVc(){
        self.navigationController?.pushViewController(TestHistoryVc(), animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        addObserver()
    }
    //
    private func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(receiveObserver(notifi:)), name: NSNotification.Name(Common.UpdatUiNotification), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    @objc
    func receiveObserver(notifi:Notification)  {
        let receiveDic = notifi.userInfo
        //["state":isSuccess,"retData":retData as Any])
        let state = receiveDic!["state"] as! Bool
        let retData = receiveDic!["retData"] as! Any
        if state {
            guard let dataDic = retData as? Dictionary<String,String> else {
                return
            }
            self.dataList.removeAll()
            for valu in dataDic.values {
                dataList.append(valu)
            }
            DispatchQueue.main.async {
                self.tabview.reloadData()
            }
        }
        print(retData)
    }

}
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tabview.dequeueReusableCell(withIdentifier: indentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: indentifier)
        }
        cell?.textLabel?.text = self.dataList[indexPath.row]
        return cell!
    }
    
    
}
extension String {
    
    func toDictionary() -> [String : Any] {
        
        var result = [String : Any]()
        guard !self.isEmpty else { return result }
        
        guard let dataSelf = self.data(using: .utf8) else {
            return result
        }
        
        if let dic = try? JSONSerialization.jsonObject(with: dataSelf,
                           options: .mutableContainers) as? [String : Any] {
            result = dic
        }
        return result
    
    }
    
}
