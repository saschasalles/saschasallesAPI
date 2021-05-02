//
//  File.swift
//  
//
//  Created by Sascha Sallès on 01/05/2021.
//

import Fluent
import Vapor

final class Project: Model {
  static let schema = "projects"

  @ID
  var id: UUID?

  @Field(key: "title")
  var title: String

  @Field(key: "image")
  var image: String

  @Field(key: "content")
  var content: String

  @Siblings(through: ProjectSkillPivot.self, from: \.$project, to: \.$skill)
  var skills: [Skill]


  init() {}

  init(id: UUID? = nil, title: String, image: String, content: String) {
    self.id = id
    self.title = title
    self.image = image
    self.content = content
  }
}

extension Project: Content {}
