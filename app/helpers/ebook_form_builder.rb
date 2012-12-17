#-*- encoding: utf-8 -*-
class EbookFormBuilder < ActionView::Helpers::FormBuilder
	def webstorage_select(method, options={}, html_options={})
    header_id = ValueSetHeader.where(:name=>'webstorages')[0].id
		return select(method, [["",""]] + ValueSetBody.where(:value_set_header_id=>header_id).collect { |item|
                    [ item.name, item.value ]
                  },
									options, html_options)
	end

  def publisher_select(method, options={}, html_options={})
    return select(method, [
														["", ""],
                            ["O'Reilly", "O'Reilly"],
                            ["Manning", "Manning"],
                            ["Addison Wesley", "Addison Wesley"],
                            ["Wiley", "Wiley"],
                            ["Pragmatic Bookshelf", "Pragmatic Bookshelf"]
                          ],
                  options, html_options)
  end

  def programming_language_select(method, options={}, html_options={})
    return select(method, [
														["Ruby", "Ruby"],
														["Python", "Python"],
														["JavaScript", "JavaScript"],
														["Java", "Java"],
														["PHP", "PHP"],
														["Objective-C", "Objective-C"],
                          ],
                  options, html_options)
  end
end
