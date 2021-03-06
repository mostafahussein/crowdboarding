class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    if user.admin?
      can :manage, :all
    elsif !user.new_record?
      can :create, Comment
      can :create, Event
      can :update, Event do |event|
        event.user_id == user.id && event.starts_at > Time.now
      end
      can :create, Friendship 
      can :create, Attendance
      can :create, City
      can :create, Tag
      can :destroy, Attendance, :user_id => user.id
      can :destroy, Notification, :user_id => user.id
      can :manage, User, :id => user.id
      can :read, :all
    else
      can :read, :all
    end
  end
end
