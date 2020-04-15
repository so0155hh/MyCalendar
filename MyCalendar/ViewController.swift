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
         calendar.today = nil
        let maxPitches = userDefaults.string(forKey: "myMax")
        monthTotalText.text = maxPitches
        
        let realm = try! Realm()
        notificationToken = realm.observe { Notification, realm in
            self.calendar.reloadData()
        }
    }
    func judgeHoliday (_ date: Date) -> Bool {
        
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        let holiday = CalculateCalendarLogic()
     return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    //曜日判定
     func getWeekIdx(_ date: Date) -> Int{
         return tmpDate.component(.weekday, from: date)
    }
    // 土日や祝日の日の文字色を変える
       func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
           //祝日判定をする
           if self.judgeHoliday(date){
               return UIColor.red
           }
        let weekday = self.getWeekIdx(date)
        
               if weekday == 1 {
                   return UIColor.red
               }
               else if weekday == 7 {
                   return UIColor.blue
               }
               return nil
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
        var result = realm.objects(PitchesRecord.self)
        result = result.filter("date = '\(da)'")
        
        if let record = result.last {
            myRecord = String(record.pitches)
            return myRecord + "球"
        }
        return "○"
    }
    @IBAction func backToCalendar(segue: UIStoryboardSegue) {
        let maxPitches = userDefaults.string(forKey: "myMax")
        monthTotalText.text = maxPitches
    }
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        if monthPosition == .previous || monthPosition == .next {
//            calendar.setCurrentPage(date, animated: true)
//        }
  //  }
}
class PitchesRecord: Object {
    @objc dynamic var date: String = ""
    @objc dynamic var pitches: Int = 0
    
    override static func primaryKey() -> String? {
          return "date"
      }
}
