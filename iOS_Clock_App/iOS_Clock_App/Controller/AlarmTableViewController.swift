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
import CoreData

class AlarmTableViewController: UITableViewController {
    
    let cellIdentifier = "AlarmCell"
    
    var alarms: [Alarm] = []
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alarm"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewAlarmTVC(_:)))
        tableView.allowsSelectionDuringEditing = true
        tableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        // delete all notifications
//        let center = UNUserNotificationCenter.current()
//        center.removeAllPendingNotificationRequests()
//        center.getPendingNotificationRequests(completionHandler: { requests in
//            for request in requests {
//                print(request)
//            }
//        })
        
        // delete all core data
//        clearDatabase()
        
        // insert data from core data into the alarms
        fetchAllRecord()
        
        // count alarms from Core Data
        printDatabaseStatistics()
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
        cell.position = indexPath.row
        cell.offSwitch = ({ (ids) in
            self.deleteNotification(Ids: ids!)
        })
        cell.onSwitch = ({ (alarm, int) -> ([String]) in
            return self.setNotifications(alarm: alarm)
        })
        return cell
    }
    
    func addNewAlarm(new: Alarm) {
        if new.id < alarms.count {
            deleteNotification(Ids: alarms[new.id].notificationIds)
            alarms[new.id] = new
            alarms[new.id].notificationIds = setNotifications(alarm: new)
            tableView.reloadRows(at: [IndexPath(row: new.id, section: 0)], with: .automatic)
        } else {
            alarms.append(new)
            alarms[new.id].notificationIds = setNotifications(alarm: new)
            tableView.insertRows(at: [IndexPath(row: new.id, section: 0)], with: .automatic)
        }
        addDatabase(with: alarms[new.id], for: new.id)
    }
        
    func setNotifications(alarm: Alarm) -> [String] {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let content = UNMutableNotificationContent()
        content.title = "Alarm - \(alarm.label)"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(alarm.sound.name).mp3"))
        
        var ids: [String] = []
        if alarm.week.count == 0 {
            var triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: alarm.date)
            triggerWeekly.second = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: false)
            let identifier = "alarm-\(alarm.id)-once"
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
            let weekId = (w + 1) % 7 + 1
            triggerWeekly.weekday = weekId
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
            let identifier: String = "alarm-\(alarm.id)-\(weekId)"
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
        center.removePendingNotificationRequests(withIdentifiers: Ids)
    }
    
    @objc func showNewAlarmTVC(_ sender: UIBarButtonItem) {
        let addAlarmTVC = AddAlarmTableViewController(style: .grouped)
        let embedNav = UINavigationController(rootViewController: addAlarmTVC)
        addAlarmTVC.newAlarm = Alarm(id: alarms.count, date: Date(), week: [])
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
        present(embedNav, animated: true, completion: nil)
    }
    
    // delete operation
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        alarms.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
    
    
    // operation for Core Data
    private func addDatabase(with alarm: Alarm, for searchId: Int) {
      container.performBackgroundTask { [weak self] context in
        _ = try? ManagedAlarm.CreateOrUpdateAlarm(matching: alarm, with: searchId, in: context)
        try? context.save()
        self?.printDatabaseStatistics()
      }
    }
    
    private func clearDatabase() {
      container.performBackgroundTask { [weak self] context in
        ManagedAlarm.ClearAllData(in: context)
        try? context.save()
        self?.printDatabaseStatistics()
      }
    }
    
    private func fetchAllRecord() {
      container.performBackgroundTask { [weak self] context in
        self?.alarms = ManagedAlarm.insertAllRecord(in: context)
      }
    }
    
    private func printDatabaseStatistics() {
      let context = container.viewContext
      context.perform {
        if Thread.isMainThread {
          print("on main thread")
        } else {
          print("off main thread")
        }

        if let alarmCount = (try? context.count(for: ManagedAlarm.fetchRequest())) {
          print("\(alarmCount) alarms")
        }
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
