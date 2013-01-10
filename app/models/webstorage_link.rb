class WebstorageLink < ActiveRecord::Base
  ### attributes
  attr_accessible :e_book_id, :name, :url, :ad_link

  ### relation
  belongs_to :e_book

  ### public methods
  public
  def WebstorageLink.export
    YAML.dump WebstorageLink.all
  end

  def WebstorageLink.import(doc)
    WebstorageLink.delete_all

    YAML.load(doc).each do |item|
      link = WebstorageLink.new
      link.initialize_dup item
      link.id = item.id
      link.save
    end
  end
end
