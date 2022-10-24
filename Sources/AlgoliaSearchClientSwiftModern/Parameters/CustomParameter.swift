import Foundation

struct CustomParameter {
  let key: String
  let value: JSON

  init(key: String, _ value: JSON) {
    self.key = key
    self.value = value
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
}

extension CustomParameter: SearchParameter {
  var urlEncodedString: String {
    ""
  }
}

extension CustomParameter: SettingsParameter {}
