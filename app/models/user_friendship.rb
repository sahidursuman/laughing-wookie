class UserFriendship < ActiveRecord::Base
	belongs_to :user
	belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

	#where do i put the .permit for the user and friend? and user_id and friend_id
end
