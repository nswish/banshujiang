#-*- encoding: utf-8 -*-
class WebstorageFormBuilder < ActionView::Helpers::FormBuilder
	def webstorage_select(method, options={}, html_options={})
		return select(method, [
														["华硕网盘", "华硕网盘"],
														["百度网盘", "百度网盘"]
													],
									options, html_options)
	end
end
