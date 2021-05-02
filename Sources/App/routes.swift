import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

  let categoryController = CategoryController()
  try app.register(collection: categoryController)
  
  let articleController = ArticleController()
  try app.register(collection: articleController)

  let skillController = SkillController()
  try app.register(collection: skillController)

  let certificateController = CertificateController()
  try app.register(collection: certificateController)

  let experienceController = ExperienceController()
  try app.register(collection: experienceController)

  let projectController = ProjectController()
  try app.register(collection: projectController)


}
