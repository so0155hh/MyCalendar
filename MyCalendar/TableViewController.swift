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
    
    private func getCellData(indexPath: IndexPath) -> (text: String, detail: String) {
           
        let year = indexPath.section + 2020
        let month = (indexPath.row > 8) ? "\(indexPath.row + 1)" : "0" + "\(indexPath.row + 1)"
        let yearMonth = "\(year)/\(month)"
        
        dateFormatter.dateFormat = "yyyy/MM"
        if let date = dateFormatter.date(from: yearMonth) {
            let totalPitches: Int = realm.objects(RunRecord.self)
                .filter("date BEGINSWITH '\(dateFormatter.string(from: date))'")
                .sum(ofProperty: "pitches")
           
            return(items[indexPath.row], String(totalPitches))
        }
        return(items[indexPath.row], "エラー")
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
        cell.detailTextLabel?.text = detail
       
        if settedMaxPitches.text == nil {
            cell.backgroundColor = .clear
             //実際の投球数が月間投球数の上限を超えた場合、その月の背景を赤にする
        } else if let myPitch = Int(cell.detailTextLabel!.text!),
        let maxPitchesCount = Int(settedMaxPitches.text!) {
            if myPitch >= maxPitchesCount {
                cell.backgroundColor = .red
            }
        }
        return cell
    }
    }

