class ImportController < ApplicationController
  def index
  end

  def show
  end

  def create
    puts 'aaaa'
    model_class = eval params[:id]

    require 'net/http'
    model_class.import Net::HTTP.get(URI 'http://ebook.jiani.info/export/'+params[:id]+'.json')

    render :text => "ok"
  end
end
