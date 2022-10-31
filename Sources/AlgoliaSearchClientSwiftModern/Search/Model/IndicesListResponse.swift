import Foundation

public struct IndicesListResponse: Decodable {
  public let items: [Index]

  /**
    The value is always 1.
    There is currently no pagination for this method. Every index is returned on the first call.
   */
  public let nbPages: Int

  public struct Index: Decodable {
    /// Index name.
    public let name: IndexName

    /// Index creation date.
    public let createdAt: Date

    /// Date of last update.
    public let updatedAt: Date

    /// Number of records contained in the index.
    public let entries: Int

    /// Number of bytes of the index in minified format.
    public let dataSize: Double

    /// Number of bytes of the index binary file.
    public let fileSize: Double

    /// Last build time in seconds.
    public let lastBuildTimeS: Int

    /// Number of pending indexing operations.
    public let numberOfPendingTasks: Int

    /// A boolean which says whether the index has pending tasks.
    public let pendingTask: Bool

    public let replicas: [IndexName]?
    public let primary: IndexName?
    public let sourceABTest: IndexName?
//    public let abTest: ABTestShortResponse?
  }
}
