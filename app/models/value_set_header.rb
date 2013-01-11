class ValueSetHeader < ActiveRecord::Base
  require 'imexportable'
  extend ImExportable

  attr_accessible :name, :title, :is_category, :attr_id

  has_many :value_set_bodies

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
