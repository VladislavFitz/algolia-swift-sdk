import Foundation
import AlgoliaSearchClient
import UIKit

extension NSAttributedString {

  convenience init?(taggedString: String,
                    taggedAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemBlue],
                    untaggedAttributes: [NSAttributedString.Key: Any]  = [:]) {
    let taggedString = TaggedString.algoliaHighlightedString(taggedString)
    let output = taggedString.output
    let ranges = taggedString.taggedRanges
    let attributedString = NSMutableAttributedString(string: output)
    for (range, isTagged) in ranges {
      let attributes = isTagged ? taggedAttributes : untaggedAttributes
      attributedString.addAttributes(attributes, range: NSRange(range, in: output))
    }
    self.init(attributedString: attributedString)
  }

}
