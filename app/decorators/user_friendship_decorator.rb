class UserFriendshipDecorator < Draper::Decorator
  delegate_all

  decorates :user_friendship

  def friendship_state
  	model.state.titelize
  end	

  def sub_message
  	case model.state
  	when 'pending'
  		"Do you really want to be friends with #{model.friend.first_name}? You're probably cooler than them anyway ..." 
  	when 'accepted'
  		"You are friends with #{model.friend.first_name}."
  	end	
  end	
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end

#video suggested correct code is #{model.friend.first_name}. But really, who knows?
