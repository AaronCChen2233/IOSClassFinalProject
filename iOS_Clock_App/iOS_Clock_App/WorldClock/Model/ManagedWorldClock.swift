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
        do {
            let matches = try context.fetch(request)
            var zones = [Zone]()
            for matche in matches {
                var zone = Zone()
                zone.countryCode = matche.countryCode ?? ""
                zone.countryName = matche.countryName ?? ""
                zone.gmtOffset = Int(matche.gmtOffset)
                zone.timestamp = Int(matche.timestamp)
                zone.zoneName = matche.zoneName ?? ""
                zones.append(zone)
            }
            completion(zones)
        } catch {
        }
    }
    
    class func findOrCreateWorldClock(matching worldClockInfo: Zone, with zoneName: String, in context: NSManagedObjectContext) throws -> ManagedWorldClock {
        let request: NSFetchRequest<ManagedWorldClock> = ManagedWorldClock.fetchRequest()
        request.predicate = NSPredicate(format: "zoneName = %@", worldClockInfo.zoneName)
        // NSSortDescriptor possible
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "ManagedWorldClock.findOrCreateTimeZone -- database inconsistency")
                let matchedWorldClock = matches[0]
                matchedWorldClock.countryCode = worldClockInfo.countryCode
                matchedWorldClock.countryName = worldClockInfo.countryName
                matchedWorldClock.gmtOffset = Int64(worldClockInfo.gmtOffset)
                matchedWorldClock.timestamp = Int64(worldClockInfo.timestamp)
                matchedWorldClock.zoneName = worldClockInfo.zoneName
                return matchedWorldClock
            }
        } catch {
            throw error
        }
      
        // no match
        let worldClock = ManagedWorldClock(context: context)
        worldClock.countryCode = worldClockInfo.countryCode
        worldClock.countryName = worldClockInfo.countryName
        worldClock.gmtOffset = Int64(worldClockInfo.gmtOffset)
        worldClock.timestamp = Int64(worldClockInfo.timestamp)
        worldClock.zoneName = worldClockInfo.zoneName
        return worldClock
    }
}
