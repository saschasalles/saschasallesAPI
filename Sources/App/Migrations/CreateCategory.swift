//
//  File.swift
//  
//
//  Created by Sascha Sallès on 01/05/2021.
//


import Fluent

struct CreateCategory: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("categories")
      .id()
      .field("title", .string, .required)
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("categories").delete()
  }
}
