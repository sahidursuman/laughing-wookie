class UserFriendshipsController < ApplicationController
	before_filter :authenticate_user!
	respond_to :html, :json

	def index
		@user_friendships = UserFriendshipDecorator.decorate_collection(friendship_association.all)
		respond_with @user_friendships
	end

	def accept
		@user_friendship = current_user.user_friendships.find(params[:id])
		if @user_friendship.accept!
			current_user.create_activity @user_friendship, 'accepted'
			flash[:success] = "You are now friends with #{@user_friendship.user.first_name}!"
		else
			flash[:error] = "They think you're a creep."
		end	
		redirect_to user_friendships_path
	end
	
	def block
		@user_friendship = current_user.user_friendships.find(params[:id])
		if @user_friendship.block!
			flash[:success] = "You have blocked #{@user_friendship.friend}."
		else
			flash[:error] = "That friendship could not be blocked, because their feelings are so strong (probably)."
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
	
	#rescue ActiveRecord::RecordNotFound
	#	render file: 'public/404', status: :not_found
	end
	
	def create
		if params[:user_friendship] && params[:user_friendship].has_key?(:friend_id)
			@friend = User.where(profile_name: params[:user_friendship][:friend_id]).first
			@user_friendship = UserFriendship.request(current_user, @friend)
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
		@friend = User.where(profile_name: params[:id]).first
		@user_friendship = current_user.user_friendships.where(friend_id: @friend).first.decorate
	end

	def destroy
		@user_friendship = current_user.user_friendships.find(params[:id])
		if @user_friendship.destroy
			flash[:success] = "Friendship destroyed."
		end		
		redirect_to user_friendships_path
	end

	def friendships_params
      params.require(user_friendship).permit(:user_id, :friend_id, :user, :friend, :state, :first_name, :user_friendship, :full_name, :last_name)
    end
    #not sure if this params.require is necessary or if it's under user. just need somewhere for the .permit

    private
    def friendship_association
		case params[:list]
    	when nil
			current_user.user_friendships
		when 'blocked'
			current_user.blocked_user_friendships
		when 'pending'
			current_user.pending_user_friendships
		when 'accepted'
			current_user.accepted_user_friendships
		when 'requested'
			current_user.requested_user_friendships
		end
   	end
end
