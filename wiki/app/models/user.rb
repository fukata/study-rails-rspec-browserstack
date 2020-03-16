class User < ApplicationRecord
  has_many :items

  validates :name, length: {minimum: 3, maximum: 20}, uniqueness: true
  validates :password, length: {minimum: 4, maximum: 128}
end
