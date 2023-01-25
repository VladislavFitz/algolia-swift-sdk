import Foundation

public struct Settings: Decodable {
  /**
   The complete list of attributes that will be used for searching.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/searchableAttributes/?language=swift)
   */
  let searchableAttributes: [SearchableAttribute]?

  /**
   The complete list of attributes that will be used for faceting.
   - Engine default: []
   - [Documentation](https://www.algolia.com/doc/api-reference/api-parameters/attributesForFaceting/?language=swift)
   */
  let attributesForFaceting: [AttributeForFaceting]?
}
