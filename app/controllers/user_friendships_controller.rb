class UserFriendshipsController < ApplicationController
	before_filter :authenticate_user!, only: [:new]

	def new
		if params[:friend_id] #is this rails 4? 
			@friend = User.where(profile_name: params[:friend_id]).first
			#raise ActiveRecord::RecordNotFound if @friend.nil?
			@user_friendship = current_user.user_friendships.new(friend: @friend)
		else
			flash[:error] = "Friend required."
		end
	
	rescue ActiveRecord::RecordNotFound
		render file: 'public/404', status: :not_found
	end
	
	def create
		if params[:user_friendship] && params[:user_friendship].has_key?(:friend_id)
			@friend = User.where(profile_name: params[:user_friendship][:friend_id]).first
			@user_friendship = current_user.user_friendships.new(friend: @friend)
			@user_friendship.save
			flash[:success] = "You are now friends with #{@friend.full_name}."
			redirect_to profile_path(@friend)
		else
			flash[:error] = "Friend required"
			redirect_to root_path
		end
	end

	def friendships_params
      params.require(:user).permit(:user_id, :friend_id, :users, :friends)
    end
    #not sure if this params.require is necessary or if it's under user. just need somewhere for the .permit
end
