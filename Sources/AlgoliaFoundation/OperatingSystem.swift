import Foundation

public enum OperatingSystem {
  public static var description: String {
    let version = ProcessInfo.processInfo.operatingSystemVersion
    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    return "\(name) \(versionString)"
  }

  public static var name: String {
    #if os(iOS)
      return "iOS"
    #elseif os(OSX)
      return "macOS"
    #elseif os(tvOS)
      return "tvOS"
    #elseif os(watchOS)
      return "watchOS"
    #elseif os(Linux)
      return "Linux"
    #else
      return "undefined"
    #endif
  }
}
