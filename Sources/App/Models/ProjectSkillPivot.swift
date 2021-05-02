//
//  File.swift
//  
//
//  Created by Sascha Sallès on 02/05/2021.
//

import Fluent
import Foundation

final class ProjectSkillPivot: Model {
  static let schema = "project-skill-pivot"

  @ID
  var id: UUID?

  @Parent(key: "projectID")
  var project: Project

  @Parent(key: "skillID")
  var skill: Skill

  init() {}

  init(id: UUID? = nil, skill: Skill, project: Project) throws {
    self.id = id
    self.$project.id = try project.requireID()
    self.$skill.id = try skill.requireID()
  }
}

