//
//  File.swift
//  
//
//  Created by Sascha Sallès on 01/05/2021.
//

import Fluent

struct CreateArticle: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("articles")
      .id()
      .field("title", .string, .required)
      .field("description", .string, .required)
      .field("image", .string, .required)
      .field("content", .string, .required)
      .field("categoryID", .uuid, .required, .references("categories", "id"))
      .unique(on: "categoryID")
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("articles").delete()
  }
}
