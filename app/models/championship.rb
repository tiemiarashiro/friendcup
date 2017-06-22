class Championship < ApplicationRecord

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
  
  def full_loaded_final
    all_brackets = brackets.to_a
    
    all_brackets.each do |bracket|
      bracket.children = all_brackets.select { |b| b.parent_id == bracket.id}
    end
    
    all_brackets.find { |bracket| bracket.parent_id.nil? }
  end

end
