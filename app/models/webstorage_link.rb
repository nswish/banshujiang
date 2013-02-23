class WebstorageLink < ActiveRecord::Base
  require 'imexportable'
  extend ImExportable

  ### attributes
  attr_accessible :e_book_id, :name, :url, :ad_link, :download_count

  ### relation
  belongs_to :e_book
end
