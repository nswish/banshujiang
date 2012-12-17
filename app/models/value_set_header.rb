class ValueSetHeader < ActiveRecord::Base
  attr_accessible :name

  has_many :value_set_bodies

  public 
  def ValueSetHeader.export
    YAML.dump ValueSetHeader.all
  end

  def ValueSetHeader.import(doc)
  end
end
