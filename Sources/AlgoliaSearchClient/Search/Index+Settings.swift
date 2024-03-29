import Foundation

public extension Index {
  /**
   Get the Settings of an index.
   - Returns: Settings structure
   */
  func getSettings() async throws -> Settings {
    let responseData = try await client.transport.perform(method: .get,
                                                          path: "/1/indexes/\(name.rawValue)/settings",
                                                          headers: [:],
                                                          body: .none,
                                                          requestType: .read)
    return try client.jsonDecoder.decode(Settings.self, from: responseData)
  }

  /**
   Create or change an index’s Settings.
   Only non-null settings are overridden; null settings are left unchanged
   Performance wise, it’s better to setSettings before pushing the data.

   - Parameter parameters: settings parameters to apply.
   - Parameter resetToDefault: Reset a settings to its default value.
     Default: []
   - Parameter forwardToReplicas: Whether to forward the same settings to the replica indices.
     Default: false
   */
  func setSettings(_ parameters: SettingsParameters,
                   resetToDefault _: [String] = [],
                   forwardToReplicas _: Bool = false) async throws {
    let body = try client.jsonEncoder.encode(parameters)
    try await client.transport.perform(method: .put,
                                       path: "/1/indexes/\(name.rawValue)/settings",
                                       headers: ["Content-Type": "application/json"],
                                       body: body,
                                       requestType: .write)
  }
}
