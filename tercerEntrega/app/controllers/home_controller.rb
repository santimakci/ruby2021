class HomeController < ApplicationController
  def home
    if logged_in?
      @professionals = Professional.all
    end
  end
  
end
