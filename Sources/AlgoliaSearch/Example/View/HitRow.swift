//
//  HitRow.swift
//  
//
//  Created by Vladislav Fitc on 07.05.2023.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
public struct HitRow: View {

  let hit: InstantSearchHit

  public var body: some View {
    HStack {
      AsyncImage(url: hit.image, content: { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
      }, placeholder: {
        ProgressView()
      })
      .frame(width: 40, height: 40)
      .padding(.trailing, 10)
      VStack {
        HStack {
          if let highlightedName = hit._highlightResult["name"] {
            Text(taggedString: highlightedName)
          }
          Spacer()
        }
        HStack {
          Text(String(format: "$%.2f", hit.price))
          Spacer()

        }
      }
      Spacer()
    }
  }

}
