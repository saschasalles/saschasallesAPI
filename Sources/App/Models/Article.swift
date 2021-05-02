import Fluent
import Vapor

final class Article: Model {
  static let schema = "articles"

  @ID
  var id: UUID?

  @Field(key: "title")
  var title: String

  @Field(key: "description")
  var description: String

  @Field(key: "image")
  var image: String

  @Field(key: "content")
  var content: String

  @Parent(key: "categoryID")
  var category: Category

  init() {}

  init(id: UUID? = nil, title: String, description: String, image: String, content: String, category: Category.IDValue) {
    self.id = id
    self.title = title
    self.description = description
    self.image = image
    self.content = content
    self.$category.id = category
  }
}

extension Article: Content {}
