class SessionsController < ApplicationController
  def create
    callback = request.env['omniauth.auth']
    user = User.find_or_create_from_auth(callback)
    session[:user_id] = user.id
    session[:oauth_token] = callback['credentials']['token']
    session[:oauth_token_secret] = callback['credentials']['secret']
    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
