class EBookAttr < ActiveRecord::Base
  attr_accessible :attr_id, :e_book_id, :value

  belongs_to :e_book
  belongs_to :attr

  def self.export
    YAML.dump(Attr.all)
  end

  def self.import(doc)
    EBookAttr.delete_all

    YAML.load(doc).each do |item|
      ebookattr = EBookAttr.new
      ebookattr.initialize_dup item
      ebookattr.id = item.id
      ebookattr.save
    end
  end
end
