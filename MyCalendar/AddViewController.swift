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
  
    @IBOutlet weak var pitchesRecordText: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var dateText: UITextField!
    
    var datePicker: UIDatePicker = UIDatePicker()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ja_JP")
        dateText.inputView = datePicker
        pitchesRecordText.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([spacelItem, doneItem], animated: true)
        
        dateText.inputView = datePicker
        dateText.inputAccessoryView = toolBar
        //保存した投球数の表示
        let myPitches = userDefaults.string(forKey: "myPitches")
        pitchesRecordText.text = myPitches
        
        //入力をnumberPadにする
        let pitchesToolBar = UIToolbar(frame: CGRect(x:0, y:0, width: 320, height: 40))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        pitchesToolBar.items = [space, doneButton]
        pitchesRecordText.inputAccessoryView = pitchesToolBar
        self.pitchesRecordText.keyboardType = UIKeyboardType.numberPad
    }
    @objc func doneButtonTapped (sender: UIButton) {
        self.view.endEditing(true)
    }
    @objc func done() {
        dateText.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        dateText.text = formatter.string(from: datePicker.date)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        if let intPitches = Int(pitchesRecordText.text!) {
        try! realm.write {
            let Records = [PitchesRecord(value: ["date": dateText.text!, "pitches": intPitches])]
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
