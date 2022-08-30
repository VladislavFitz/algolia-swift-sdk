//
//  SettingsParameter.swift
//
//
//  Created by Vladislav Fitc on 09.08.2022.
//

import Foundation

public protocol SettingsParameter: Encodable {
  static var key: String { get }
}

@resultBuilder
enum SettingsParametersBuilder {
  static func buildBlock() -> [SettingsParameter] { [] }
}

extension SettingsParametersBuilder {
  static func buildBlock(_ parameters: SettingsParameter...) -> [SettingsParameter] { parameters }
}
