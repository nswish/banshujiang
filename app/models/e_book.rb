#-*- encoding: utf-8 -*-
class EBook < ActiveRecord::Base
  require 'imexportable'
  extend ImExportable

  require 'RMagick'
  include Magick

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

  def description
    attr_desc = (self.e_book_attrs.includes(:attr).collect do |e_book_attr|
      e_book_attr.attr.title + ": " + e_book_attr.value
    end).join("; ")
    return "作者: #{self.author}; 语言: #{self.language}; 格式: #{self.format}; 出版年份: #{self.publish_year}; " + attr_desc
  end

  def self.search(search_words)
    require 'rmmseg'
    RMMSeg::Dictionary.load_dictionaries

    search_word_array = []
    ebook_result = []

    # 分词
    algor = RMMSeg::Algorithm.new(search_words)
    loop do
      tok = algor.next_token
      break if tok.nil?
      search_word_array << tok.text.downcase.force_encoding("UTF-8")
    end

		# 全部匹配
    matched_all_ids = []
    TextForSearchCache.each do |item|
      matched_words = search_word_array.select { |word| item[:text][word] }
			matched_all_ids << item[:id] if matched_words.length == search_word_array.length
    end
    ebook_result.concat EBook.where(:id=>matched_all_ids)

		# 部分匹配
    matched_parts_ids = []
    TextForSearchCache.each do |item|
      matched_words = search_word_array.select { |word| item[:text][word] }
      matched_parts_ids << item[:id] if matched_words.length > 0
    end
    matched_parts_ids = matched_parts_ids - matched_all_ids
    ebook_result.concat EBook.where(:id=>matched_parts_ids)

    return ebook_result[1..35]
  end

  def related_ebooks(limit=8)
    ebook_result = []
    id_result = []

    self.e_book_attrs.order('id desc').each do |e_book_attr|
      ids = EBookAttr.includes(:e_book).where(:attr_id=>e_book_attr.attr_id, :value=>e_book_attr.value).collect { |item|
        item.e_book.id
      }
      ids = ids - id_result - [self.id]

      if ids.length > 0 then
        ebook_result.concat EBook.where(:id=>ids).all
      end
    end

    return ebook_result[1..8]
  end

  def self.load_text_for_search_cache
    EBook.includes(:e_book_attrs).order('id desc').all.collect do |ebook|
      attrs = ebook.e_book_attrs.collect do |attr|
        attr.value.downcase
      end
      {:id=>ebook.id, :text=>"#{ebook.name.downcase} #{attrs.join ' '}"}
    end
  end

  TextForSearchCache = self.load_text_for_search_cache

  def self.refresh_cache
    EBook::TextForSearchCache.clear.concat EBook.load_text_for_search_cache
  end

	private
	def save_upload_image_large
		if @file_data
			# if self.image_large has value then test the file exist? and delete it
			unless self.image_large.blank?
				file_path = "#{ENV['OPENSHIFT_REPO_DIR']}/public/#{self.image_large}"
        File::delete file_path if File::file? file_path

        file_path_small = "#{ENV['OPENSHIFT_REPO_DIR']}/public/#{self.image_small}"
        File::delete file_path_small if File::file? file_path_small
			end

			# write file to dir and link to it
			filename_ext = @file_data.original_filename.split('.').last.downcase
			self.image_large = "/#{IMAGE_DIR}/#{id}.#{filename_ext}" 
			self.image_small = "/#{IMAGE_DIR}/#{id}s.#{filename_ext}" 

			file_path = "#{ENV['OPENSHIFT_REPO_DIR']}/public/#{self.image_large}"
			file_path_small = "#{ENV['OPENSHIFT_REPO_DIR']}/public/#{self.image_small}"

			File.open(file_path, 'wb') do |f|
				f.write(@file_data.read)
			end

      image_file = ImageList.new(file_path)
      image_file.resize(420,560).write(file_path)
      image_file.resize(160,213).write(file_path_small)

			@file_data = nil
			self.save
		end
	end

end
