//
//  WeekTableViewController.swift
//  iOS_Clock_App
//
//  Created by Naoki Mita on 2020-05-29.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit

class WeekTableViewController: UITableViewController {
    
    private let week: [Week] = Week.getAllWeek()
    var curSelectWeeks: Set<Week.weekType.RawValue>!
    var didSelect: ((Set<Week.weekType.RawValue>) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repeat"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return week.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RightDetailTableViewCell = {
            let tc = RightDetailTableViewCell(style: .value1, reuseIdentifier: nil)
            let w: Week = week[indexPath.row]
            tc.textLabel?.text = w.type.description
            if let setWeek = curSelectWeeks {
                tc.accessoryType = setWeek.contains(w.type.rawValue) ? .checkmark : .none
            } else {
                tc.accessoryType = .none
            }
            return tc
        }()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cur = tableView.cellForRow(at: indexPath)?.accessoryType
        if cur == UITableViewCell.AccessoryType.none {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            curSelectWeeks.insert(week[indexPath.row].type.rawValue)
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            curSelectWeeks.remove(week[indexPath.row].type.rawValue)
        }
        didSelect?(curSelectWeeks!)
    }
}
