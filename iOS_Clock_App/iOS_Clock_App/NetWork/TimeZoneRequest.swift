//
//  TimeZoneRequest.swift
//  iOS_Clock_App
//
//  Created by WendaLi on 2020-06-03.
//  Copyright © 2020 Aaron Chen. All rights reserved.
//

import Foundation

class TimeZoneRequest {
    
    static let shared = TimeZoneRequest()
    
    private init() { }
    
    func fetchCities (completion: @escaping ([Zone]?) -> Void) {
        let baseURL = URL(string: "http://api.timezonedb.com/v2.1/list-time-zone?")!
        let timeZoneURL = baseURL.withQueries(["format":"json", "key":"IJEPRYDQ2ZI3"])!
        let task = URLSession.shared.dataTask(with: timeZoneURL) { (data, response, error) in
            if let jsonData = data{
                if let cities = try? JSONDecoder().decode(TimeZone.self, from: jsonData) {
                    completion(cities.zones)
                }
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
