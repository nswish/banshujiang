#-*- encoding: utf-8 -*-
class EBook < ActiveRecord::Base
  ### attributes
  attr_accessible :author, :format, :image_large_file, :image_small, :language, :name, :publish_year, :publisher, :programming_language

  ### relation
  has_many :webstorage_links

  ### constants
	IMAGE_DIR = 'data_images'

  ### trigger
	after_save :save_upload_image_large

  ### public methods
	def image_large_file=(file_data)
		unless file_data.blank?
			@file_data = file_data
		end
	end

  def EBook.export
    YAML.dump(EBook.all)
  end

	def EBook.import(doc, url)
		result = YAML.load doc
		result.each do |item|
      begin
        EBook.find(item.id)
      rescue ActiveRecord::RecordNotFound
  			ebook = EBook.new
        ebook.initialize_dup item 
        ebook.id = item.id
        ebook.save

        if url and ebook.image_large then
          require 'net/http'
          uri = URI url
          image_uri = uri.scheme+'://'+uri.host+':'+uri.port.to_s+ebook.image_large
          file_path = "#{ENV['OPENSHIFT_REPO_DIR']}/public/#{ebook.image_large}"
          File.open(file_path, 'wb') do |f|
            f.write(Net::HTTP.get URI(image_uri))
          end
        end
      end
    end
  end

  ### private methods
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
