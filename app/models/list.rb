class List < ActiveRecord::Base
  has_many :e_books
  # attr_accessible :title, :body
end
