class Feedback < ActiveRecord::Base
  attr_accessible :content, :user_id, :user_name

  belongs_to :user
end
