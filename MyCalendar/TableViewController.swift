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
    let dateFormatterMonth = DateFormatter()
    let userDefaults = UserDefaults.standard
    let realm = try! Realm()
    let firstYear = 2020
    //メンバ変数を定義するとき、他の変数を使って初期化はできない。
    var sections: [String] = []
    // var openedSections = Set<Int>()
    
    let nowDate = Calendar(identifier: .gregorian)
    let items = ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
    
    private func getCellData(indexPath: IndexPath) -> (text: String, detail: Int) {
        
        let year = indexPath.section + firstYear
        //表示方法について、1~9月と、10~12月に場合分けする
        let month = (indexPath.row > 8) ? "\(indexPath.row + 1)" : "0" + "\(indexPath.row + 1)"
        let yearMonth = "\(year)/\(month)"
        
        dateFormatter.dateFormat = "yyyy/MM"
        if let date = dateFormatter.date(from: yearMonth) {
            let totalPitches: Int = realm.objects(PitchesRecord.self)
                .filter("date BEGINSWITH '\(dateFormatter.string(from: date))'")
                .sum(ofProperty: "pitches")
            
            return(items[indexPath.row], totalPitches)
        }
        return(items[indexPath.row], 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        sections = ["\(firstYear)年","\(firstYear + 1)年", "\(firstYear + 2)年"]
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //上限投球数の表示を更新
        let maxPitches = userDefaults.string(forKey: "myMax")
        settedMaxPitches.text = maxPitches
        //年の取得
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy"
        let nowYear = Int(dateFormatter.string(from: Date()))
            //月の取得
        dateFormatterMonth.locale = Locale(identifier: "ja_JP")
        dateFormatterMonth.dateFormat = "MM"
        let nowMonth = Int(dateFormatterMonth.string(from: Date()))
       
        let nowSection = 0
        let nowRow = 0
        
        myTableView.reloadData()
        
        let indexPath = IndexPath(row: nowRow + nowMonth! - 1, section: nowSection + nowYear! - 2020)
        myTableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sections.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sections[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    //ヘッダを一覧表示(インデックスバーへ表示)
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        //インデックスバーをクリックしたとき、色が変わる
        //self.myTableView.sectionIndexTrackingBackgroundColor = .red
        return self.sections
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
        if detail >= maxPitches, settedAge >= 6 {
            cell.backgroundColor = .red
        }
        return cell
    }
}
//sectionをタップした時の処理
//sectionの開閉は、見づらいので却下
//    @objc func sectionHeaderDidTap(_ sender:UIGestureRecognizer) {
//        if let section = sender.view?.tag {
//
//            if openedSections.contains(section) {
//                //sectionを閉じる処理
//                openedSections.remove(section)
//            } else {
//                //sectionを開く処理
//                openedSections.insert(section)
//            }
//            //タップ時のアニメーションの実行
//            myTableView.reloadSections(IndexSet(integer: section), with: .fade)
//        }
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        //タップを認識する処理
//        let view = UITableViewHeaderFooterView()
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderDidTap(_:)))
//        view.addGestureRecognizer(gesture)
//        //タップしたsectionと開くsectionをイコールにする
//        view.tag = section
//        return view
//    }
