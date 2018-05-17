ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")

class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_secure_password
  validates :mail,
    presence: true,
    format: {with:/.+@.+/}
  validates :password,
    length: {in: 5..10}
end

class Post < ActiveRecord::Base
  belongs_to :users
  has_many :comments
end


class Comment < ActiveRecord::Base
  belongs_to :users
  belongs_to :posts
end