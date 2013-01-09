class Attr < ActiveRecord::Base
  attr_accessible :name, :type

  has_many :e_books, :through => :e_book_attrs
  has_many :e_book_attrs
  has_one  :value_set_header

	NameCache = begin
		result = {}
		Attr.all.each do |attr|
			result[attr.id] = attr.name
		end
		result
	end

	TitleCache = begin
		result = {}
		Attr.all.each do |attr|
			result[attr.id] = attr.title
		end
		result
	end

  def self.name_id_array
    Attr.all.collect do |attr|
      [attr.name, attr.id]
    end
  end
end
