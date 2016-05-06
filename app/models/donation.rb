class Donation < ActiveRecord::Base
  attr_accessible :amount, :date, :name, :remark
end
