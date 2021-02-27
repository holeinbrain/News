//
//  Article.swift
//  News
//
//  Created by Anton Levin on 26.02.2021.
//

import Foundation

struct Article: Codable {
  let title: String
  let author: String?
  let description: String?
  let name: String?
  let url: URL?
  let urlToImage: URL?
  let publishedAt: Date
}
