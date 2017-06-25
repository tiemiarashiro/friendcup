class BracketsController < ApplicationController

  def finish
    @bracket = Bracket.find params[:id]
    if @bracket.finished?
      @error = "Chave já finalizada"
    elsif !@bracket.completed?
      @error = "Chave não completa"
    else
      unless finish_bracket
        @error = "Erro ao finalizar chave"
      end
    end
  end

  private

  def finish_bracket
    @bracket.transaction do
      @bracket.update! winner_id: params[:winner_id]
      if @bracket.final?
        @bracket.championship.update! winner: Participant.find(params[:winner_id]).user_id
      else
        if @bracket.parent.player_1_id.blank?
          @bracket.parent.update! player_1_id: params[:winner_id]
        else
          @bracket.parent.update! player_2_id: params[:winner_id]
        end
      end
    end
  end

end
