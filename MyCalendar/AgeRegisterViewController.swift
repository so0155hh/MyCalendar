//
//  AgeRegisterViewController.swift
//  MyCalendar
//
//  Created by 桑原望 on 2020/03/27.
//  Copyright © 2020 MySwift. All rights reserved.
//

import UIKit

class AgeRegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var maxPitches: UILabel!
    @IBOutlet weak var ageField: UITextField!
    
    let userDefaults = UserDefaults.standard
    //プロパティ監視
    var age: Int = 0 {
        didSet {
            if age < 6 { //6歳未満の場合
                firstLabel.isHidden = true
                secondLabel.isHidden = true
                alertLabel.isHidden = false
                maxPitches.isHidden = true
                maxPitches.text = ""
                alertLabel.text = "まずは野球を楽しみましょう!"
                self.doneButton.isEnabled  = true
                
            } else if age >= 6, age < 13 {//小学生の場合
                firstLabel.isHidden = false
                secondLabel.isHidden = false
                maxPitches.text = String(800)
                maxPitches.isHidden = false
                alertLabel.text = "月に800球以上投げないようにしましょう。"
                self.doneButton.isEnabled  = true
                
            } else if age >= 13, age < 16 {//中学生の場合
                firstLabel.isHidden = false
                secondLabel.isHidden = false
                maxPitches.text = String(1400)
                maxPitches.isHidden = false
                alertLabel.text = "月に1400球以上投げないようにしましょう。"
                self.doneButton.isEnabled  = true
            } else {//高校生〜大人の場合
                firstLabel.isHidden = false
                secondLabel.isHidden = false
                maxPitches.text = String(2000)
                maxPitches.isHidden = false
                alertLabel.text = "月に2000球以上投げないようにしましょう。"
                self.doneButton.isEnabled  = true
            }
        }
    }
    
    @IBAction func cancelReturn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ageField.delegate = self
        
        firstLabel.isHidden = true
        
        secondLabel.isHidden = true
        //前回登録した年齢データの取り出し
        let myAge = userDefaults.integer(forKey: "myAge")
        ageField.text = String(myAge)
        
        self.doneButton.isEnabled  = false
        //最初からアドバイスを表示しておくためにageに代入
        age = myAge
        //   NumberPadに"Done"ボタンを表示
        let toolBar = UIToolbar(frame: CGRect(x:0, y:0, width: 320, height: 40))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolBar.items = [space, doneButton]
        ageField.inputAccessoryView = toolBar
        self.ageField.keyboardType = UIKeyboardType.numberPad
        
        //文字が入力される度にメソッドを呼び出すための処理
        ageField.addTarget(
            self,
            action: #selector(AgeRegisterViewController.textFieldDidChange(textField:)),
            for: UIControl.Event.editingChanged)
    }
    @objc func doneButtonTapped(sender: UIButton) {
        self.view.endEditing(true)
    }
    //textFieldタップ時に全選択にする
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    //編集完了時に呼び出される
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // 上限投球数を保存
        //        userDefaults.set(Int(maxPitches.text!), forKey: "myMax")
        //
        //        //年齢はIntで保存。Intでないときは0を表示
        //        let ageInt = Int(ageField.text!) ?? 0
        //       userDefaults.set(ageInt, forKey: "myAge")
        //        userDefaults.synchronize()
    }
    //文字を入力する度に呼び出される
    @objc func textFieldDidChange(textField: UITextField) {
        //年齢に応じて投球数の上限を表示
        if let ageInt = Int(ageField.text!) {
            self.age = ageInt
        }
        // 上限投球数を保存
        userDefaults.set(Int(maxPitches.text!), forKey: "myMax")
        
        //年齢はIntで保存。Intでないときは0を表示
        let ageInt = Int(ageField.text!) ?? 0
        userDefaults.set(ageInt, forKey: "myAge")
        userDefaults.synchronize()
    }
}
