//
//  Array+Diff.swift
//  NewsAPI
//
//  Created by Derrick Park on 5/24/20.
//  Copyright © 2020 Derrick Park. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
  func difference(from other: [Element]) -> [Element] {
    let thisSet = Set(self)
    let otherSet = Set(other)
    return Array(thisSet.symmetricDifference(otherSet))
  }
}
