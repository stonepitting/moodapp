class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  
  # index page
  def index
    if user_signed_in?
      redirect_to dashboard_path()
    end
  end
  
  # dashboard
  def dashboard
    
  end
end
