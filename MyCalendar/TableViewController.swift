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
    @IBOutlet weak var myPitchesRecord: UILabel!
    
    let date = Date()
    let dateFormatter = DateFormatter()
    let userDefaults = UserDefaults.standard
    
        let sections = ["2020年", "2021年", "2022年"]

    let items = ["1月", "2月", "3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
   override func viewDidLoad() {
       super.viewDidLoad()
           myTableView.delegate = self
           myTableView.dataSource = self
           let maxPitches = userDefaults.string(forKey: "myMax")
           myPitchesRecord.text = maxPitches
   
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
       cell.textLabel?.text = items[indexPath.row]
        //各月の合計投球数を算出する
        let marchString = "2020/03"
        let aprilString = "2020/04"
        let mayString = "2020/05"
        dateFormatter.dateFormat = "yyyy/MM"
        let marchDate: Date = dateFormatter.date(from: marchString)!
        let aprilDate: Date = dateFormatter.date(from: aprilString)!
       let mayDate:Date = dateFormatter.date(from: mayString)!
       
     //   let maxPitchesCount = Int(myPitchesRecord.text!)
        let realm = try! Realm()
        //フィルターをかけて合計投球数を求める
        let marchTotal: Int = realm.objects(RunRecord.self).filter("date BEGINSWITH '\(dateFormatter.string(from: marchDate))'").sum(ofProperty: "distance")
        let aprilTotal: Int = realm.objects(RunRecord.self).filter("date BEGINSWITH '\(dateFormatter.string(from: aprilDate))'").sum(ofProperty: "distance")
        let mayTotal: Int = realm.objects(RunRecord.self).filter("date BEGINSWITH '\(dateFormatter.string(from: mayDate))'").sum(ofProperty: "distance")
        
        //2020年の記録を表示
        if indexPath.section == 0 {
        switch indexPath.row {
        case 0:
            cell.detailTextLabel?.text = "0"
        case 1:
            cell.detailTextLabel?.text = "0"
        case 2:
             cell.detailTextLabel?.text = String(marchTotal)
             //実際の投球数が月間投球数の上限を超えた場合、その月の背景を赤にする
             if marchTotal >= Int(myPitchesRecord.text!)! {
                cell.backgroundColor = .red
            }
        case 3:
            cell.detailTextLabel?.text = String(aprilTotal)
        case 4:
            cell.detailTextLabel?.text = String(mayTotal)

        default:
            cell.detailTextLabel?.text = ""
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = ""
            default:
                cell.detailTextLabel?.text = ""
            }
        }
        
       //実際の投球数が月間投球数の上限を超えた場合、その月の背景を赤にする
//        if let myPitch = Int(cell.detailTextLabel!.text!),
//           let maxPitchesCount = Int(myPitchesRecord.text!) {
//                if myPitch >= maxPitchesCount {
//                    cell.backgroundColor = .red
//            }
//        }
        return cell
    }
    }
