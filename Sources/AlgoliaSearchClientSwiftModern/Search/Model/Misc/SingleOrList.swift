//
//  SingleOrList.swift
//
//
//  Created by Vladislav Fitc on 14.08.2022.
//

import Foundation

public typealias SingleOrList<T> = Either<T, [T]>

extension SingleOrList {
  static func single(_ element: A) -> Self { .first(element) }
  static func list(_ elements: B) -> Self { .second(elements) }
}
