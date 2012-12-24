class StatisticsController < ApplicationController
  layout 'e_books'

  def index
    @daily_increment = _daily_increment
  end

	private
	def _daily_increment
		result = {}

		to_date = Date.today
		from_date = to_date - 13
		
		(from_date..to_date).each do |d|
			result[d.strftime '%m-%d'] = 0
		end

		EBook.where(:created_at=>from_date..(to_date+1)).order(:created_at).each do |ebook|
			index = ebook.created_at.strftime('%m-%d')
			result[index] = result[index] + 1
		end

		result
	end
end
