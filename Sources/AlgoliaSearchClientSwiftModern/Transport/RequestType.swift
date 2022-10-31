import Foundation

/**
 * Indicate whether the HTTP request performed is of type [read] (GET) or [write] (POST, PUT ..).
 * Used to determine which timeout duration to use.
 */
enum RequestType {
  case read, write
}
