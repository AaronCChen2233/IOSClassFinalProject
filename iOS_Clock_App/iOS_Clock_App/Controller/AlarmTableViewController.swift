//
//  AlarmTableViewController.swift
//  iOS_Clock_App
//
//  Created by Naoki Mita on 2020-05-28.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit

class AlarmTableViewController: UITableViewController {
    
    let cellIdentifier = "AlarmCell"
    
    var alarms: [Alarm] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alarm"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewAlarmTVC(_:)))
        tableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AlarmTableViewCell
        cell.alarm = alarms[indexPath.row]
        return cell
    }
    
    func addNewAlarm(new: Alarm) {
      alarms.append(new)
      tableView.insertRows(at: [IndexPath(row: alarms.count - 1, section: 0)], with: .automatic)
    }
    
    @objc func showNewAlarmTVC(_ sender: UIBarButtonItem) {
        let addAlarmTVC = AddAlarmTableViewController(style: .grouped)
        let embedNav = UINavigationController(rootViewController: addAlarmTVC)
        addAlarmTVC.addAlarm = addNewAlarm
        present(embedNav, animated: true, completion: nil)
    }
}
