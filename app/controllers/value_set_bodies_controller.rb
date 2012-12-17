class ValueSetBodiesController < ApplicationController
  # GET /value_set_bodies
  # GET /value_set_bodies.json
  def index
    @value_set_header = ValueSetHeader.find params[:value_set_header_id]
    @value_set_bodies = ValueSetBody.where(:value_set_header_id=>@value_set_header.id).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @value_set_bodies }
    end
  end

  # GET /value_set_bodies/1
  # GET /value_set_bodies/1.json
  def show
    @value_set_body = ValueSetBody.find(params[:id])
    @value_set_header = ValueSetHeader.find params[:value_set_header_id]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @value_set_body }
    end
  end

  # GET /value_set_bodies/new
  def new
    @value_set_body = ValueSetBody.new
    @value_set_body.value_set_header_id = params[:value_set_header_id]
    @value_set_header = ValueSetHeader.find params[:value_set_header_id]

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /value_set_bodies/1/edit
  def edit
    @value_set_body = ValueSetBody.find(params[:id])
  end

  # POST /value_set_bodies
  def create
    @value_set_body = ValueSetBody.new(params[:value_set_body])
    @value_set_header = ValueSetHeader.find params[:value_set_header_id]

    respond_to do |format|
      if @value_set_body.save
        format.html { redirect_to [@value_set_header, @value_set_body], notice: 'Value set body was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /value_set_bodies/1
  # PUT /value_set_bodies/1.json
  def update
    @value_set_body = ValueSetBody.find(params[:id])

    respond_to do |format|
      if @value_set_body.update_attributes(params[:value_set_body])
        format.html { redirect_to @value_set_body, notice: 'Value set body was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @value_set_body.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /value_set_bodies/1
  # DELETE /value_set_bodies/1.json
  def destroy
    @value_set_body = ValueSetBody.find(params[:id])
    @value_set_body.destroy

    respond_to do |format|
      format.html { redirect_to value_set_bodies_url }
      format.json { head :no_content }
    end
  end
end
