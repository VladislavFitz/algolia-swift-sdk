import Foundation

/// Structure embedding the calculation of tagged substring in the input string
public final class TaggedString {
  
  public typealias MarkedRange = (range: Range<String.Index>, isTagged: Bool)
  
  /// Input string
  public let input: String

  /// Opening tag
  public let preTag: String

  /// Closing tag
  public let postTag: String

  /// String comparison options for tags parsing
  public let options: String.CompareOptions

  private lazy var storage: (String, [MarkedRange]) = TaggedString.computeRanges(for: input,
                                                                                      preTag: preTag,
                                                                                      postTag: postTag,
                                                                                      options: options)

  /// Output string cleansed of the opening and closing tags
  public private(set) lazy var output: String = storage.0

  /// List of ranges for output marked with tagged/untagged flag
  public private(set) lazy var taggedRanges: [MarkedRange] = storage.1

  /**
   - Parameters:
     - string: Input string
     - preTag: Opening tag
     - postTag: Closing tag
     - options: String comparison options for tags parsing
    */
  public init(string: String,
              preTag: String,
              postTag: String,
              options: String.CompareOptions = []) {
    // This string reconstruction is here to avoid a potential problems due to string encoding
    // Check unit test TaggedStringTests -> testWithDecodedString
    let string = String(string.indices.map { string[$0] })
    input = string
    self.preTag = preTag
    self.postTag = postTag
    self.options = options
  }


  private static func computeRanges(for string: String,
                                    preTag: String,
                                    postTag: String,
                                    options: String.CompareOptions) -> (output: String,
                                                                        markedRanges: [(range: Range<String.Index>, isTagged: Bool)]) {
    var output = string
    var preStack: [Range<String.Index>] = []
    var taggedRanges = [Range<String.Index>]()

    enum Tag {
      case pre(Range<String.Index>), post(Range<String.Index>)
    }

    func nextTag(in string: String) -> Tag? {
      switch (string.range(of: preTag, options: options), string.range(of: postTag, options: options)) {
      case let (.some(pre), .some(post)) where pre.lowerBound < post.lowerBound:
        return .pre(pre)
      case let (.some, .some(post)):
        return .post(post)
      case let (.some(pre), .none):
        return .pre(pre)
      case let (.none, .some(post)):
        return .post(post)
      case (.none, .none):
        return nil
      }
    }

    while let nextTag = nextTag(in: output) {
      switch nextTag {
      case let .pre(preRange):
        preStack.append(preRange)
        output.removeSubrange(preRange)
      case let .post(postRange):
        if let lastPre = preStack.last {
          preStack.removeLast()
          taggedRanges.append(.init(uncheckedBounds: (lastPre.lowerBound, postRange.lowerBound)))
        }
        output.removeSubrange(postRange)
      }
    }
    
    taggedRanges = mergeOverlapping(taggedRanges)
    let untaggedRanges = computeInvertedRanges(for: output, with: taggedRanges)
    let sortedMarkedRanges = (
      taggedRanges.map { (range: $0, isTagged: true) } +
      untaggedRanges.map { (range: $0, isTagged: false) }
    ).sorted(by: { $0.0.lowerBound < $1.0.lowerBound })
    
    return (output, sortedMarkedRanges)
  }

  private static func computeInvertedRanges(for string: String,
                                            with ranges: [Range<String.Index>]) -> [Range<String.Index>] {
    if ranges.isEmpty {
      return ([string.startIndex ..< string.endIndex])
    }

    var lowerBound = string.startIndex

    var invertedRanges: [Range<String.Index>] = []

    for range in ranges where range.lowerBound >= lowerBound {
      if lowerBound != range.lowerBound {
        let invertedRange = lowerBound ..< range.lowerBound
        invertedRanges.append(invertedRange)
      }
      lowerBound = range.upperBound
    }

    if lowerBound != string.endIndex, lowerBound != string.startIndex {
      invertedRanges.append(lowerBound ..< string.endIndex)
    }

    return invertedRanges
  }

  private static func mergeOverlapping<T: Comparable>(_ input: [Range<T>]) -> [Range<T>] {
    var output: [Range<T>] = []
    let sortedRanges = input.sorted(by: { $0.lowerBound < $1.lowerBound })
    guard let head = sortedRanges.first else { return output }
    let tail = sortedRanges.suffix(from: sortedRanges.index(after: sortedRanges.startIndex))
    var (lower, upper) = (head.lowerBound, head.upperBound)
    for range in tail {
      if range.lowerBound <= upper {
        if range.upperBound > upper {
          upper = range.upperBound
        } else {
          continue
        }
      } else {
        output.append(.init(uncheckedBounds: (lower: lower, upper: upper)))
        (lower, upper) = (range.lowerBound, range.upperBound)
      }
    }
    output.append(.init(uncheckedBounds: (lower: lower, upper: upper)))
    return output
  }
}

extension TaggedString: Hashable {
  
  public static func == (lhs: TaggedString, rhs: TaggedString) -> Bool {
    lhs.input == rhs.input && lhs.preTag == rhs.preTag && lhs.postTag == rhs.postTag
  }
  
  public func hash(into hasher: inout Hasher) {
    input.hash(into: &hasher)
    preTag.hash(into: &hasher)
    postTag.hash(into: &hasher)
  }
  
}

public extension TaggedString {
  
  static func algoliaHighlightedString(_ input: String, options: String.CompareOptions = []) -> Self {
    TaggedString(string: input,
                 preTag: "<em>",
                 postTag: "</em>", options: options) as! Self
  }
  
}
