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

  def edit
    @value_set_header = ValueSetHeader.find(params[:id])
  end

  # GET /value_set_headers/new
  def new
    @value_set_header = ValueSetHeader.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /value_set_headers
  def create
    @value_set_header = ValueSetHeader.new(params[:value_set_header])

    respond_to do |format|
      if @value_set_header.save
        format.html { redirect_to @value_set_header, notice: 'Value set header was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @value_set_header = ValueSetHeader.find params[:id]

    respond_to do |format|
      if @value_set_header.update_attributes params[:value_set_header] then
        format.html { redirect_to @value_set_header, notice: 'Value set header was successfully updated.' }
      else
        format.html { render action: "edit" }
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
