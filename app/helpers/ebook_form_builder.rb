#-*- encoding: utf-8 -*-
class EbookFormBuilder < ActionView::Helpers::FormBuilder
  def webstorage_select(method, options={}, html_options={})
    value_set_select(ActiveSupport::Inflector.pluralize(method), method)
  end

  def category_select(method, options={}, html_options={})
    value_set_select(ActiveSupport::Inflector.pluralize(method), method)
  end

  private
  def value_set_select(value_set, method, options={}, html_options={})
    header = ValueSetHeader.where(:name=>value_set).first
		return select(method, header ? [["", ""]] + header.name_value_array : [],
									options, html_options)
  end
end
