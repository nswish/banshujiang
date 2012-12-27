#-*- encoding: utf-8 -*-
class EbookFormBuilder < ActionView::Helpers::FormBuilder
  ValueSetHeader.all.each do |header|
    method_name = ActiveSupport::Inflector.singularize(header.name) + "_select"
    define_method method_name do |method, options={}, html_options={}|
      value_set_select(header.name.dup, method, options, html_options)
    end
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
