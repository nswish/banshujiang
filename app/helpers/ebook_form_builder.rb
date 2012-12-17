#-*- encoding: utf-8 -*-
class EbookFormBuilder < ActionView::Helpers::FormBuilder
	def webstorage_select(method, options={}, html_options={})
    value_set_select('webstorages', method)
	end

  def publisher_select(method, options={}, html_options={})
    value_set_select('publishers', method)
  end

  def programming_language_select(method, options={}, html_options={})
    value_set_select('programming_languages', method)
  end

  private
  def value_set_select(value_set, method, options={}, html_options={})
    header = ValueSetHeader.where(:name=>value_set).first
		return select(method, header ? header.name_value_array : [],
									options, html_options)
  end
end
