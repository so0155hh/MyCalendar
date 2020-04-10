//
//  TableViewController.swift
//  MyCalendar
//
//  Created by 桑原望 on 2020/03/22.
//  Copyright © 2020 MySwift. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var settedMaxPitches: UILabel!
    
    let dateFormatter = DateFormatter()
    let userDefaults = UserDefaults.standard
    let realm = try! Realm()
    let sections = ["2020年", "2021年", "2022年"]
    let items = ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
    let nowDate = Calendar(identifier: .gregorian)
    
    private func getCellData(indexPath: IndexPath) -> (text: String, detail: Int) {
        
        let year = indexPath.section + 2020
        let month = (indexPath.row > 8) ? "\(indexPath.row + 1)" : "0" + "\(indexPath.row + 1)"
        let yearMonth = "\(year)/\(month)"
        
        dateFormatter.dateFormat = "yyyy/MM"
        if let date = dateFormatter.date(from: yearMonth) {
            let totalPitches: Int = realm.objects(RunRecord.self)
                .filter("date BEGINSWITH '\(dateFormatter.string(from: date))'")
                .sum(ofProperty: "pitches")
            
            //  return(items[indexPath.row], String(totalPitches))
            return(items[indexPath.row], totalPitches)
        }
        return(items[indexPath.row], 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        //上限投球数の表示を更新
        let maxPitches = userDefaults.string(forKey: "myMax")
        settedMaxPitches.text = maxPitches
        //        let maxPitches = userDefaults.integer(forKey: "myMax")
        //        settedMaxPitches.text = String(maxPitches)
    }
    var openedSections = Set<Int>()
    //sectionをタップした時の処理
    @objc func sectionHeaderDidTap(_ sender:UIGestureRecognizer) {
        if let section = sender.view?.tag {
            if openedSections.contains(section) {
                //sectionを閉じる処理
                openedSections.remove(section)
            } else {
                //sectionを開く処理
                openedSections.insert(section)
            }
            //タップ時のアニメーションの実行
            myTableView.reloadSections(IndexSet(integer: section), with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //タップを認識する処理
        let view = UITableViewHeaderFooterView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderDidTap(_:)))
        view.addGestureRecognizer(gesture)
        //タップしたsectionと開くsectionをイコールにする
        view.tag = section
        return view
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sections.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openedSections.contains(section) {
            return items.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //背景色はclearに設定する
        cell.backgroundColor = .clear
        let (text, detail) = getCellData(indexPath: indexPath)
        cell.textLabel?.text = text
        cell.detailTextLabel?.text = String(detail)
        let maxPitches = userDefaults.integer(forKey: "myMax")
        let settedAge = userDefaults.integer(forKey: "myAge")
        //6歳未満は背景色の変更なし
        if settedAge < 6 {
            cell.backgroundColor = .clear
            //実際の投球数が設定した上限を超えたら、cellを赤色に変更
        } else if detail >= maxPitches {
            cell.backgroundColor = .red
        }
        //        if let intDetail = Int(detail),
        //            let intMaxPitches = Int(settedMaxPitches.text!) {
        //        if intDetail >= intMaxPitches {
        //            cell.backgroundColor = .red
        //        } else {
        //            cell.backgroundColor = .clear
        //            }
        //        } else {
        //            cell.backgroundColor = .clear
        //        }
        
        return cell
    }
}

