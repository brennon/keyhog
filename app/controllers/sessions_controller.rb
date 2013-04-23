class SessionsController < ApplicationController
  def new
  end

  def create
    url = session[:return_to] || root_path
    session[:return_to] = nil
    user = User.find_by_email(params[:email])
    if user && user.validate_password(params[:password])
      session[:user_id] = user.id
      redirect_to url, notice: 'Logged in!'
    else
      flash.now.notice = 'Email or password is invalid'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    reset_session
    flash[:notice] = 'Logged out!'
    redirect_to root_path
  end
end
