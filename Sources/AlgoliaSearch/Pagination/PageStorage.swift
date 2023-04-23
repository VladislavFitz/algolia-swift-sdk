//
//  PageStorage.swift
//  
//
//  Created by Vladislav Fitc on 23.04.2023.
//

import Foundation

actor PageStorage<Page> {
  
  var pages: [Page] = []
  
  func append(_ page: Page) {
    pages.append(page)
  }
  
  func prepend(_ page: Page) {
    pages.insert(page, at: 0)
  }
  
  func clear() {
    pages.removeAll()
  }

}
