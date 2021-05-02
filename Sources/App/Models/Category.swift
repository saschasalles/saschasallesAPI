//
//  File.swift
//  
//
//  Created by Sascha Sallès on 01/05/2021.
//

import Fluent
import Vapor

final class Category: Model {
  static let schema = "categories"

  @ID
  var id: UUID?

  @Field(key: "title")
  var title: String

  @Children(for: \.$category)
  var articles: [Article]

  init() {}

  init(id: UUID? = nil, title: String) {
    self.id = id
    self.title = title
  }
}

extension Category: Content {}
