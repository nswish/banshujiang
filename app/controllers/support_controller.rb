#-*- encoding:utf-8 -*-
class SupportController < ApplicationController
  layout 'e_books'

  def show
    @donations = Donation.order('date desc').all
  end
end
