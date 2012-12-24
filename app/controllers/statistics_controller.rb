class StatisticsController < ApplicationController
  layout 'e_books'

  def index
    @daily_increment = {
      '12-01'=>5,
      '12-02'=>5,
      '12-03'=>5,
      '12-04'=>5,
      '12-05'=>5,
      '12-06'=>5,
      '12-07'=>5,
      '12-08'=>5,
      '12-09'=>5,
      '12-10'=>5,
      '12-11'=>5,
      '12-12'=>5,
      '12-13'=>5,
      '12-14'=>5
    }
  end
end
