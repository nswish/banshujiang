class ImportController < ApplicationController
  def index
  end

  def show
  end

  def create
    model_class = eval params[:id]

    require 'net/http'
    model_class.import= Net::HTTP.get(URI 'http://ebook.jiani.info/export/'+params[:id]+'.yaml')

    redirect_to :back
  end
end
