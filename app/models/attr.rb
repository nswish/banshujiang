class Attr < ActiveRecord::Base
  attr_accessible :name, :type

  has_many :e_books, :through => :e_book_attrs
  has_many :e_book_attrs
  has_one  :value_set_header

  def self.name_id_array
    Attr.all.collect do |attr|
      [attr.name, attr.id]
    end
  end
end
