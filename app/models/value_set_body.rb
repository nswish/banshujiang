class ValueSetBody < ActiveRecord::Base
  attr_accessible :name, :value, :value_set_header_id

  belongs_to :value_set_header

  public
  def ValueSetBody.export
    YAML.dump ValueSetBody.all
  end

  def ValueSetBody.import(doc)
    ValueSetBody.all.each do |body|
      body.delete
    end

    YAML.load(doc).each do |item|
      body = ValueSetBody.new
      body.initialize_dup item
      body.id = item.id
      body.save
    end
  end
end
