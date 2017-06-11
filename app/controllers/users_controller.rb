class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]
  
  def index
    @users = User.all.page(params[:pages]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash[:danger] = 'ユーザ登録に失敗しました。'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update(user_params)
      flash[:success] = 'ユーザを更新しました。'
      redirect_to @user
    else
      flash[:danger] = 'ユーザ更新に失敗しました。'
      render :edit
    end    
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    flash[:success] = '退会しました。'
    redirect_to root_path
  end


  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :age, :gender, :profile)
  end

end


