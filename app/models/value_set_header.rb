class ValueSetHeader < ActiveRecord::Base
  attr_accessible :name

  has_many :value_set_bodies

  public 
  def ValueSetHeader.export
    YAML.dump ValueSetHeader.all
  end

  def ValueSetHeader.import(doc)
    ValueSetHeader.all.each do |header|
      header.delete
    end

    YAML.load(doc).each do |item|
      header = ValueSetHeader.new
      header.initialize_dup item
      header.id = item.id
      header.save
    end
  end

  def name_value_array
    self.value_set_bodies.collect do |item|
      [ item.name, item.value ]
    end
  end

  def value_array
    self.value_set_bodies.collect do |item|
      [ item.value ]
    end
  end

  def id_value_array
    self.value_set_bodies.collect do |item|
      [ item.id, item.value ]
    end
  end
end
