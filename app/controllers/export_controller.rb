class ExportController < ApplicationController
  def show
    model_class = eval params[:id]

    respond_to do |format|
      format.yaml { render text: model_class.export }
      format.json { render text: model_class.export }
    end
  end
end
