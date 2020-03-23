//
//  TableViewController.swift
//  MyCalendar
//
//  Created by 桑原望 on 2020/03/22.
//  Copyright © 2020 MySwift. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    let date = Date()
  //  let tmpDate = Calendar(identifier: .gregorian)
    
        let sections = ["2020年", "2021年", "2022年"]
    //let sections =
    let items = //[
    ["1月", "2月", "3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
//        ,
//        ["Red","Black"],
//        ["Circle", "Oval"]
//    ]
    
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return self.sections.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return items [section].count
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       cell.textLabel?.text = items[indexPath.row]//[indexPath.row]
//        let tmpDate = Calendar(identifier: .gregorian)
//        let year = tmpDate.component(.year, from: date)
//        cell.textLabel?.text = String(year)
        cell.detailTextLabel?.text = "33"
        
        return cell
    }

        override func viewDidLoad() {
        super.viewDidLoad()
            myTableView.delegate = self
            myTableView.dataSource = self
            
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
