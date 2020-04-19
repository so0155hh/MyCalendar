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

class AddViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var pitchesRecordText: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        pitchesRecordText.delegate = self
        //本日の日付を表示
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
      todayLabel.text = formatter.string(from: date)
        
        //保存した投球数の表示
        let myPitches = userDefaults.string(forKey: "myPitches")
        pitchesRecordText.text = myPitches
        
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
        if let intPitches = Int(pitchesRecordText.text!) {
        try! realm.write {
            let Records = [PitchesRecord(value: ["date": todayLabel.text!, "pitches": intPitches])]
            realm.add(Records, update: .all)
        }
        self.dismiss(animated: true, completion: nil)
        print("データ書き込み中")
        }
        //投球数の保存
        userDefaults.set(pitchesRecordText.text!, forKey: "myPitches")
        userDefaults.synchronize()
    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //textFieldが空欄のとき、saveボタンを押せなくする
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { _ in self.saveBtn.isEnabled = self.pitchesRecordText.text != ""
        }
        return true
    }
    //textFieldタップ時に全選択にする
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
}
