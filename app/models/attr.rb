class Attr < ActiveRecord::Base
  require 'imexportable'
  extend ImExportable

  attr_accessible :name, :kind, :title

  has_many :e_books, :through => :e_book_attrs
  has_many :e_book_attrs
  has_one  :value_set_header

  after_save :refresh_cache

  def self.id_title_hash
		result = {}
		Attr.all.each do |attr|
			result[attr.id] = attr.title
		end
		return result
  end
  
  def self.id_name_hash
 		result = {}
		Attr.all.each do |attr|
			result[attr.id] = attr.name
		end
		return result
  end

	NameCache = self.id_name_hash
  TitleCache = self.id_title_hash

  def self.name_id_array
    Attr.all.collect do |attr|
      [attr.name, attr.id]
    end
  end

  def self.categories
    (Attr.includes(:value_set_header).all.select do |attr| attr.value_set_header end).collect do |attr|
      attr.value_set_header
    end
  end

  private
  def refresh_cache
    Attr::NameCache.clear.merge! Attr.id_name_hash
    Attr::TitleCache.clear.merge! Attr.id_title_hash
  end
end
