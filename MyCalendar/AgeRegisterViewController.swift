//
//  AgeRegisterViewController.swift
//  MyCalendar
//
//  Created by 桑原望 on 2020/03/27.
//  Copyright © 2020 MySwift. All rights reserved.
//

import UIKit

class AgeRegisterViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var maxPitches: UILabel!
   
    let userDefaults = UserDefaults.standard
    
    @IBAction func resultButton(_ sender: Any) {
        //年齢に応じて投球数の上限を表示
        if let ageInt = Int(ageLabel.text!) {
            if ageInt < 6 { //6歳未満の場合
                firstLabel.isHidden = true
                secondLabel.isHidden = true
                alertLabel.isHidden = false
                maxPitches.isHidden = true
                alertLabel.text = "まずは野球を楽しみましょう!"
                
            } else if ageInt >= 6, ageInt < 13 {//小学生の場合
                firstLabel.isHidden = false
                secondLabel.isHidden = false
                maxPitches.text = String(800)
                maxPitches.isHidden = false
                alertLabel.text = "月に800球以上投げないようにしましょう。"
                
            } else if ageInt >= 13, ageInt < 16 {//中学生の場合
                firstLabel.isHidden = false
                secondLabel.isHidden = false
                maxPitches.text = String(1400)
                maxPitches.isHidden = false
                alertLabel.text = "月に1400球以上投げないようにしましょう。"
                
            } else if ageInt >= 16 {//高校生〜大人の場合
                firstLabel.isHidden = false
                secondLabel.isHidden = false
                maxPitches.text = String(2000)
                maxPitches.isHidden = false
                alertLabel.text = "月に2000球以上投げないようにしましょう。"
            }
        }
        //上限投球数を保存
        userDefaults.set(Int(maxPitches.text!), forKey: "myMax")
        //年齢を保存
        userDefaults.set(ageLabel.text!, forKey: "myAge")
        userDefaults.synchronize()
    }
    @IBAction func cancelReturn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ageLabel.delegate = self
        firstLabel.isHidden = true
        maxPitches.isHidden = true
        secondLabel.isHidden = true
        
        //前回登録した年齢データの取り出し
        let myAge = userDefaults.string(forKey: "myAge")
        ageLabel.text = myAge
        
        //NumberPadに"Done"ボタンを表示
        let toolBar = UIToolbar(frame: CGRect(x:0, y:0, width: 320, height: 40))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolBar.items = [space, doneButton]
        ageLabel.inputAccessoryView = toolBar
        self.ageLabel.keyboardType = UIKeyboardType.numberPad
    }
    @objc func doneButtonTapped(sender: UIButton) {
        self.view.endEditing(true)
    }
    //textFieldタップ時に全選択にする
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
}

