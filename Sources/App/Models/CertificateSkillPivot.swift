//
//  File.swift
//  
//
//  Created by Sascha Sallès on 01/05/2021.
//

import Fluent
import Foundation

final class CertificateSkillPivot: Model {
  static let schema = "certificate-skill-pivot"

  @ID
  var id: UUID?

  @Parent(key: "certificateID")
  var certificate: Certificate

  @Parent(key: "skillID")
  var skill: Skill

  init() {}

  init(id: UUID? = nil, skill: Skill, certificate: Certificate) throws {
    self.id = id
    self.$certificate.id = try certificate.requireID()
    self.$skill.id = try skill.requireID()
  }
}

