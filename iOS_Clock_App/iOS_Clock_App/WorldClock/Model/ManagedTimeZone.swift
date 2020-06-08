//
//  ManagedTimeZone.swift
//  iOS_Clock_App
//
//  Created by WendaLi on 2020-06-03.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import UIKit
import CoreData

class ManagedTimeZone: NSManagedObject {
    class func readAllTimeZone(in context: NSManagedObjectContext, completion: @escaping ([Zone]?) -> Void) {
        let request: NSFetchRequest<ManagedTimeZone> = ManagedTimeZone.fetchRequest()
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
    
    class func findOrCreateTimeZone(matching timeZoneInfo: Zone, with zoneName: String, in context: NSManagedObjectContext) throws -> ManagedTimeZone {
        let request: NSFetchRequest<ManagedTimeZone> = ManagedTimeZone.fetchRequest()
        request.predicate = NSPredicate(format: "zoneName = %@", timeZoneInfo.zoneName)
        // NSSortDescriptor possible
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "ManagedTimeZone.findOrCreateTimeZone -- database inconsistency")
                let matchedTimeZone = matches[0]
                matchedTimeZone.resetValue(
                    countryCode: timeZoneInfo.countryCode,
                    countryName: timeZoneInfo.countryName,
                    gmtOffset: timeZoneInfo.gmtOffset,
                    timestamp: timeZoneInfo.timestamp,
                    zoneName: timeZoneInfo.zoneName)
                return matchedTimeZone
            }
        } catch {
            throw error
        }
      
        // no match
        let timeZone = ManagedTimeZone(context: context)
        timeZone.resetValue(
            countryCode: timeZoneInfo.countryCode,
            countryName: timeZoneInfo.countryName,
            gmtOffset: timeZoneInfo.gmtOffset,
            timestamp: timeZoneInfo.timestamp,
            zoneName: timeZoneInfo.zoneName)
        try? context.save()
        return timeZone
    }
}

extension ManagedTimeZone {
    func converToZone() -> Zone {
        var zone = Zone()
        zone.countryCode = self.countryCode ?? ""
        zone.countryName = self.countryName ?? ""
        zone.gmtOffset = Int(self.gmtOffset)
        zone.timestamp = Int(self.timestamp)
        zone.zoneName = self.zoneName ?? ""
        return zone
    }
    
    func resetValue(countryCode: String, countryName: String, gmtOffset: Int, timestamp: Int, zoneName: String) {
        let zoneNameSplit = zoneName.split(separator: "/")
        let cityName = zoneNameSplit[1]
        self.city = String(cityName)
        self.countryCode = countryCode
        self.countryName = countryName
        self.gmtOffset = Int64(gmtOffset)
        self.timestamp = Int64(timestamp)
        self.zoneName = zoneName
        self.firstLetter = String(cityName.first!)
    }
}
