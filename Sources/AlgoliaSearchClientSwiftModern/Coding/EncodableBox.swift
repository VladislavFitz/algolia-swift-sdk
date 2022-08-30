//
//  EncodableBox.swift
//
//
//  Created by Vladislav Fitc on 08.08.2022.
//

import Foundation

/// Concrete type box for an arbitrary encodable value
struct EncodableBox: Encodable {
  let value: Encodable

  init(_ value: Encodable) {
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    try value.encode(to: encoder)
  }
}
