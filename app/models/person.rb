class Person < ApplicationRecord
  has_one :name, autosave: true
  accepts_nested_attributes_for :name
end
