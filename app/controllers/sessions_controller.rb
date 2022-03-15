class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    respond_to do |format|
      if user  && user.authenticate(params[:session][:password])
        session[:user_id] = user.id
        format.html { redirect_to users_path(user), notice: "You are logged in successfully." }
      else
        flash[:alert] = "Invalid email or password"
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    session[:user_id] = nil
    respond_to do |format|
      format.html { redirect_to articles_path, notice: "You have logged out" }
    end
  end

end
