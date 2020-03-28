//
//  AgeRegisterViewController.swift
//  MyCalendar
//
//  Created by 桑原望 on 2020/03/27.
//  Copyright © 2020 MySwift. All rights reserved.
//

import UIKit

class AgeRegisterViewController: UIViewController {
    
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
            if ageInt < 6 {
               // maxPitches.text = "まずは野球を楽しみましょう"
                firstLabel.isHidden = true
                secondLabel.isHidden = true
                alertLabel.isHidden = false
                maxPitches.isHidden = true
                alertLabel.text = "まずは野球を楽しみましょう!"
            } else if ageInt >= 6, ageInt < 13 {
                maxPitches.text = String(800)
                firstLabel.isHidden = false
                maxPitches.isHidden = false
                secondLabel.isHidden = false
                alertLabel.text = "月に800球以上投げないようにしましょう。"
            } else if ageInt >= 13, ageInt < 16 {
                maxPitches.text = String(1400)
                firstLabel.isHidden = false
                maxPitches.isHidden = false
                secondLabel.isHidden = false
                alertLabel.text = "月に1400球以上投げないようにしましょう。"
            } else if ageInt >= 16 {
                maxPitches.text = String(2000)
                firstLabel.isHidden = false
                maxPitches.isHidden = false
                secondLabel.isHidden = false
                alertLabel.text = "月に2000球以上投げないようにしましょう。"
            }
        }
        userDefaults.set(Int(maxPitches.text!), forKey: "myMax")
        userDefaults.synchronize()
    }
    
    @IBAction func cancelReturn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        firstLabel.isHidden = true
        maxPitches.isHidden = true
        secondLabel.isHidden = true
        
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
}
