class ValueSetHeader < ActiveRecord::Base
  attr_accessible :name

  has_many :value_set_bodies
end
