class SessionController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
       session[:user_id] = @user.id
       redirect_to root_path
    else
      redirect_to session_new_path, flash:{messages: "Usuario o contraseña incorrectos"}
     end
  end

  def close
    reset_session
    redirect_to root_path
  end
end
