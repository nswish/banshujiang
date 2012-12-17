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
    result = YAML.load doc
    result.each do |item|
      begin
        WebstorageLink.find(item.id).delete
      rescue ActiveRecord::RecordNotFound
      end

      link = WebstorageLink.new
      link.initialize_dup item
      link.id = item.id
      link.save
    end
  end

end
