#-*- encoding:utf-8 -*-
class SupportController < ApplicationController
  layout 'e_books'

  def show
    @donations = Donation.order('date desc').all.map do |donation|
      donation.name = donation.name[0...-2] + '*' + donation.name[-1]
      donation
    end
  end
end
