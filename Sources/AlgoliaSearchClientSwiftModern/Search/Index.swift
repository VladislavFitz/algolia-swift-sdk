//
//  Index.swift
//
//
//  Created by Vladislav Fitc on 14.08.2022.
//

import Foundation

public class Index {
  public let indexName: IndexName
  internal let client: Client

  internal let batchSize = 10000

  internal init(indexName: IndexName, client: Client) {
    self.indexName = indexName
    self.client = client
  }
}
