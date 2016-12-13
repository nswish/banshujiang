#-*- encoding:utf-8 -*-
module EBooksHelper
  def standard_file_name(ebook)
    "#{ebook.name.delete ':/*?|,#'}-#{ebook.publish_year}-#{ebook.language}版"
  end
end
