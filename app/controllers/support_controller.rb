#-*- encoding:utf-8 -*-
class SupportController < ApplicationController
  layout 'e_books'

  def show
    @donations = Donation.order('date desc').all.map do |donation|
      if donation.date < '2015.07.13 00:00' then
        donation.name = donation.name[0...-2] + '*' + donation.name[-1]
      else
        donation.name = donation.name
      end

      donation
    end
  end
end
