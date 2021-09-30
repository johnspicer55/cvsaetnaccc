//
//  Flkr.swift
//  CVSDemoApp
//
//  Created by John Spicer on 2021-09-29.
//

import Foundation

struct Flkr: Decodable {
  let title: String
  let link: String
  let description: String
  let modified: String
  let generator: String
  let items: [FlkrItem]
}
