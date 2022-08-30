//
//  PartialUpdateOperation.swift
//
//
//  Created by Vladislav Fitc on 09.10.2022.
//

import Foundation

struct PartialUpdateOperation: Codable, Equatable {
  let kind: Kind
  let value: JSON

  enum CodingKeys: String, CodingKey {
    case value
    case kind = "_operation"
  }

  enum Kind: String, Codable {
    /// Increment a numeric attribute
    case increment = "Increment"

    /**
     Increment a numeric integer attribute only if the provided value matches the current value,
     and otherwise ignore the whole object update.

     For example, if you pass an IncrementFrom value of 2 for the version attribute,
     but the current value of the attribute is 1, the engine ignores the update.
     If the object doesn’t exist, the engine only creates it if you pass an IncrementFrom value of 0.
     */
    case incrementFrom = "IncrementFrom"

    /**
     Increment a numeric integer attribute only if the provided value is greater than the current value,
     and otherwise ignore the whole object update.

     For example, if you pass an IncrementSet value of 2 for the version attribute,
     and the current value of the attribute is 1, the engine updates the object.
     If the object doesn’t exist yet, the engine only creates it if you pass an
     IncrementSet value that’s greater than 0.
     */
    case incrementSet = "IncrementSet"

    /// Decrement a numeric attribute
    case decrement = "Decrement"

    /// Append a number or string element to an array attribute
    case add = "Add"

    /// Remove all matching number or string elements from an array attribute
    case remove = "Remove"

    /// Add a number or string element to an array attribute only if it’s not already present
    case addUnique = "AddUnique"
  }
}
