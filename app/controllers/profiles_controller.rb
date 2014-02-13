class ProfilesController < ApplicationController
  def show
  	@user = User.find_by_profile_name(params[:id])
  	if @user
  		@statuses = @user.statuses.all
  		render action: :show
  	else
  		render file: 'public/404', status: 404, formats: [:html]
  	end
  end

  def profiles_params
      params.permit(:user_id, :friend_id, :users, :friends, :state, :first_name, :last_name, :user_friendships, :full_name)
  end
     
end
