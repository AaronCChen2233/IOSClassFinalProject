//
//  ManagedAlarm.swift
//  iOS_Clock_App
//
//  Created by Naoki Mita on 2020-06-02.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit
import CoreData

class ManagedAlarm: NSManagedObject {
    class func CreateOrUpdateAlarm(matching alarmInfo: Alarm, with searchId: Int, in context: NSManagedObjectContext) throws -> ManagedAlarm {
      let request: NSFetchRequest<ManagedAlarm> = ManagedAlarm.fetchRequest()
      request.predicate = NSPredicate(format: "id = %d", searchId)
      
      do {
        let matches = try context.fetch(request)
        if matches.count > 0 {
          assert(matches.count == 1, "ManagedArticle.findOrCreateArticle -- database inconsistency")
          let matchedAlarm = matches[0]
          matchedAlarm.setValue(alarmInfo.label, forKey: "label")
          matchedAlarm.setValue(alarmInfo.date, forKey: "date")
          matchedAlarm.setValue(alarmInfo.isOn, forKey: "isOn")
          matchedAlarm.setValue(alarmInfo.notificationIds as NSObject, forKey: "notifications")
          matchedAlarm.setValue(alarmInfo.sound.name.rawValue, forKey: "sound")
          matchedAlarm.setValue(alarmInfo.week as NSObject, forKey: "week")
          return matchedAlarm
        }
      } catch {
        throw error
      }
      
      let alarm = ManagedAlarm(context: context)
      alarm.id = Int32(alarmInfo.id)
      alarm.label = alarmInfo.label
      alarm.date = alarmInfo.date
      alarm.isOn = alarmInfo.isOn
      alarm.notifications = alarmInfo.notificationIds as NSObject
      alarm.sound = alarmInfo.sound.name.rawValue
      alarm.week = alarmInfo.week as NSObject
      return alarm
    }
    
    class func UpdateColumn(attribute: String, value: Bool, searchId: Int, in context: NSManagedObjectContext) throws {
      let request: NSFetchRequest<ManagedAlarm> = ManagedAlarm.fetchRequest()
      request.predicate = NSPredicate(format: "id = %d", searchId)
      
      do {
        let matches = try context.fetch(request)
        if matches.count > 0 {
          assert(matches.count == 1, "ManagedArticle.findOrCreateArticle -- database inconsistency")
          let matchedAlarm = matches[0]
          matchedAlarm.setValue(value, forKey: attribute)
        }
      } catch {
        throw error
      }
    }

    
    class func DeleteAlarm(searchId: Int, in context: NSManagedObjectContext) throws {
      let request: NSFetchRequest<ManagedAlarm> = ManagedAlarm.fetchRequest()
      request.predicate = NSPredicate(format: "id = %d", searchId)
      
      do {
        let matches = try context.fetch(request)
        if matches.count > 0 {
          assert(matches.count == 1, "ManagedArticle.findOrCreateArticle -- database inconsistency")
          let matchedAlarm = matches[0]
          context.delete(matchedAlarm)
        }
      } catch {
        throw error
      }
    }

    class func ClearAllData(in context: NSManagedObjectContext) {
        let request: NSFetchRequest<ManagedAlarm> = ManagedAlarm.fetchRequest()
        do {
            let matches = try context.fetch(request)
            for obj in matches {
                context.delete(obj)
            }
        } catch let error as NSError {
            print("Detele all data in error: \(error) \(error.userInfo)")
        }
    }
    
    class func insertAllRecord(in context: NSManagedObjectContext) -> [Alarm] {
        let request: NSFetchRequest<ManagedAlarm> = ManagedAlarm.fetchRequest()
        var result: [Alarm] = []
        do {
            let matches = try context.fetch(request)
            for obj in matches {
                let new = Alarm(id: Int(obj.id), date: obj.date!, week: obj.week as! Set<Week.weekType.RawValue>, label: obj.label!, sound: Sound(name: Sound.SoundName.init(rawValue: obj.sound!)!), isOn: obj.isOn, notificationIds: obj.notifications! as! [String])
                result.append(new)
            }
        } catch let error as NSError {
            print("Detele all data in error: \(error) \(error.userInfo)")
        }
        return result
    }

}
