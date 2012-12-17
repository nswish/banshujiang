class ValueSetHeadersController < ApplicationController
  # GET /value_set_headers
  def index
    @value_set_headers = ValueSetHeader.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /value_set_headers/1
  # GET /value_set_headers/1.json
  def show
    @value_set_header = ValueSetHeader.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @value_set_header }
    end
  end

  # GET /value_set_headers/new
  # GET /value_set_headers/new.json
  def new
    @value_set_header = ValueSetHeader.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @value_set_header }
    end
  end

  # POST /value_set_headers
  # POST /value_set_headers.json
  def create
    @value_set_header = ValueSetHeader.new(params[:value_set_header])

    respond_to do |format|
      if @value_set_header.save
        format.html { redirect_to @value_set_header, notice: 'Value set header was successfully created.' }
        format.json { render json: @value_set_header, status: :created, location: @value_set_header }
      else
        format.html { render action: "new" }
        format.json { render json: @value_set_header.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /value_set_headers/1
  # DELETE /value_set_headers/1.json
  def destroy
    @value_set_header = ValueSetHeader.find(params[:id])
    @value_set_header.destroy

    respond_to do |format|
      format.html { redirect_to value_set_headers_url }
      format.json { head :no_content }
    end
  end

  def export
    result = { :value_set_headers=>ValueSetHeader.export, :value_set_bodies=>ValueSetBody.export }
    respond_to do |format|
      #format.html { redirect_to value_set_headers_url }
      format.json { render json: result }
    end
  end

  def import
    if params['import_file'] then
      docs = JSON.load params['import_file'].read
      ValueSetHeader.import docs['value_set_headers']
      ValueSetBody.import docs['value_set_bodies']
    elsif params['import_url'] then
      require 'net/http'
      docs = JSON.load Net::HTTP.get(URI(params['import_url']))
      ValueSetHeader.import docs['value_set_headers']
      ValueSetBody.import docs['value_set_bodies']
    end  
  end
end
