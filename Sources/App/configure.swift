import Fluent
import FluentPostgresDriver
import Vapor


public func configure(_ app: Application) throws {
  app.databases.use(.postgres(
    hostname: Environment.get("DATABASE_HOST")
      ?? "localhost",
    username: Environment.get("DATABASE_USERNAME")
      ?? "vapor_username",
    password: Environment.get("DATABASE_PASSWORD")
      ?? "vapor_password",
    database: Environment.get("DATABASE_NAME")
      ?? "vapor_database"
  ), as: .psql)


  app.migrations.add(CreateCategory())
  app.migrations.add(CreateArticle())
  app.migrations.add(CreateSkill())
  app.migrations.add(CreateCertificate())
  app.migrations.add(CreateCertificateSkillPivot())
  app.migrations.add(CreateProject())
  app.migrations.add(CreateProjectSkillPivot())
  app.migrations.add(CreateExperience())

  app.logger.logLevel = .debug
  try app.autoMigrate().wait()

  try routes(app)
}
