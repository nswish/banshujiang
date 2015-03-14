class ImportController < ApplicationController
  def index
  end

  def show
  end

  def create
    model_class = eval params[:id]

    require 'net/http'
    model_class.import Net::HTTP.get(URI 'http://ebook.jiani.info/export/'+params[:id]+'.json')

    render :text => "ok"
  end

  def refreshCount
    require 'net/http'

    EBook.refreshCount Net::HTTP.get(URI 'http://ebook.jiani.info/export/EBook.json')

    render :text => "ok"
  end
end
