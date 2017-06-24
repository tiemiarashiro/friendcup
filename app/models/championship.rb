class Championship < ApplicationRecord

  belongs_to :championship_type
  belongs_to :user
  has_many :participants
  has_many :users, through: :participants
  has_many :pontoscorridos_partidas

  accepts_nested_attributes_for :participants

  def brackets?
    self.championship_type_id == 2
  end

  def finished?
    self.winner.present?
  end

  def ranking
    ranks = Array.new
    self.participants.each do |participante|
      r = Ranking.new(user_id: participante.user_id, played_games: 0, victories: 0, draws: 0, defeats: 0, points: 0)
      ranks << r
    end
    self.pontoscorridos_partidas.where({finished: true}).includes(:player1, :player2).each do |partida|
      rank1 = ranks.find {|s| s.user_id == partida.player1.id }
      rank1.update_by_match(partida)

      rank2 = ranks.find {|s| s.user_id == partida.player2.id }
      rank2.update_by_match(partida)
    end
    sorted_ranking = ranks.sort_by {|obj| [obj.points * -1, obj.victories * -1, obj.draws * -1, obj.user_id]}
  end
end
