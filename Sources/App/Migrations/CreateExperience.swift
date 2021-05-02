//
//  File.swift
//  
//
//  Created by Sascha Sallès on 02/05/2021.
//

import Fluent

struct CreateExperience: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("experiences")
      .id()
      .field("jobTitle", .string, .required)
      .field("companyName", .string, .required)
      .field("companyLogo", .string, .required)
      .field("startDate", .date, .required)
      .field("endDate", .date)
      .field("isCurrent", .bool, .required)
      .field("content", .string, .required)
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("certificates").delete()
  }
}
