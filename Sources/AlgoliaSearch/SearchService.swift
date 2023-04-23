//
//  SearchService.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation

public protocol SearchService {
  associatedtype Request: SearchRequest
  associatedtype Response: SearchResponse
  
  func fetchResponse(for request: Request) async throws -> Response
}
