//
//  File.swift
//
//
//  Created by Sascha Sallès on 02/05/2021.
//

import Vapor
import Fluent

struct ExperienceController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let experiencesRoutes = routes.grouped("api", "experiences")
    experiencesRoutes.get(use: getAllHandler)
    experiencesRoutes.post(use: createHandler)
    experiencesRoutes.get(":experienceID", use: getHandler)
    experiencesRoutes.put(":experienceID", use: updateHandler)
    experiencesRoutes.delete(":experienceID", use: deleteHandler)
    experiencesRoutes.get("search", use: searchHandler)
    experiencesRoutes.get("first", use: getFirstHandler)
    experiencesRoutes.get("sorted", use: sortedHandler)
  }

  func getAllHandler(_ req: Request) -> EventLoopFuture<[Experience]> {
    Experience.query(on: req.db).all()
  }

  func createHandler(_ req: Request) throws -> EventLoopFuture<Experience> {
    let data = try req.content.decode(CreateExperienceData.self)
    let experience = Experience(jobTitle: data.jobTitle,
                                companyName: data.companyName,
                                companyLogo: data.companyLogo,
                                startDate: data.startDate,
                                isCurrent: data.isCurrent,
                                description: data.description)
    return experience.save(on: req.db).map { experience }
  }

  func getHandler(_ req: Request) -> EventLoopFuture<Experience> {
    Experience.find(req.parameters.get("experienceID"), on: req.db)
      .unwrap(or: Abort(.notFound))
  }

  func updateHandler(_ req: Request) throws -> EventLoopFuture<Experience> {
    let updateData = try req.content.decode(CreateExperienceData.self)
    return Experience.find(req.parameters.get("experienceID"), on: req.db)
      .unwrap(or: Abort(.notFound)).flatMap { experience in
      experience.jobTitle = updateData.jobTitle
      experience.companyLogo = updateData.companyLogo
      experience.companyName = updateData.companyName
      experience.startDate = updateData.startDate
      experience.endDate = updateData.endDate
      experience.isCurrent = updateData.isCurrent
      experience.description = experience.description
      return experience.save(on: req.db).map {
        experience
      }
    }
  }

  func deleteHandler(_ req: Request)
    -> EventLoopFuture<HTTPStatus> {
    Experience.find(req.parameters.get("experienceID"), on: req.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { experience in
      experience.delete(on: req.db)
        .transform(to: .noContent)
    }
  }

  func searchHandler(_ req: Request) throws -> EventLoopFuture<[Experience]> {
    guard let searchTerm = req
      .query[String.self, at: "term"] else {
      throw Abort(.badRequest)
    }
    return Experience.query(on: req.db).group(.or) { or in
      or.filter(\.$jobTitle == searchTerm)
    }.all()
  }

  func getFirstHandler(_ req: Request) -> EventLoopFuture<Experience> {
    return Experience.query(on: req.db)
      .first()
      .unwrap(or: Abort(.notFound))
  }

  func sortedHandler(_ req: Request) -> EventLoopFuture<[Experience]> {
    return Experience.query(on: req.db).sort(\.$jobTitle, .ascending).all()
  }

}

struct CreateExperienceData: Content {
  let jobTitle: String
  let companyName: String
  let companyLogo: String
  let startDate: Date
  let endDate: Date?
  let isCurrent: Bool
  let description: String
}
