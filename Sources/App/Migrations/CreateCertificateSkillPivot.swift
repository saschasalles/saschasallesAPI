//
//  File.swift
//  
//
//  Created by Sascha Sallès on 01/05/2021.
//

import Foundation
import Fluent

struct CreateCertificateSkillPivot: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("certificate-skill-pivot")
      .id()
      .field("certificateID", .uuid, .required, .references("certificates", "id", onDelete: .cascade))
      .field("skillID", .uuid, .required, .references("skills", "id", onDelete: .cascade))
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("certificate-skill-pivot").delete()
  }
}
