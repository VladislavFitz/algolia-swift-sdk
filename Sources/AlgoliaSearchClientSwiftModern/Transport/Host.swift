//
//  Host.swift
//
//
//  Created by Vladislav Fitc on 11.08.2022.
//

import Foundation

class Host {
  /// Url to target.
  let value: String

  /// Supported request types
  let requestType: RequestTypeSupport

  var isUp: Bool

  var lastUpdated: Date

  var retryCount: Int

  convenience init(url: String) {
    self.init(url: url, requestType: .universal)
  }

  init(url: String, requestType: RequestTypeSupport = .universal) {
    value = url
    self.requestType = requestType
    isUp = true
    lastUpdated = Date()
    retryCount = 0
  }

  func supports(_ requestType: RequestType) -> Bool {
    switch requestType {
    case .read:
      return self.requestType.contains(.read)
    case .write:
      return self.requestType.contains(.write)
    }
  }

  func reset() {
    lastUpdated = Date()
    isUp = true
    retryCount = 0
  }

  func hasTimedOut() {
    isUp = true
    lastUpdated = Date()
    retryCount += 1
  }

  func hasFailed() {
    isUp = false
    lastUpdated = Date()
  }
}

extension Host {
  convenience init(appID: String, urlSuffix: String, requestType: RequestTypeSupport) {
    self.init(url: "\(appID)\(urlSuffix)", requestType: requestType)
  }
}

extension Host: CustomStringConvertible {
  var description: String {
    return value
  }
}

extension Host: CustomDebugStringConvertible {
  var debugDescription: String {
    return """
    Host {
      url: \(value)
      requestType: \(requestType)
      isUp: \(isUp)
      lastUpdated: \(lastUpdated)
      retryCount: \(retryCount)
    }
    """
  }
}
