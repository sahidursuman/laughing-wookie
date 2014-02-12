class UserFriendshipsController < ApplicationController
	before_filter :authenticate_user!
	respond_to :html, :json

	def index
		@user_friendships = current_user.user_friendships.all
	end

	def accept
		@user_friendship = current_user.user_friendships.find(params[:id])
		if @user_friendship.accept!
			flash[:success] = "You are now friends with #{@user_friendship.user.first_name}!"
		else
			flash[:error] = "They think you're a creep."
		end	
		redirect_to user_friendships_path
	end	
		
	def new
		if params[:friend_id] #is this rails 4? 
			@friend = User.where(profile_name: params[:friend_id]).first
			#raise ActiveRecord::RecordNotFound if @friend.nil?
			@user_friendship = current_user.user_friendships.new(friend: @friend)
		else
			flash[:error] = "Oh dear ... that person seems to have disappeared. The request failed."
		end
	
	rescue ActiveRecord::RecordNotFound
		render file: 'public/404', status: :not_found
	end
	
	def create
		if params[:user_friendship] && params[:user_friendship].has_key?(:friend_id)
			@friend = User.where(profile_name: params[:user_friendship][:friend_id]).first
			@user_friendship = UserFriendship.request(@current_user, @friend)
			respond_to do |format|
				if @user_friendship.new_record?
					format.html do 
						flash[:error] = "There was a problem creating that friend request."
						redirect_to profile_path(@friend)
					end
					
					format.json { render json: @user_friendship.to_json, status: :precondition_failed }
				
				else
					format.html do
						flash[:success] = "Friend request sent."
						redirect_to profile_path(@friend)
					end

					format.json { render json: @user_friendship.to_json }

				end	
			end
		else
			flash[:error] = "Oh dear ... that person seems to have disappeared. The request failed."
			redirect_to root_path
		end
	end

	def edit
		@user_friendship = current_user.user_friendships.find(params[:id]).decorate
		@friend = @user_friendship.friend
	end

	def destroy
		@user_friendship = current_user.user_friendships.find(params[:id])
		if @user_friendship.destroy
			flash[:success] = "Friendship destroyed."
		end		
		redirect_to user_friendships_path
	end

	def friendships_params
      params.permit(:user_id, :friend_id, :users, :friends, :state, :first_name, :user_friendships)
    end
    #not sure if this params.require is necessary or if it's under user. just need somewhere for the .permit
end
