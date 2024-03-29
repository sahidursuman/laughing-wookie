require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:user_friendships)
  should have_many(:friends)
  should have_many(:pending_user_friendships)
  should have_many(:pending_friends)
  should have_many(:requested_user_friendships)
  should have_many(:requested_friends)
  should have_many(:blocked_user_friendships)
  should have_many(:blocked_friends)
  should have_many(:activities)

  test "a user should enter a first name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end

  test "a user should enter a last name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end

  test "a user should enter a profile name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

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
  
  test "that no error is raised when trying to access a friend list" do
  	assert_nothing_raised do
  		users(:jason).friends
  	end
  end

  test "that creating friendships on a user works" do
  	user(:jason).pending_friends << users(:mike)
  	users(:jason).pending_friends.reload
  	assert users(:jason).pending_friends.include?(users(:mike))
  end

  test "that creating a friendship on a user id and friend id works" do
    UserFriendship.create user_id: users(:jason).id, friend_id: users(:mike).id
    assert users(:jason).friends.include?(users(:mike))
  end

  test "that calling to_param on a user returns the profile_name" do
    assert_equal "jasonseifer", users(:jason).to_param
  end

  context "#has_blocked?" do
    should "return true if a user has blocked another users" do
      assert users(:jason).has_blocked?(users(:blocked_by_jason))
    end

    should "return false if a user has not blocked another users" do
      assert !users(:jason).has_blocked?(users(:jim))
    end
  end

  context "#create_activity" do
    should "increase the Activity count" do
      assert_difference 'Activity.count' do
        users(:jason).create_activity(statuses(:one), 'created')
      end

      should "set the targetable instance to the item passed in" do
        activity = users(:jason).create_activity(statuses(:one), 'created')
        assert_equal statuses(:one), activity.targetable
      end
    end

    should "increase the Activity count with an album" do
      assert_difference 'Activity.count' do
        users(:jason).create_activity(albums(:vacation), 'created')
      end

      should "set the targetable instance to the item passed in with an album" do
        activity = users(:jason).create_activity(albums(:vacation), 'created')
        assert_equal statuses(:one), activity.targetable
      end
    end
  end
end
