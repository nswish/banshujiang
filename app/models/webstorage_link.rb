class WebstorageLink < ActiveRecord::Base
  ### attributes
  attr_accessible :e_book_id, :name, :url

  ### relation
  belongs_to :e_book

  ### public methods
  public
  def WebstorageLink.export
    YAML.dump WebstorageLink.all
  end

  def WebstorageLink.import(doc)
  end

end
