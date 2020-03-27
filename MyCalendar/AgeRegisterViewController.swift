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
    @IBOutlet weak var maxPitches: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    let userDefaults = UserDefaults.standard
    
    @IBAction func resultButton(_ sender: Any) {
        
        if let ageInt = Int(ageLabel.text!) {
            if ageInt < 6 {
                maxPitches.text = "まずは野球を楽しんでください"
            } else if ageInt >= 6, ageInt < 13 {
                maxPitches.text = String(800)
            } else if ageInt >= 13, ageInt < 16 {
                maxPitches.text = String(1400)
            } else if ageInt >= 16 {
                maxPitches.text = String(2000)
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

        // Do any additional setup after loading the view.
    }
    
}
