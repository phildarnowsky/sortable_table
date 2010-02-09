require 'sha1'

class UsersController < ApplicationController

  sortable_attributes :name, :age, :admin, :group => "groups.name",
                      :age_and_name => ["age", "users.name"]

  post_fetch_sort :name_hash => lambda {|user| SHA1.hexdigest(user.name)}

  def index
    @users = User.find :all, :include => :group, :order => sort_order("ascending")
    handle_post_fetch_sorts(:@users)
  end

  def show
    @users = User.find :all, :order => sort_order
  end

  def members
    @members = User.find :all, :order => sort_order
  end

end
