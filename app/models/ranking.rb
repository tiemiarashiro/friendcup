class Ranking < ApplicationRecord
  belongs_to :user

  def update_by_match(match)
    self.played_games +=1

    if(match.player1.user.id == self.user.id)
      my_score =  match.score_player1
      other_score = match.score_player2
    else
      my_score =  match.score_player2
      other_score = match.score_player1
    end

    if my_score > other_score
      self.points += 3
      self.victories += 1
    elsif my_score < other_score
      self.defeats += 1
    else
      self.points += 1
      self.draws += 1
    end
  end

end
