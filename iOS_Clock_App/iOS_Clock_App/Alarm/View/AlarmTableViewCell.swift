//
//  AlarmTableViewCell.swift
//  iOS_Clock_App
//
//  Created by Naoki Mita on 2020-05-28.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    var onSwitch: ((Alarm) -> ([String]))!
    var offSwitch: ((Alarm) -> ())!

    var alarm: Alarm! {
      didSet {
        updateView()
      }
    }
    
    private var switchAlarm: UISwitch = {
        let us = UISwitch(frame: CGRect())
        us.translatesAutoresizingMaskIntoConstraints = false
        return us
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.textLabel?.font = UIFont.systemFont(ofSize: 45.0)
        self.accessoryView = switchAlarm
        self.editingAccessoryType = .disclosureIndicator
        switchAlarm.addTarget(self, action: #selector(tappedSwitch), for: .valueChanged)
    }
    
    private func updateView() {
        self.textLabel!.text = alarm.dateformat()
        if let txt = alarm.getWeekDescription() {
            self.detailTextLabel?.text = "\(alarm.label), \(txt)"
        } else {
            self.detailTextLabel?.text = "\(alarm.label)"
        }
        switchAlarm.setOn(alarm.isOn, animated: true)
        textLabel?.textColor = alarm.isOn ? .none : .lightGray
        detailTextLabel?.textColor = alarm.isOn ? .none : .lightGray

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @objc func tappedSwitch(_ sender : UISwitch!) {
        alarm.isOn = !alarm.isOn
        if sender.isOn  {
            alarm.notificationIds = onSwitch(alarm)
        } else {
            offSwitch(alarm)
        }
        updateView()
    }
}
