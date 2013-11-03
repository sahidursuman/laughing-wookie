require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "a user should have a profile name without spaces" do
	  user = User.new(first_name: 'Jason', last_name: 'Seifer', email: 'jason2@teamtreehouse.com')
	  user.password = user.password_confirmation = 'asdfasdf'

	  user.profile_name = 'My Profile With Spaces'
	  
	  assert !user.save
	  assert !user.errors[:profile_name].empty?
	  assert user.errors[:profile_name].include?("Must be formatted correctly.")
  end

  test "a user can have a correctly formatted profile name" do
	  user = User.new(first_name: 'Jason', last_name: 'Seifer', email: 'jason2@teamtreehouse.com')
	  user.password = user.password_confirmation = 'asdfasdf'

	  user.profile_name = 'jasonseifer_1'
	  assert user.valid?	
  end
  
end
