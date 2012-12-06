class EBook < ActiveRecord::Base
  attr_accessible :author, :download_name, :download_url, :format, :image_large, :image_small, :language, :name, :publish_data, :publisher
end
