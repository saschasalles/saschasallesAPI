//
//  File.swift
//  
//
//  Created by Sascha Sallès on 01/05/2021.
//

import Fluent
import Vapor

final class Certificate: Model {
  static let schema = "certificates"

  @ID
  var id: UUID?

  @Field(key: "title")
  var title: String

  @Field(key: "image")
  var image: String

  @Siblings(through: CertificateSkillPivot.self, from: \.$certificate, to: \.$skill)
  var skills: [Skill]


  init() {}

  init(id: UUID? = nil, title: String, image: String) {
    self.id = id
    self.title = title
    self.image = image

  }
}

extension Certificate: Content {}
