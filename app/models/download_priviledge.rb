class DownloadPriviledge < ActiveRecord::Base
  attr_accessible :e_book_id, :expiration_at, :user_id
  belongs_to :e_book
  belongs_to :user
end
