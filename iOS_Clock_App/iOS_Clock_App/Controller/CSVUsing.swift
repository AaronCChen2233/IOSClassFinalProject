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
                for (index, row) in rows.enumerated() {
                    if index != rows.count - 1 {
                        let columns = row.components(separatedBy: ",").map({$0[1, $0.count - 1]})
                        result.append(columns)
                    }
                }
            }
        }
        return result
    }
}
