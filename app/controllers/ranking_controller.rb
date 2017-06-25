class RankingController < ApplicationController
  def index
    @Ranking = Ranking.order(position: :asc)
  end
end
