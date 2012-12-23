class CategoryController < ApplicationController
	layout 'e_books'

	LIMIT_PER_PAGE = 10

  def show
		page
  end

  def page
    @page_id = if params[:id].to_i == 0 then 1 else params[:id].to_i end
    offset = (@page_id - 1) * LIMIT_PER_PAGE

    condition = {params[:category]=>params[:name]}
    @e_books = EBook.where(condition).order('created_at desc').limit(LIMIT_PER_PAGE).offset(offset)

    @page_count = (EBook.where(condition).count / LIMIT_PER_PAGE.to_f).ceil

    render 'show.html.erb'
  end

end
