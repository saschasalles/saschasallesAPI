//
//  File.swift
//
//
//  Created by Sascha Sallès on 01/05/2021.
//

import Fluent
import Vapor

final class Experience: Model {
  static let schema = "experiences"

  @ID
  var id: UUID?

  @Field(key: "jobTitle")
  var jobTitle: String

  @Field(key: "companyName")
  var companyName: String

  @Field(key: "companyLogo")
  var companyLogo: String

  @Field(key: "startDate")
  var startDate: Date

  @OptionalField(key: "endDate")
  var endDate: Date?

  @Field(key: "isCurrent")
  var isCurrent: Bool

  @Field(key: "description")
  var description: String


  init() { }

  init(id: UUID? = nil,
       jobTitle: String,
       companyName: String,
       companyLogo: String,
       startDate: Date,
       endDate: Date? = nil,
       isCurrent: Bool,
       description: String) {
    self.id = id
    self.jobTitle = jobTitle
    self.companyName = companyName
    self.companyLogo = companyLogo
    self.startDate = startDate
    self.endDate = endDate
    self.isCurrent = isCurrent
    self.description = description
  }
}

extension Experience: Content { }
