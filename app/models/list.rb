class List < ActiveRecord::Base
  require 'imexportable'
  extend ImExportable

  has_many :e_books
  # attr_accessible :title, :body
end
