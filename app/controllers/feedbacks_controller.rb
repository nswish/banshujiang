class FeedbacksController < ApplicationController
  before_filter :require_login

  def destroy
    user = User.find session[:user_id]

    feedback = Feedback.find params[:id]
    if feedback && feedback.user_id == user.id then
      feedback.delete
    end

    redirect_to url_for(:controller=>:users, :action=>:new_feedback)
  end
end
