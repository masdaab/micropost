class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  #exercise 6
  before_action :isnot_loged_in, only: [:new, :create]
    
  def new
  	@user  = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if(@user.save)
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      flash[:error] = "Sign Up Failed!"
      render 'new'
    end 
  end

  def edit 
        @user = User.find(params[:id])
     
  end
#exercise 1
  def update
      @user = User.find(params[:id])
      if @user.admin?
        redirect_to @user, notice: "Cannot edit data admin."
      else
        if(@user.update_attributes(user_params))
          flash[:success] = 'Profile updated'
          redirect_to @user
        else
          render 'edit'
        end
      end
  end


  def home
  end

  def index
     @users = User.paginate(page: params[:page])
  end 
  
#exercise 9
  def destroy
    @user = User.find(params[:id])
    if !current_user?(@user)
      @user.destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    else
      redirect_to users_url
    end
  end

 private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end


    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end



    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    #exercise 6
    def isnot_loged_in
      unless !signed_in? 
        redirect_to root_url
      end
    end
end
