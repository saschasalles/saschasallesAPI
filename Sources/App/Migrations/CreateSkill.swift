//
//  File.swift
//  
//
//  Created by Sascha Sallès on 01/05/2021.
//

import Fluent


struct CreateSkill: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("skills")
      .id()
      .field("title", .string, .required)
      .field("color", .string, .required)
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("skills").delete()
  }
}
