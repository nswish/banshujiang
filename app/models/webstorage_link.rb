class WebstorageLink < ActiveRecord::Base
  attr_accessible :e_book_id, :name, :url

  belongs_to :e_book
end
