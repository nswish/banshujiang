class WebstorageLinksController < ApplicationController
  def destroy
    if cookies[:token] == 'zwyxyz' then
      WebstorageLink.find(params[:id]).delete
    end
    
    redirect_to :back
  end

  def create
    if cookies[:token] == 'zwyxyz' then
      webstorage_link = WebstorageLink.new(params[:webstorage_link])
      webstorage_link.e_book_id = params[:e_book_id]
      webstorage_link.save
    end

    redirect_to :back
  end
end
