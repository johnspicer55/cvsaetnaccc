//
//  FlkrItem.swift
//  CVSDemoApp
//
//  Created by John Spicer on 2021-09-29.
//

import Foundation

struct FlkrItem: Decodable {
  let title: String
  let link: String
  let media: [String: String]
  let date_taken: String
  let description: String
  let published: String
  let author: String
  let author_id: String
  let tags: String
}
