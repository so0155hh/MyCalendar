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
    let nowDate = Calendar(identifier: .gregorian)
    let userDefaults = UserDefaults.standard
    var continuousRecord: Int = 0
    var pitchedRecord = ""
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var monthTotalText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
        //今日の印(赤丸)を消す処理
        //calendar.today = nil
       
        if let maxPitches = userDefaults.string(forKey: "myMax") {
            if maxPitches == " " {
                monthTotalText.text = ""
                
            } else if monthTotalText.text != "" {
                monthTotalText.text = maxPitches
            } else {
                monthTotalText.text = "未設定"
            }
        }
        let realm = try! Realm()
       // データの更新を通知
        notificationToken = realm.observe { Notification, realm in
            self.calendar.reloadData()
        }
    }
    //祝日の設定
    func judgeHoliday (_ date: Date) -> Bool {
        //現在の年月日を取得
        let year = nowDate.component(.year, from: date)
        let month = nowDate.component(.month, from: date)
        let day = nowDate.component(.day, from: date)
        let holiday = CalculateCalendarLogic()
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    //曜日判定
    func getWeekIdx(_ date: Date) -> Int{
        return nowDate.component(.weekday, from: date)
    }
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする
        if self.judgeHoliday(date){
            return UIColor.systemRed
        }
        let weekday = self.getWeekIdx(date)
        //日曜は赤色
        if weekday == 1 {
            return UIColor.systemRed
        }
            //土曜は青色
        else if weekday == 7 {
            return UIColor.systemBlue
        }
        return nil
    }
    //カレンダーのサブタイトルにと投球数を表示させる
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        var myRecord = ""
       //現在の年月日を取得
        let year = nowDate.component(.year, from: date)
        let month = nowDate.component(.month, from: date)
        let day = nowDate.component(.day, from: date)
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        let da = "\(year)/\(m)/\(d)"
        //年月日が一致したらサブタイトルに投球数を表示
        let realm = try! Realm()
        var result = realm.objects(PitchesRecord.self)
        result = result.filter("date = '\(da)'")
        
        if let record = result.last {
            myRecord = String(record.pitches)
            return myRecord + "球"
        }
        return "○"
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        //投球を記録した日付のタイトルをあ黄色にする
        let nowDate = Calendar(identifier: .gregorian)
        let year = nowDate.component(.year, from: date)
        let month = nowDate.component(.month, from: date)
        let day = nowDate.component(.day, from: date)
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        let da = "\(year)/\(m)/\(d)"
        
        //年月日が一致したらサブタイトルに投球数を表示
        let realm = try! Realm()
        var result = realm.objects(PitchesRecord.self)
        
        result = result.filter("date = '\(da)'")
        
        if let record = result.last {
            continuousRecord = record.pitches
            //投球を記録した日付を取り出す
            pitchedRecord = record.date
            
            if continuousRecord > 0 {
                
                return UIColor.systemYellow
            }
        }
        return nil
    }
    @IBAction func backToCalendar(segue: UIStoryboardSegue) {
        let maxPitches = userDefaults.string(forKey: "myMax")
        monthTotalText.text = maxPitches
    }
}
class PitchesRecord: Object {
    @objc dynamic var date: String = ""
    @objc dynamic var pitches: Int = 0
    
    override static func primaryKey() -> String? {
        return "date"
    }
}
