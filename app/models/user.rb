class User < ApplicationRecord
  has_secure_password

  has_one :person, autosave: true
  accepts_nested_attributes_for :person

  validates :username, presence: true, uniqueness: true
  validates :person, presence: true
  validates :password, presence: true, allow_nil: true

end
