require 'sha1'

class UsersController < ApplicationController

  sortable_attributes :name, :age, :admin, :group => "groups.name",
                      :age_and_name => ["age", "users.name"]

  post_fetch_sort :last_hash_char => :last_char_of_name_hash,
                  :name_hash => lambda {|user| SHA1.hexdigest(user.name)}

  post_fetch_sort :reversed_name_hash

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

  private

  def self.reversed_name_hash(user)
    SHA1.hexdigest(user.name).reverse
  end

  def self.last_char_of_name_hash(user)
    SHA1.hexdigest(user.name)[-1,1]
  end
end
