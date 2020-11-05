//
//  TestHistoryVc.swift
//  TestProject
//
//  Created by BOB on 2020/11/4.
//

import UIKit

class TestHistoryVc: UIBaseVc {
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
        self.initDatas()
        self.tabview.delegate = self
        self.tabview.dataSource = self
        self.tabview.tableFooterView = UIView()
        self.tabview.register(UITableViewCell.self, forCellReuseIdentifier: indentifier)
        // Do any additional setup after loading the view.
    }
    
    func initDatas()  {
        let datas = LocalDataModel.instance.searchAllDatas()
        if datas.count != 0 {
            let retData = datas.sorted { (data1, data2) -> Bool in
                return data1["time"] as! String > data2["time"] as! String
            }
          
            self.dataList.removeAll()
            for dataItem in retData {
                let time = dataItem["time"]
                if time == nil {
                    continue
                }
                self.dataList.append(time! ?? "null")
            }
            
        }
    }
}

extension TestHistoryVc:UITableViewDelegate,UITableViewDataSource{
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
