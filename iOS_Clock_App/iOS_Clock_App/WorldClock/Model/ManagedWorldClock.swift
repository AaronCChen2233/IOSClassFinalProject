//
//  ManagedWorldClock.swift
//  iOS_Clock_App
//
//  Created by WendaLi on 2020-06-03.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit
import CoreData

class ManagedWorldClock: NSManagedObject {
    
    
    class func readAllWorldClock(in context: NSManagedObjectContext, completion: @escaping ([Zone]?) -> Void) {
        let request: NSFetchRequest<ManagedWorldClock> = ManagedWorldClock.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
        do {
            let matches = try context.fetch(request)
            var zones = [Zone]()
            for matche in matches {
                let zone = matche.converToZone()
                zones.append(zone)
            }
            completion(zones)
        } catch {
        }
    }
    
    class func findOrCreateWorldClock(matching worldClockInfo: Zone, with zoneName: String,  at order: Int, in context: NSManagedObjectContext) throws -> ManagedWorldClock {
        let request: NSFetchRequest<ManagedWorldClock> = ManagedWorldClock.fetchRequest()
        request.predicate = NSPredicate(format: "zoneName = %@", worldClockInfo.zoneName)
        // NSSortDescriptor possible
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "ManagedWorldClock.findOrCreateTimeZone -- database inconsistency")
                let matchedWorldClock = matches[0]
                return matchedWorldClock
            }
        } catch {
            throw error
        }
      
        // no match
        let worldClock = ManagedWorldClock(context: context)
        worldClock.resetValue(
            order: order,
            countryCode: worldClockInfo.countryCode,
            countryName: worldClockInfo.countryName,
            gmtOffset: worldClockInfo.gmtOffset,
            timestamp: worldClockInfo.timestamp,
            zoneName: worldClockInfo.zoneName)
        try? context.save()
        return worldClock
    }
    
    class func findAndDeleteWorldClock(matching worldClockInfo: Zone, with zoneName: String, in context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<ManagedWorldClock> = ManagedWorldClock.fetchRequest()
        request.predicate = NSPredicate(format: "zoneName = %@", worldClockInfo.zoneName)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "ManagedWorldClock.findOrCreateTimeZone -- database inconsistency")
            }
            context.delete(matches[0])
            try? context.save()
        } catch {
            throw error
        }
    }
    
    class func changeWorldClockOrder(matching worldClockInfo: Zone, with zoneName: String, from sourceOrder: Int, to destinationOrder: Int, in context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<ManagedWorldClock> = ManagedWorldClock.fetchRequest()
        //request.predicate = NSPredicate(format: "order BETWEEN {%@,'%@}", Int32(sourceOrder), Int32(destinationOrder))
        var selected = -1
        do {
            let matches = try context.fetch(request)
            for (index, match) in matches.enumerated() {
                if match.order == sourceOrder {
                    selected = index
                }
                if  sourceOrder < destinationOrder {
                    if match.order > sourceOrder && match.order <= destinationOrder{
                        match.order -= 1
                    }
                }else {
                    if match.order >= destinationOrder && match.order < sourceOrder{
                        match.order += 1
                    }
                }
            }
            matches[selected].order = Int32(destinationOrder)
            try? context.save()
        } catch {
            throw error
        }
    }
}

extension ManagedWorldClock {
    func converToZone() -> Zone {
        var zone = Zone()
        zone.countryCode = self.countryCode ?? ""
        zone.countryName = self.countryName ?? ""
        zone.gmtOffset = Int(self.gmtOffset)
        zone.timestamp = Int(self.timestamp)
        zone.zoneName = self.zoneName ?? ""
        return zone
    }
    
    func resetValue(order: Int, countryCode: String, countryName: String, gmtOffset: Int, timestamp: Int, zoneName: String) {
        let zoneNameSplit = zoneName.split(separator: "/")
        let cityName = zoneNameSplit[1]
        self.city = String(cityName)
        self.countryCode = countryCode
        self.countryName = countryName
        self.gmtOffset = Int64(gmtOffset)
        self.timestamp = Int64(timestamp)
        self.zoneName = zoneName
        self.order = Int32(order)
    }
}
