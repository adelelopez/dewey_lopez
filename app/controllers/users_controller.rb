class UsersController < ApplicationController
	before_action :signed_in_user, 	
					only: [:index, :edit, :update, :destroy]
	before_action :signed_out_user, only: [:new, :create]
	before_action :correct_user,	only: [:edit, :update]
	before_action :admin_user,		only: :destroy

	def index
		@users = User.paginate(page: params[:page])
	end

 	def show
		@user = User.find(params[:id])
		if signed_in?
			@page = current_user.pages.build 
			@feed_items = current_user.feed.paginate(page: params[:page])
		end
	end

 	 def new
  		@user = User.new
 	 end

	def create
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end  

	def edit
	end

	def update
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated"
			redirect_to @user 
		else
			render 'edit'
		end
	end

	def destroy
		@user = User.find(params[:id])
		if current_user?(@user)
			redirect_to root_url
		else
			@user.destroy
			flash[:success] = "User deleted."
			redirect_to users_url
		end
	end

	private

		def user_params
			params.require(:user).permit(:name, :email, :password, 
											:password_confirmation)
		end

		# Before filtersz

		def signed_out_user
			unless !signed_in?
				redirect_to root_url
			end
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_url) unless current_user?(@user)
		end

		def admin_user
			redirect_to(root_url) unless current_user.admin?
		end
end