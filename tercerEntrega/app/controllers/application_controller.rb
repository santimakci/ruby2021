class ApplicationController < ActionController::Base
    
  helper_method :authorized
    helper_method :current_user
    helper_method :logged_in?

    
    def current_user
      User.find_by(id: session[:user_id])
    end

    def is_admin?
      if current_user.admin?
        redirect_to root_path
      end
    end

    def logged_in?      
      !current_user.nil?
    end

    def authorized
      if logged_in?
        redirect_to root_path
      end
    end

    def hours
      return [
          "8:00", "8:15", "8:30", "8:45", 
          "9:00", "9:15", "9:30", "9:45", 
          "10:00", "10:15", "10:30", "10:45",
          "11:00", "11:15", "11:30", "11:45",
          "12:00", "12:15", "12:30", "12:45",
          "13:00", "13:15", "13:30", "13:45",
          "14:00", "14:15", "14:30", "14:45",
          "15:00", "15:15", "15:30", "15:45",
          "16:00", "16:15", "16:30", "16:45",
          "17:00", "17:15", "17:30", "17:45", "18:00"]
    end
end
