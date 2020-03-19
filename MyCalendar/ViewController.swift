//
//  ViewController.swift
//  MyCalendar
//
//  Created by 桑原望 on 2020/03/03.
//  Copyright © 2020 MySwift. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    var notificationToken: NotificationToken? = nil
    let tmpDate = Calendar(identifier: .gregorian)
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var monthTotalText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
        //今日の印(赤丸)を消す
       // calendar.today = nil
        
        let realm = try! Realm()
        // Do any additional setup after loading the view.
        notificationToken = realm.observe { Notification, realm in
           
            self.calendar.reloadData()
        }
    }
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        var myRecord = ""
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        let da = "\(year)/\(m)/\(d)"
        //年月日が一致したらサブタイトルに走った距離を表示
        let realm = try! Realm()
        var result = realm.objects(RunRecord.self)
        result = result.filter("date = '\(da)'")
//        for record in result {
//            if record.date == da {
//                return record.distance + "km"
//            }
//        }
        if let record = result.last {
            myRecord = record.distance
            return myRecord + "km"
        }
        return "○"
    }
    override func viewDidAppear(_ animated: Bool) {
        //走った距離の合計を算出する
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let m = String(format: "%02d", month)
        let my = "\(year)/\(m)"
        let realm = try! Realm()
        
        let monthTotal: Int = realm.objects(RunRecord.self).filter("date BEGINSWITH '\(my)'").sum(ofProperty: "distance")
        monthTotalText.text = String(monthTotal)
        //let monthTotal: Int = realm.objects(RunRecord.self).sum(ofProperty: "distance")
     //  monthTotalText.text = monthTotal.last?.distance
      //  monthTotalText.text = String(monthTotal.last!.distance) + "km"
        }
}
class RunRecord: Object {
    @objc dynamic var date: String = ""
    @objc dynamic var yearAndMonth = ""
    @objc dynamic var distance: String = ""
}
