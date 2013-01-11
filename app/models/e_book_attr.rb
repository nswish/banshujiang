class EBookAttr < ActiveRecord::Base
  require 'imexportable'
  extend ImExportable

  attr_accessible :attr_id, :e_book_id, :value

  belongs_to :e_book
  belongs_to :attr
end
