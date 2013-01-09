class EBookAttr < ActiveRecord::Base
  attr_accessible :attr_id, :e_book_id, :value

  belongs_to :e_book
  belongs_to :attr
end
