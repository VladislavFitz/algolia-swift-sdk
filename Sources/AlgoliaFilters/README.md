#  Algolia Filters

The Filters component provides a user-friendly interface for managing filters and ensures that the resulting filters are valid and can be used with the Algolia search engine. It builds a guaranteed valid string that matches the Algolia SQL-like filters syntax and can be used in the [filters](https://www.algolia.com/doc/api-reference/api-parameters/filters/) search parameter. 

In addition to providing support for various filter types, the Filters component also enables users to group filters together to create more complex conditions. These groups of filters can be conjunctive or disjunctive, meaning they can either require all filters to match (conjunctive) or only one of the filters to match (disjunctive). This flexibility allows developers to create highly specific search queries that return only the most relevant results.

`Filters` eliminates the need for developers to worry about the syntax of their filters and allows them to focus on refining their search queries to build a better search and discovery experience. By handling the technical details of the filtering process, the Filters component simplifies the process of building a search and discovery experience and makes it easier to integrate search functionality into an application.

## Usage

```swift
let filters = Filters()

let andGroup = AndFilterGroup()

andGroup.add("free shipping" as TagFilter)
andGroup.add(FacetFilter(attribute: "size", floatValue: 36))
andGroup.add(NumericFilter(attribute: "price", range: 1...10))

filters.groups["andGroup"] = andGroup

let orGroup = OrFilterGroup<FacetFilter>()

orGroup.add(FacetFilter(attribute: "price", value: 99.90))
orGroup.add(FacetFilter(attribute: "isAvailable", value: true))
orGroup.add(FacetFilter(attribute: "color", value: "red"))

filters.groups["orGroup"] = orGroup

var searchParameters = SearchParameters()
searchParameters.query = "t-shirt"
searchParameters.filters = filters.description

let index = SearchClient(appID: "appID", apiKey: "apiKey").index(withName: "")
let searchResponse = try await index.search(parameters: searchParameters)
```
