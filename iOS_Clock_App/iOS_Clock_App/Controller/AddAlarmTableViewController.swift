//
//  AddAlarmTableViewController.swift
//  iOS_Clock_App
//
//  Created by Naoki Mita on 2020-05-29.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit

class AddAlarmTableViewController: UITableViewController {

    private let timeCell = DatePickerTableViewCell()
    private var repeatCell: RightDetailTableViewCell = {
        let tc = RightDetailTableViewCell(style: .value1, reuseIdentifier: nil)
        tc.textLabel?.text = "Repeat"
        tc.detailTextLabel?.text = "Never"
        return tc
    }()
    private var labelCell: RightDetailTableViewCell = {
        let tc = RightDetailTableViewCell(style: .value1, reuseIdentifier: nil)
        tc.textLabel?.text = "Label"
        tc.detailTextLabel?.text = "Alarm"
        return tc
    }()
    private var soundCell: RightDetailTableViewCell = {
        let tc = RightDetailTableViewCell(style: .value1, reuseIdentifier: nil)
        tc.textLabel?.text = "Sound"
        tc.detailTextLabel?.text = "Radar"
        return tc
    }()
    
    var addAlarm: ((Alarm) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Alarm"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped(_:)))
    }
    
    @objc func cancelTapped(_ sender: UIBarButtonItem) {
      dismiss(animated: true, completion: nil)
    }
    
    @objc func saveTapped(_ sender: UIBarButtonItem) {
        let newAlarm = Alarm(date: timeCell.datePicker.date, repeatWeekdays: [], label: labelCell.detailTextLabel!.text!, sound: soundCell.detailTextLabel!.text!)
        addAlarm?(newAlarm)
        dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
            case (0, 0):
                return timeCell
            case (1, 0):
                return repeatCell
            case (1, 1):
                return labelCell
            case (1, 2):
                return soundCell
            default:
                return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 216 : 44
    }
}
