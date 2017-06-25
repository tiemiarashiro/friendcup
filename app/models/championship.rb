class Championship < ApplicationRecord

  class InvalidParticipantsNumber < StandardError; end;
  class InvalidChampionshipType < StandardError; end;

  belongs_to :championship_type
  belongs_to :user
  has_many :participants
  has_many :users, through: :participants
  has_many :pontoscorridos_partidas
  has_many :brackets

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
      rank1 = ranks.find {|s| s.user_id == partida.player1.user.id }
      rank1.update_by_match(partida)

      rank2 = ranks.find {|s| s.user_id == partida.player2.user.id }
      rank2.update_by_match(partida)
    end
    sorted_ranking = ranks.sort_by {|obj| [obj.points * -1, obj.victories * -1, obj.draws * -1, obj.user_id]}
  end

  def full_loaded_final
    all_brackets = brackets.to_a

    all_brackets.each do |bracket|
      bracket.children = all_brackets.select { |b| b.parent_id == bracket.id}
    end

    all_brackets.find { |bracket| bracket.parent_id.nil? }
  end

  def generate_brackets!
    raise InvalidParticipantsNumber if Math.log2(participants.count) != Math.log2(participants.count).to_i
    raise InvalidChampionshipType unless self.brackets?

    current_participants = participants.clone
    brackets = []
    while current_participants.present?
      bracket = Bracket.new(championship_id: self.id)
      bracket.player_1 = current_participants.delete(current_participants.sample)
      bracket.player_2 = current_participants.delete(current_participants.sample)
      brackets << bracket
    end

    current_round = brackets
    while current_round.size > 1
      next_round = []
      while current_round.present?
        parent = Bracket.create!(championship_id: self.id)

        bracket1 = current_round.pop
        bracket1.parent = parent
        bracket1.save!

        bracket2 = current_round.pop
        bracket2.parent = parent
        bracket2.save!

        next_round << parent
      end
      current_round = next_round
    end
  end

end
