//
//  UIBaseVc.swift
//  TestProject
//
//  Created by BOB on 2020/11/4.
//

import UIKit

class UIBaseVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addRightNavigationBtn(itemTitle:String,selector:Selector?){
        let rightItem = UIBarButtonItem(title: itemTitle, style: .plain, target: self, action: selector)
        UINavigationBar.appearance().isTranslucent = false
        self.navigationItem.rightBarButtonItems = [rightItem]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
