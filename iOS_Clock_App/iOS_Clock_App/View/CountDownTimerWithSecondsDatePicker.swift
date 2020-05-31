//
//  CountDownTimerWithSecondsDatePicker.swift
//  iOS_Clock_App
//
//  Created by Aaron Chen on 2020-05-31.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit

class CountDownTimerWithSecondsDatePicker : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let hours = (0...23).map{String($0)}
    let minutOrSecond = (0...59).map{String($0)}
    
    var timePickerview : UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePickerview = UIPickerView()
        view.addSubview(timePickerview)
        timePickerview.matchParent()
        timePickerview.delegate = self
        timePickerview.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 1:
            return 1
        case 2:
            return minutOrSecond.count
        case 3:
            return 1
        case 4:
            return minutOrSecond.count
        case 5:
            return 1
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return hours[row]
        case 1:
            return "hours"
        case 2:
            return minutOrSecond[row]
        case 3:
            return "min"
        case 4:
            return minutOrSecond[row]
        case 5:
            return "sec"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 1:
            return 70
 
        default:
            return 50
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print()
    }
}
