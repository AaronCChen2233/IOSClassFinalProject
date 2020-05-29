//
//  AlarmTableViewCell.swift
//  iOS_Clock_App
//
//  Created by Naoki Mita on 2020-05-28.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    
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
        switchAlarm.addTarget(self, action: #selector(tappedSwitch), for: .valueChanged)
    }
    
    private func updateView() {
        self.textLabel!.text = alarm.dateformat()
        self.detailTextLabel?.text = "\(alarm.label), \(alarm.description())"
        switchAlarm.setOn(alarm.isOn, animated: true)
        tappedSwitch(switchAlarm)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tappedSwitch(_ sender : UISwitch!) {
        self.textLabel?.textColor = switchAlarm.isOn ? .black : .lightGray
        self.detailTextLabel?.textColor = switchAlarm.isOn ? .black : .lightGray
    }
}
