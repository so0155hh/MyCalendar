//
//  AddViewController.swift
//  MyCalendar
//
//  Created by 桑原望 on 2020/03/04.
//  Copyright © 2020 MySwift. All rights reserved.
//

import UIKit
import RealmSwift

let realm = try! Realm()
let date = Date()

class AddViewController: UIViewController {
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var runRecordText: UITextField!
    let formatter2 = DateFormatter()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        todayLabel.text = formatter.string(from: date)
    
       // print(formatter2.string(from: date))
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
//    let myRecord = RunRecord()
//           formatter2.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM", options: 0, locale: Locale(identifier: "en_US_POSIX"))
//         myRecord.yearAndMonth = formatter2.string(from: date)
//        let monthRecord = realm.objects(RunRecord.self).filter("yearAndMonth == formatter2.string(from: date)")
       // monthRecord.sum(ofProperty: "distance")
        try! realm.write {
            
            let Records = [RunRecord(value: ["date": todayLabel.text, "distance": runRecordText.text])]
            realm.add(Records)
        }
         self.dismiss(animated: true, completion: nil)
        print("データ書き込み中")
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }

}
