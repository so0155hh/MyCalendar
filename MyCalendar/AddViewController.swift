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
    @IBOutlet weak var pitchesRecordText: UITextField!
    
    let formatter2 = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //本日の日付を表示
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        todayLabel.text = formatter.string(from: date)
        //入力をnumberPadにする
        let toolBar = UIToolbar(frame: CGRect(x:0, y:0, width: 320, height: 40))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolBar.items = [space, doneButton]
        pitchesRecordText.inputAccessoryView = toolBar
        self.pitchesRecordText.keyboardType = UIKeyboardType.numberPad
    }
    @objc func doneButtonTapped (sender: UIButton) {
        self.view.endEditing(true)
    }
    @IBAction func saveBtn(_ sender: Any) {
        let intDistance = Int(pitchesRecordText.text!)
        
        try! realm.write {
            let Records = [RunRecord(value: ["date": todayLabel.text!, "distance": intDistance!])]
            realm.add(Records, update: .all)
        }
        self.dismiss(animated: true, completion: nil)
        print("データ書き込み中")
    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
