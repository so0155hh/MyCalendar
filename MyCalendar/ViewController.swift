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
    
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
        let realm = try! Realm()
        // Do any additional setup after loading the view.
        notificationToken = realm.observe { Notification, realm in
            self.calendar.reloadData()
        }
    }
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        let da = "\(year)/\(m)/\(d)"
        
        let realm = try! Realm()
        var result = realm.objects(RunRecord.self)
        result = result.filter("date = '\(da)'")
        for record in result {
            if record.date == da {
                return record.distance + "km"
            }
        }
        return "○"
    }
    
}
class RunRecord: Object {
    @objc dynamic var date: String = ""
    @objc dynamic var distance: String = ""
}
