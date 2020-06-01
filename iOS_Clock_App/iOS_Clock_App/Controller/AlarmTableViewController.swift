//
//  AlarmTableViewController.swift
//  iOS_Clock_App
//
//  Created by Naoki Mita on 2020-05-28.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit
import UserNotifications
import AudioToolbox

class AlarmTableViewController: UITableViewController {
    
    let cellIdentifier = "AlarmCell"
    
    var alarms: [Alarm] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alarm"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewAlarmTVC(_:)))
        tableView.allowsSelectionDuringEditing = true
        tableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: cellIdentifier)

//        let center = UNUserNotificationCenter.current()
//        center.removeAllDeliveredNotifications()
//        center.removeAllPendingNotificationRequests()
//        center.getPendingNotificationRequests(completionHandler: { requests in
//            for request in requests {
//                print(request)
//            }
//        })
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
    
    func addNewAlarm(new: Alarm, pos: Int?) {
        if let i = pos {
            deleteNotification(Ids: alarms[i].notificationIds)
            alarms[i] = new
            alarms[i].notificationIds = setNotifications(alarm: new, pos: i)
            tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
            
        } else {
            alarms.append(new)
            let lastId: Int = alarms.count - 1
            alarms[lastId].notificationIds = setNotifications(alarm: new, pos: lastId)
            tableView.insertRows(at: [IndexPath(row: lastId, section: 0)], with: .automatic)
        }
    }
    
    func setNotifications(alarm: Alarm, pos: Int) -> [String] {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let content = UNMutableNotificationContent()
        content.title = "Alarm - \(alarm.label)"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(alarm.sound.name).mp3"))
        
        var ids: [String] = []
        if alarm.week.count == 0 {
            var triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: alarm.date)
            triggerWeekly.second = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
            let identifier = "alarm-\(pos)-once"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            center.add(request) { (error) in
                if (error) != nil {
                    print(error!.localizedDescription)
                }
            }
            ids.append(identifier)
        }
        
        for w in alarm.week {
            var triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: alarm.date)
            triggerWeekly.second = 0
            let weekId = (w.rawValue + 1) % 7 + 1
            triggerWeekly.weekday = weekId
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
            let identifier: String = "alarm-\(pos)-\(weekId)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            center.add(request) { (error) in
                if (error) != nil {
                    print(error!.localizedDescription)
                }
            }
            ids.append(identifier)
        }
        return ids
    }
    
    func deleteNotification(Ids: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: Ids)
    }
    
    @objc func showNewAlarmTVC(_ sender: UIBarButtonItem) {
        let addAlarmTVC = AddAlarmTableViewController(style: .grouped)
        let embedNav = UINavigationController(rootViewController: addAlarmTVC)
        addAlarmTVC.addAlarm = addNewAlarm
        present(embedNav, animated: true, completion: nil)
    }
    
    // edit operation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard tableView.isEditing else { return }
        let addAlarmTVC = AddAlarmTableViewController(style: .grouped)
        let embedNav = UINavigationController(rootViewController: addAlarmTVC)
        addAlarmTVC.newAlarm = alarms[indexPath.row]
        addAlarmTVC.addAlarm = addNewAlarm
        addAlarmTVC.insertPos = indexPath.row
        present(embedNav, animated: true, completion: nil)
    }
    
    // delete operation
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        alarms.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
}


// Handling notifications when the app is in the foreground
extension AlarmTableViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
