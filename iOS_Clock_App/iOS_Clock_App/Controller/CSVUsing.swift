//
//  CSVUsingTest.swift
//  iOS_Clock_App
//
//  Created by WendaLi on 2020-06-07.
//  Copyright © 2020 Don. All rights reserved.
//

import Foundation

class CSVUsing {
    class func csvLoad(_ forResource: String) -> [[String]]{
        var result : [[String]] = []
        if let url = Bundle.main.url(forResource: forResource, withExtension: "csv") {
            let data = try! Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            if let rows = dataEncoded?.components(separatedBy: "\n") {
                for row in rows {
                    let columns = row.components(separatedBy: ",")
                    result.append(columns)
                }
            }
        }
        return result
    }
}
