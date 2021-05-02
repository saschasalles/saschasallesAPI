//
//  File.swift
//  
//
//  Created by Sascha Sallès on 01/05/2021.
//

import Fluent
import Vapor

final class Skill: Model {
  static let schema = "skills"

  @ID
  var id: UUID?

  @Field(key: "title")
  var title: String

  @Field(key: "color")
  var color: String

  init() {}

  init(id: UUID? = nil, title: String, color: String) {
    self.id = id
    self.title = title
    self.color = color

  }
}

extension Skill: Content {}
