class StatisticsController < ApplicationController
  layout 'e_books'

  def index
    @daily_increment = _daily_increment
    @year_count = _year_count
  end

	private
	def _daily_increment
		result = {}

		to_date = Date.today.to_time_in_current_zone.to_date
		from_date = to_date - 13
		
		(from_date..to_date).each do |d|
			result[d.strftime '%m-%d'] = 0
		end

		EBook.where(:created_at=>from_date..(to_date+1)).order(:created_at).each do |ebook|
			index = ebook.created_at.strftime('%m-%d')
			result[index] = result[index] + 1
		end

		return result
	end

  def _year_count
		result = {}

    EBook.select('publish_year, count(1) as counts').group('publish_year').order('publish_year').each do |item|
      result[item.publish_year.to_s] = item.counts
    end

    return result
  end
end
