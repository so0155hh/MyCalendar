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
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var monthTotalText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
        //今日の印(赤丸)を消す
        // calendar.today = nil
        let maxPitches = userDefaults.string(forKey: "myMax")
        monthTotalText.text = maxPitches
        
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
        
        if let record = result.last {
            myRecord = String(record.distance)
            return myRecord + "球"
        }
        return "○"
    }
    @IBAction func backToCalendar(segue: UIStoryboardSegue) {
        let maxPitches = userDefaults.string(forKey: "myMax")
        monthTotalText.text = maxPitches
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
}
class RunRecord: Object {
    @objc dynamic var date: String = ""
    @objc dynamic var yearAndMonth = ""
    @objc dynamic var distance: Int = 0
}
