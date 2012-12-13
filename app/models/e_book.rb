class EBook < ActiveRecord::Base
  attr_accessible :author, :format, :image_large_file, :image_small, :language, :name, :publish_year, :publisher, :programming_language
	attr_accessible :download_name, :download_url, :download_name_2, :download_url_2

  has_many :webstorage_links

	IMAGE_DIR = 'data_images'

	def image_large_file=(file_data)
		unless file_data.blank?
			@file_data = file_data
		end
	end

	after_save :save_upload_image_large

	private
	def save_upload_image_large
		if @file_data
			# if self.image_large has value then test the file exist? and delete it
			unless self.image_large.blank?
				file_path = "#{ENV['OPENSHIFT_REPO_DIR']}/public/#{self.image_large}"
				if File::file? file_path
					File::delete file_path
				end
			end

			# write file to dir and link to it
			filename_ext = @file_data.original_filename.split('.').last.downcase
			self.image_large = "/#{IMAGE_DIR}/#{id}.#{filename_ext}" 

			file_path = "#{ENV['OPENSHIFT_REPO_DIR']}/public/#{self.image_large}"
			File.open(file_path, 'wb') do |f|
				f.write(@file_data.read)
			end

			@file_data = nil
			self.save
		end
	end
end
