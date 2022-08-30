//
//  HTTPClient.swift
//
//
//  Created by Vladislav Fitc on 14.08.2022.
//

import Foundation

protocol HTTPClient {
  func perform(_ request: URLRequest) async throws -> (Data, URLResponse)
}
