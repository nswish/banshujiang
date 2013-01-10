class ExportController < ApplicationController
  def show
    model_name = params[:id].capitalize
    model_class = eval model_name

    respond_to do |format|
      format.yaml { render text: model_class.export }
    end
  end
end
