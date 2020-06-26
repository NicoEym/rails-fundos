class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def index
    @user = current_user
    authorize @user
    @users = policy_scope(User)
    # if params[:approved] == "false"
    #   @users = User.where(approved: false)
    # else
    #   @users = User.all
    # end
  end

  def edit
  end

  def update
    @user.approved = true
    @user.save
    redirect_to users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end
end
