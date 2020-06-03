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
    
    let hourLable : UILabel = {
        let lb = UILabel()
        lb.text = "hours"
        return lb
    }()
    
    let minLable : UILabel = {
        let lb = UILabel()
        lb.text = "min"
        return lb
    }()
    
    let secLable : UILabel = {
        let lb = UILabel()
        lb.text = "sec"
        return lb
    }()

    var timePickerview = UIPickerView()
    
    var hour = 0
    var min = 0
    var sec = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(hourLable)
        view.addSubview(minLable)
        view.addSubview(secLable)
        view.addSubview(timePickerview)
        
        timePickerview.matchParent()
        timePickerview.delegate = self
        timePickerview.dataSource = self
        
        /**Set UIViews constraint*/
        hourLable.anchors(topAnchor: view.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: nil, bottomAnchor: view.bottomAnchor,padding: UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0))
        
        minLable.anchors(topAnchor: view.topAnchor, leadingAnchor: hourLable.leadingAnchor ,trailingAnchor: nil, bottomAnchor: view.bottomAnchor,padding: UIEdgeInsets(top: 0, left: 130, bottom: 0, right: 0))
        
        secLable.anchors(topAnchor: view.topAnchor, leadingAnchor: nil, trailingAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor,padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50))
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 1:
            return 0
        case 2:
            return minutOrSecond.count
        case 3:
            return 0
        case 4:
            return minutOrSecond.count
        case 5:
            return 0
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return hours[row]
        case 1:
            return nil
        case 2:
            return minutOrSecond[row]
        case 3:
            return nil
        case 4:
            return minutOrSecond[row]
        case 5:
            return nil
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 1:
            /**hoursLable is a little bit longer*/
            return 70
        default:
            return 50
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hour = row
        case 2:
            min = row
        case 4:
            sec = row
        default:
            print("")
        }
    }
}
