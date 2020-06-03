//
//  URL+Params.swift
//  NewsAPI
//
//  Created by Derrick Park on 5/24/20.
//  Copyright © 2020 Derrick Park. All rights reserved.
//

import Foundation

extension URL {
  func withQueries(_ queries: [String: String]) -> URL? {
    var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
    components?.queryItems = queries.map { URLQueryItem(name: $0.key, value: $0.value) }
    return components?.url
  }
}
