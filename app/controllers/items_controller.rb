class ItemsController < ApplicationController
  def new
    @item = Item.new
  end

  def create
    user = User.find(session[:user_id])
    item = user.items.new(user_params)
    if item.save
      id = item[:id]
      redirect_to "/items/"+id.to_s
    else
      render 'new'
    end
  end

  def show
    id = params[:id]
    @item = Item.find(id)
    current_user = User.find(session[:user_id])
    owner_user = User.find(@item[:user_id])
    redirect_to action:'unauthorized' unless authentication(@item[:only_followers],current_user,owner_user)
  end
  
  def unauthorized
  end

  private
    def user_params
      params.require(:item).permit(:text, :only_followers)
    end

    def authentication(only_followers,current_user,owner_user)
      if only_followers
      	require 'twitter'
      	client = Twitter::REST::Client.new do |config|
          config.consumer_key        = Rails.application.secrets.twitter_api_key
	  config.consumer_secret     = Rails.application.secrets.twitter_api_secret
	  config.access_token        = session[:oauth_token]
	  config.access_token_secret = session[:oauth_token_secret]
        end
        current_user_screen_name = current_user[:nickname]
        owner_user_screen_name = owner_user[:nickname]
        result = client.friendship(current_user_screen_name,owner_user_screen_name)
        return result.source.following?
      else
        return true
      end
    end
end
