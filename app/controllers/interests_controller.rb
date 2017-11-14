class InterestsController < ApplicationController

  has_scope :by_format
  has_scope :by_local

  def index
    @interests = apply_scopes(Interest.all.includes(:user))
  end

end
