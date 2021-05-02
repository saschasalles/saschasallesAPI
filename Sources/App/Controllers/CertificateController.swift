//
//  File.swift
//
//
//  Created by Sascha Sallès on 01/05/2021.
//

import Vapor
import Fluent

struct CertificateController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let certificatesRoutes = routes.grouped("api", "certificates")
    certificatesRoutes.get(use: getAllHandler)
    certificatesRoutes.post(use: createHandler)
    certificatesRoutes.get(":certificateID", use: getHandler)
    certificatesRoutes.put(":certificateID", use: updateHandler)
    certificatesRoutes.delete(":certificateID", use: deleteHandler)
    certificatesRoutes.get("search", use: searchHandler)
    certificatesRoutes.get("first", use: getFirstHandler)
    certificatesRoutes.get("sorted", use: sortedHandler)
    certificatesRoutes.post(":certificateID", "skills", ":skillID", use: addSkillHandler)
    certificatesRoutes.get(":certificateID", "skills", use: getSkillsHandler)
    certificatesRoutes.delete(":certificateID", "skills", ":skillID", use: removeSkillHandler)
  }

  func getAllHandler(_ req: Request) -> EventLoopFuture<[Certificate]> {
    Certificate.query(on: req.db).all()
  }

  func createHandler(_ req: Request) throws -> EventLoopFuture<Certificate> {
    let data = try req.content.decode(CreateCertificateData.self)
    let certificate = Certificate(title: data.title, image: data.image)
    return certificate.save(on: req.db).map { certificate }
  }

  func getHandler(_ req: Request) -> EventLoopFuture<Certificate> {
    Certificate.find(req.parameters.get("certificateID"), on: req.db)
      .unwrap(or: Abort(.notFound))
  }

  func updateHandler(_ req: Request) throws -> EventLoopFuture<Certificate> {
    let updateData = try req.content.decode(CreateCertificateData.self)
    return Certificate.find(req.parameters.get("certificateID"), on: req.db)
      .unwrap(or: Abort(.notFound)).flatMap { certificate in
      certificate.title = updateData.title
      certificate.image = updateData.image
      return certificate.save(on: req.db).map {
        certificate
      }
    }
  }

  func deleteHandler(_ req: Request)
    -> EventLoopFuture<HTTPStatus> {
    Certificate.find(req.parameters.get("certificateID"), on: req.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { certificate in
      certificate.delete(on: req.db)
        .transform(to: .noContent)
    }
  }

  func searchHandler(_ req: Request) throws -> EventLoopFuture<[Certificate]> {
    guard let searchTerm = req
      .query[String.self, at: "term"] else {
      throw Abort(.badRequest)
    }
    return Certificate.query(on: req.db).group(.or) { or in
      or.filter(\.$title == searchTerm)
    }.all()
  }

  func getFirstHandler(_ req: Request) -> EventLoopFuture<Certificate> {
    return Certificate.query(on: req.db)
      .first()
      .unwrap(or: Abort(.notFound))
  }

  func sortedHandler(_ req: Request) -> EventLoopFuture<[Certificate]> {
    return Certificate.query(on: req.db).sort(\.$title, .ascending).all()
  }


  func addSkillHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
    let certificateQuery = Certificate.find(req.parameters.get("certificateID"), on: req.db).unwrap(or: Abort(.notFound))
    let skillQuery = Skill.find(req.parameters.get("skillID"), on: req.db).unwrap(or: Abort(.notFound))
    return certificateQuery.and(skillQuery).flatMap { certificate, skill in
      certificate.$skills.attach(skill, on: req.db).transform(to: .created)
    }
  }

  func getSkillsHandler(_ req: Request) -> EventLoopFuture<[Skill]> {
    Certificate.find(req.parameters.get("certificateID"), on: req.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { certificate in
      certificate.$skills.query(on: req.db).all()
    }
  }

  func removeSkillHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
    let certificateQuery = Certificate.find(req.parameters.get("certificateID"), on: req.db).unwrap(or: Abort(.notFound))
    let skillQuery = Skill.find(req.parameters.get("skillID"), on: req.db).unwrap(or: Abort(.notFound))
    return certificateQuery.and(skillQuery).flatMap { certificate, skill in
      certificate.$skills.detach(skill, on: req.db).transform(to: .noContent)
    }
  }
}

struct CreateCertificateData: Content {
  let title: String
  let image: String
}
