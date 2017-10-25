class InterestsController < ApplicationController

  def index
    @interests = Interest.all.includes(:user)
  end

end
