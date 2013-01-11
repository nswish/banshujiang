#-*- encoding: utf-8 -*-
class EBook < ActiveRecord::Base
  require 'imexportable'
  extend ImExportable

  ### attributes
  attr_accessible :author, :format, :image_large_file, :image_small, :language, :name, :publish_year

  ### relation
  has_many :webstorage_links
  has_many :download_priviledges
  has_many :users, :through => :download_priviledges
  has_many :e_book_attrs, :dependent => :destroy, :autosave => true
  has_many :attrs, :through => :e_book_attrs

  ### constants
	IMAGE_DIR = 'data_images'

  ### trigger
	after_save :save_upload_image_large

  ### public methods
  public
	def image_large_file=(file_data)
		unless file_data.blank?
			@file_data = file_data
		end
	end

  def related_ebooks(limit=8)
    condition = ["", []]
    self.e_book_attrs.all.collect do |ebookattr|
      condition[0] << 'or attr_id = ? and value = ? '
      condition[1] << ebookattr.attr_id << ebookattr.value
    end
    
    result = EBookAttr.select(:e_book_id).uniq.where( '('+condition[0][3..-1]+') and e_book_id != ?', *(condition[1]<<self.id) ).limit(limit).collect do |ebookattr|
      ebookattr.e_book
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
