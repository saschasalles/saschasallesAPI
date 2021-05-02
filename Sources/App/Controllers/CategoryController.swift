//
//  File.swift
//
//
//  Created by Sascha Sallès on 01/05/2021.
//

import Vapor
import Fluent

struct CategoryController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let categoriesRoutes = routes.grouped("api", "categories")
    categoriesRoutes.get(use: getAllHandler)
    categoriesRoutes.post(use: createHandler)
    categoriesRoutes.get(":categoryID", use: getHandler)
    categoriesRoutes.put(":categoryID", use: updateHandler)
    categoriesRoutes.delete(":categoryID", use: deleteHandler)
    categoriesRoutes.get("search", use: searchHandler)
    categoriesRoutes.get("first", use: getFirstHandler)
    categoriesRoutes.get("sorted", use: sortedHandler)
    categoriesRoutes.get(":categoryID", "articles", use: getArticlesHandler)
  }

  func getAllHandler(_ req: Request) -> EventLoopFuture<[Category]> {
    Category.query(on: req.db).all()
  }

  func createHandler(_ req: Request) throws -> EventLoopFuture<Category> {
    let data = try req.content.decode(CreateCategoryData.self)
    let category = Category(title: data.title)
    return category.save(on: req.db).map { category }
  }

  func getHandler(_ req: Request) -> EventLoopFuture<Category> {
    Category.find(req.parameters.get("categoryID"), on: req.db)
      .unwrap(or: Abort(.notFound))
  }

  func updateHandler(_ req: Request) throws -> EventLoopFuture<Category> {
    let updateData = try req.content.decode(CreateCategoryData.self)
    return Category.find(req.parameters.get("categoryID"), on: req.db)
      .unwrap(or: Abort(.notFound)).flatMap { category in
      category.title = updateData.title
      return category.save(on: req.db).map {
        category
      }
    }
  }

  func deleteHandler(_ req: Request)
    -> EventLoopFuture<HTTPStatus> {
    Category.find(req.parameters.get("categoryID"), on: req.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { category in
      category.delete(on: req.db)
        .transform(to: .noContent)
    }
  }

  func searchHandler(_ req: Request) throws -> EventLoopFuture<[Category]> {
    guard let searchTerm = req
      .query[String.self, at: "term"] else {
      throw Abort(.badRequest)
    }
    return Category.query(on: req.db).group(.or) { or in
      or.filter(\.$title == searchTerm)
    }.all()
  }

  func getFirstHandler(_ req: Request) -> EventLoopFuture<Category> {
    return Category.query(on: req.db)
      .first()
      .unwrap(or: Abort(.notFound))
  }

  func sortedHandler(_ req: Request) -> EventLoopFuture<[Category]> {
    return Category.query(on: req.db).sort(\.$title, .ascending).all()
  }

  func getArticlesHandler(_ req: Request) -> EventLoopFuture<[Article]> {
    Category.find(req.parameters.get("categoryID"), on: req.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { category in
      category.$articles.query(on: req.db).all()
    }
  }
}

struct CreateCategoryData: Content {
  let title: String
}
