//
//  File.swift
//  
//
//  Created by Sascha Sallès on 02/05/2021.
//

import Foundation
import Fluent

struct CreateProjectSkillPivot: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("project-skill-pivot")
      .id()
      .field("projectID", .uuid, .required, .references("projects", "id", onDelete: .setNull))
      .field("skillID", .uuid, .required, .references("skills", "id", onDelete: .setNull))
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("project-skill-pivot").delete()
  }
}
