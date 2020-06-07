//
//  AddAlarmTableViewController.swift
//  iOS_Clock_App
//
//  Created by Naoki Mita on 2020-05-29.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit

class AddAlarmTableViewController: UITableViewController {

    var newAlarm: Alarm!
    
    private let timeCell = DatePickerTableViewCell()
    private var repeatWeeks: Set<Week.weekType> = []
    private var repeatCell: RightDetailTableViewCell = {
        let tc = RightDetailTableViewCell(style: .value1, reuseIdentifier: nil)
        tc.textLabel?.text = "Repeat"
        tc.accessoryType = .disclosureIndicator
        return tc
    }()
    private var labelCell: RightDetailTableViewCell = {
        let tc = RightDetailTableViewCell(style: .value1, reuseIdentifier: nil)
        tc.textLabel?.text = "Label"
        tc.accessoryType = .disclosureIndicator
        return tc
    }()
    private var soundCell: RightDetailTableViewCell = {
        let tc = RightDetailTableViewCell(style: .value1, reuseIdentifier: nil)
        tc.textLabel?.text = "Sound"
        tc.accessoryType = .disclosureIndicator
        return tc
    }()
    
    var addAlarm: ((Alarm) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Alarm"
        let lb = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:)))
        lb.tintColor = UIColor(named: "highlightOrange")
        navigationItem.leftBarButtonItem = lb
        let rb = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped(_:)))
        rb.tintColor = UIColor(named: "highlightOrange")
        navigationItem.rightBarButtonItem = rb
        timeCell.datePicker.date = newAlarm.date
    }
    
    @objc func cancelTapped(_ sender: UIBarButtonItem) {
      dismiss(animated: true, completion: nil)
    }
    
    @objc func saveTapped(_ sender: UIBarButtonItem) {
        newAlarm.date = timeCell.datePicker.date
        addAlarm?(newAlarm)
        dismiss(animated: true, completion: nil)
    }
    
    func updateRepeatWeeks(new: Set<Week.weekType.RawValue>) {
        newAlarm.week = new
        tableView.reloadData()
    }
    
    func updateLabel(new: String) {
        newAlarm.label = new
        tableView.reloadData()
    }
    
    func updateSound(new: Sound) {
        newAlarm.sound = new
        tableView.reloadData()
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
                let cell = repeatCell
                if let txt = newAlarm.getWeekDescription() {
                    cell.detailTextLabel?.text = txt
                } else {
                    cell.detailTextLabel?.text = "Never"
                }
                return cell
            case (1, 1):
                let cell = labelCell
                cell.detailTextLabel?.text = newAlarm.label
                return cell
            case (1, 2):
                let cell = soundCell
                cell.detailTextLabel?.text = newAlarm.sound.name.rawValue
                return cell
            default:
                return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 216 : 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      
      switch (indexPath.section, indexPath.row) {
        case (1, 0):
            let weekTVC = WeekTableViewController(style: .grouped)
            weekTVC.curSelectWeeks = newAlarm.week
            weekTVC.didSelect = updateRepeatWeeks
            navigationController?.pushViewController(weekTVC, animated: true)
        case (1, 1):
            let lTVC = LabelViewController()
            lTVC.inputText = newAlarm.label
            lTVC.textInputDone = updateLabel
            navigationController?.pushViewController(lTVC, animated: true)
        case (1, 2):
            let sTVC = SoundTableViewController()
            sTVC.curSound = newAlarm.sound
            sTVC.didSelect = updateSound
            navigationController?.pushViewController(sTVC, animated: true)
        default:
            break
      }
      tableView.beginUpdates()
      tableView.endUpdates()
    }
}
