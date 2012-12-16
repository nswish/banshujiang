#-*- encoding: utf-8 -*-
class EbookFormBuilder < ActionView::Helpers::FormBuilder
	def webstorage_select(method, options={}, html_options={})
		return select(method, [
														["", ""],
														["华硕网盘", "华硕网盘"],
														["百度网盘", "百度网盘"],
														["Box.com", "Box.com"]
													],
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
