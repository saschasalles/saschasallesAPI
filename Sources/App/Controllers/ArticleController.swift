//
//  File.swift
//
//
//  Created by Sascha Sallès on 01/05/2021.
//

import Vapor
import Fluent

struct ArticleController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let articlesRoutes = routes.grouped("api", "articles")
    articlesRoutes.get(use: getAllHandler)
    articlesRoutes.post(use: createHandler)
    articlesRoutes.get(":articleID", use: getHandler)
    articlesRoutes.put(":articleID", use: updateHandler)
    articlesRoutes.delete(":articleID", use: deleteHandler)
    articlesRoutes.get("search", use: searchHandler)
    articlesRoutes.get("first", use: getFirstHandler)
    articlesRoutes.get("sorted", use: sortedHandler)
    articlesRoutes.get("category", ":categoryID", use: getArticlesByCategory)
//    articlesRoutes.post(":articleID", "categories", ":categoryID", use: addCategoriesHandler)
//    articlesRoutes.get(":articleID", "categories", use: getCategoriesHandler)
//    articlesRoutes.delete(":articleID", "categories", ":categoryID", use: removeCategoriesHandler)
  }

  func getAllHandler(_ req: Request) -> EventLoopFuture<[Article]> {
    Article.query(on: req.db).all()
  }

  func createHandler(_ req: Request) throws -> EventLoopFuture<Article> {
    let data = try req.content.decode(CreateArticleData.self)
    let article = Article(title: data.title, description: data.description, image: data.image, content: data.content, category: data.categoryID)
    return article.save(on: req.db).map { article }
  }

  func getHandler(_ req: Request) -> EventLoopFuture<Article> {
    Article.find(req.parameters.get("articleID"), on: req.db)
      .unwrap(or: Abort(.notFound))
  }

  func updateHandler(_ req: Request) throws -> EventLoopFuture<Article> {
    let updateData = try req.content.decode(CreateArticleData.self)
    return Article.find(req.parameters.get("articleID"), on: req.db)
      .unwrap(or: Abort(.notFound)).flatMap { article in
      article.title = updateData.title
      article.description = updateData.description
      article.image = updateData.image
      article.content = updateData.content
      return article.save(on: req.db).map {
        article
      }
    }
  }

  func deleteHandler(_ req: Request)
    -> EventLoopFuture<HTTPStatus> {
    Article.find(req.parameters.get("articleID"), on: req.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { article in
        article.delete(on: req.db)
        .transform(to: .noContent)
    }
  }

  func searchHandler(_ req: Request) throws -> EventLoopFuture<[Article]> {
    guard let searchTerm = req
      .query[String.self, at: "term"] else {
      throw Abort(.badRequest)
    }
    return Article.query(on: req.db).group(.or) { or in
      or.filter(\.$title == searchTerm)
      or.filter(\.$content == searchTerm)
      or.filter(\.$description == searchTerm)
    }.all()
  }

  func getFirstHandler(_ req: Request) -> EventLoopFuture<Article> {
    return Article.query(on: req.db)
      .first()
      .unwrap(or: Abort(.notFound))
  }

  func sortedHandler(_ req: Request) -> EventLoopFuture<[Article]> {
    return Article.query(on: req.db).sort(\.$title, .ascending).all()
  }

  func getArticlesByCategory(_ req: Request) -> EventLoopFuture<[Article]> {
    Category.find(req.parameters.get("categoryID"), on: req.db)
    .unwrap(or: Abort(.notFound))
    .flatMap { category in
      category.$articles.query(on: req.db).all()
    }
  }

//
//  func addCategoriesHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
//    let acronymQuery = Acronym.find(req.parameters.get("articleID"), on: req.db).unwrap(or: Abort(.notFound))
//    let categoryQuery = Category.find(req.parameters.get("categoryID"), on: req.db).unwrap(or: Abort(.notFound))
//    return acronymQuery.and(categoryQuery).flatMap { acronym, category in
//      acronym.$categories.attach(category, on: req.db).transform(to: .created)
//    }
//  }
//
//  func getCategoriesHandler(_ req: Request) -> EventLoopFuture<[Category]> {
//    Acronym.find(req.parameters.get("articleID"), on: req.db)
//      .unwrap(or: Abort(.notFound))
//      .flatMap { acronym in
//      acronym.$categories.query(on: req.db).all()
//    }
//  }
//
//  func removeCategoriesHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
//    let acronymQuery = Acronym.find(req.parameters.get("articleID"), on: req.db).unwrap(or: Abort(.notFound))
//    let categoryQuery = Category.find(req.parameters.get("categoryID"), on: req.db).unwrap(or: Abort(.notFound))
//    return acronymQuery.and(categoryQuery).flatMap { acronym, category in
//      acronym.$categories.detach(category, on: req.db).transform(to: .noContent)
//    }
//  }
}

struct CreateArticleData: Content {
  let title: String
  let description: String
  let image: String
  let content: String
  let categoryID: UUID
}
