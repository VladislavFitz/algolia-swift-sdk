//
//  URLSession+HTTPClient.swift
//
//
//  Created by Vladislav Fitc on 14.08.2022.
//

import Foundation

extension URLSession: HTTPClient {
  func perform(_ request: URLRequest) async throws -> (Data, URLResponse) {
    try await data(for: request)
  }
}
