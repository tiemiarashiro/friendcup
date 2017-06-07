class ChampionshipsController < ApplicationController

  def index
    @championships = current_user.championships
  end

  def new
    @championship = Championship.new
  end

  def create
    attributes = permitted_params
    attributes[:user] = current_user
    @championship = Championship.new(attributes)
      
    if(@championship.save)
      
      #Salvar os participantes
      params[:championship][:user_ids].each do |participante|
        part = Participant.new(championship_id: @championship.id, user_id: participante)
        part.save
      end
      
      redirect_to @championship
    else
      render :new
    end
  end

  def show
    @championship = Championship.find(params[:id])
  end

  private

    def permitted_params
      params.require(:championship).permit(:name, :game, :starts_at, :ends_at, :championship_type_id, :user_ids)
    end

end
