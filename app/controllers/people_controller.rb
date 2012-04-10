class PeopleController < ApplicationController
  before_filter :authenticate!
  respond_to :html, :json

  def index
    @people = current_user.people.page(params[:page]).per_page(10)
  end

  def new
  end

  def create
    @person = Person.new params[:person]
    @person.user_id = params[:user_id]

    flash[:notice] = "Created #{@person.name}" if @person.save

    respond_with [current_user, @person] do |format|
      format.html { redirect_to :back }
    end
  end
end
