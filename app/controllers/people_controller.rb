class PeopleController < ApplicationController
  before_filter :authenticate!

  def index
    @people = current_user.people
  end

  def new
  end
end
