class ValueSetBody < ActiveRecord::Base
  attr_accessible :name, :value, :value_set_header_id

  belongs_to :value_set_header
end
