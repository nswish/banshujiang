class EBook < ActiveRecord::Base
  attr_accessible :author, :download_name, :download_url, :format, :image_large_file, :image_small, :language, :name, :publish_year, :publisher

	IMAGE_DIR = '/data_images'

	def image_large_file=(file_data)
		unless file_data.blank?
			@file_data = file_data
			filename_ext = file_data.original_filename.split('.').last.downcase
			self.image_large = "#{IMAGE_DIR}/#{id}.#{filename_ext}" 
		end
	end

	after_save :save_upload_image_large

	private
	def save_upload_image_large
		if @file_data
			file_path = "#{ENV['OPENSHIFT_REPO_DIR']}/public/#{self.image_large}"
			File.open(file_path, 'wb') do |f|
				f.write(@file_data.read)
			end
			@file_data = nil
		end
	end
end
