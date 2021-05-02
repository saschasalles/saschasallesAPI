//
//  File.swift
//  
//
//  Created by Sascha Sallès on 01/05/2021.
//

import Fluent

struct CreateCertificate: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("certificates")
      .id()
      .field("title", .string, .required)
      .field("image", .string, .required)
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("certificates").delete()
  }
}
