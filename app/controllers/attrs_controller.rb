#-*- encoding: utf-8 -*-
class AttrsController < ApplicationController
  def index
    @attrs = Attr.all
  end

  def show
    @attr = Attr.find params[:id]
  end

  def edit
    @attr = Attr.find params[:id]
  end

  def update
    @attr = Attr.find params[:id]

    if @attr.update_attributes params[:attr] then
      redirect_to :back, :notice => '更新成功'
    else
      render :edit
    end
  end

  def new
    @attr = Attr.new
  end

  def create
    @attr = Attr.new params[:attr]

    if @attr.save then
      redirect_to :back, :notice => '新增成功'
    else
      render :new
    end
  end

  def destroy
    @attr = Attr.find params[:id]

    if @attr.delete then
      redirect_to :back, :notice => '删除成功'
    else
      redirect_to :back, :notice => '删除失败'
    end
  end
end
