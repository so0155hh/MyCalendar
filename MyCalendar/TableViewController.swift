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
   
    let dateFormatter = DateFormatter()
    let userDefaults = UserDefaults.standard
    let realm = try! Realm()
    let sections = ["2020年", "2021年", "2022年"]
    let items = ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
    let nowDate = Calendar(identifier: .gregorian)
    
    private func getCellData(indexPath: IndexPath) -> (text: String, detail: String) {
        let year = nowDate.component(.year, from: Date())
        let month = (indexPath.row > 10) ? "\(indexPath.row - 1)" : "0" + "\(indexPath.row - 1)"
       
        let yearMonth = "\(year)/\(month)"
        
        if let date = dateFormatter.date(from: yearMonth) {
       
        let total: Int = realm.objects(RunRecord.self).filter("date BEGINSWITH '\(dateFormatter.string(from: date))'").sum(ofProperty: "pitches")
     
        return(items[indexPath.row], String(total))
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
   
        //背景色はclearに設定する
     //   cell.backgroundColor = .clear
        let (text, detail) = getCellData(indexPath: indexPath)
        cell.textLabel?.text = text
        cell.detailTextLabel?.text = detail
        return cell
//        if myPitchesRecord.text == nil {
//            let alertController = UIAlertController(title: "エラー", message: "投球数の上限を設定してください", preferredStyle: .alert)
//            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController.addAction(defaultAction)
//            present(alertController, animated: true, completion: nil)
//        }
        
      
      //  cell.textLabel?.text = items[indexPath.row]
        //各月の合計投球数を算出する
//        let marchString = "2020/03"
//        let aprilString = "2020/04"
//        let mayString = "2020/05"
//        dateFormatter.dateFormat = "yyyy/MM"
//        let marchDate: Date = dateFormatter.date(from: marchString)!
//        let aprilDate: Date = dateFormatter.date(from: aprilString)!
//        let mayDate:Date = dateFormatter.date(from: mayString)!
//
//        //   let maxPitchesCount = Int(myPitchesRecord.text!)
//        let realm = try! Realm()
//        //フィルターをかけて合計投球数を求める
//        let marchTotal: Int = realm.objects(RunRecord.self).filter("date BEGINSWITH '\(dateFormatter.string(from: marchDate))'").sum(ofProperty: "pitches")
//        let aprilTotal: Int = realm.objects(RunRecord.self).filter("date BEGINSWITH '\(dateFormatter.string(from: aprilDate))'").sum(ofProperty: "pitches")
//        let mayTotal: Int = realm.objects(RunRecord.self).filter("date BEGINSWITH '\(dateFormatter.string(from: mayDate))'").sum(ofProperty: "pitches")
//
//        //2020年の記録を表示
//        if indexPath.section == 0 {
//            switch indexPath.row {
//            case 0: //1月
//                cell.detailTextLabel?.text = "0"
//            case 1: //2月
//                cell.detailTextLabel?.text = "0"
//            case 2: //3月
//                cell.detailTextLabel?.text = String(marchTotal)
//            case 3:
//                cell.detailTextLabel?.text = String(aprilTotal)
//            case 4:
//                cell.detailTextLabel?.text = String(mayTotal)
//
//            default:
//                cell.detailTextLabel?.text = ""
//            }
//        } else if indexPath.section == 1 {
//            switch indexPath.row {
//            case 0: //2021年1月
//                cell.detailTextLabel?.text = ""
//            default:
//                cell.detailTextLabel?.text = ""
//            }
//        }
//      //投球数の上限設定をしていない場合、エラー表示される
//        if myPitchesRecord.text == nil {
//            let alertController = UIAlertController(title: "エラー", message: "投球数の上限を設定してください", preferredStyle: .alert)
//            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController.addAction(defaultAction)
//            present(alertController, animated: true, completion: nil)
//        }
//        //実際の投球数が月間投球数の上限を超えた場合、その月の背景を赤にする
//        else if let myPitch = Int(cell.detailTextLabel!.text!),
//            let maxPitchesCount = Int(myPitchesRecord.text!) {
//            if myPitch >= maxPitchesCount {
//                cell.backgroundColor = .red
//            }
//        }
//        return cell
//    }
}
}
