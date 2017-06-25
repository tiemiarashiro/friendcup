class ChampionshipsController < ApplicationController

  ID_PONTOS_CORRIDOS = 1 #definir qual ID eh o de pontos corridos

  helper_method :id_pontos_corridos

  def id_pontos_corridos
    ID_PONTOS_CORRIDOS
  end

  def index
    @championships = Array.new

    participations = Participant.where(user_id: current_user.id)

    participations.each do |participation|
      # if participation.championship.user_id != current_user.id
        @championships << participation.championship
      # end
    end

    #Informacoes de Ranking
    @rank = current_user.ranking

    if @rank == nil
      @rank = Ranking.new(user_id: current_user.id, played_games: 0, scheduled_games: 0, victories: 0, draws: 0, defeats: 0, points: 0, wins: 0, position: Ranking.count+1)
      @rank.save
    end

  end

  def new
    @championship = Championship.new
  end

  def create
    attributes = permitted_params
    attributes[:user] = current_user

    count_participants = params[:championship][:user_ids].select(&:present?).count
    @championship = Championship.new(attributes)
    if(@championship.championship_type_id != ID_PONTOS_CORRIDOS && Math.log2(count_participants) != Math.log2(count_participants).to_i)
      flash[:errors] = "O número de participantes é inválido"
      render :new
      return
    end

    if(@championship.save)
      participants = Array.new

      params[:championship][:user_ids].each do |user_id|
        participant = Participant.new(championship_id: @championship.id, user_id: user_id)
        participant.save
        participants << participant
      end

      if @championship.championship_type_id == ID_PONTOS_CORRIDOS
        for i in (1..participants.size-2)
          for j in (i+1..participants.size-1)
            partida = PontoscorridosPartida.new(championship_id: @championship.id, player1: participants[i], player2: participants[j], score_player1: 0, score_player2: 0, finished: false)
            partida.save
          end
        end

      else
        @championship.generate_brackets!
      end

      redirect_to @championship
    else
      render :new
    end
  end

  def show
    @championship = Championship.find(params[:id])
    if @championship.brackets?
      render :show_brackets
    else
      render :show_all_play_all
    end
  end

  def atualizar_partidas

    params[:score_player1].each do |k,v|
      if v != ""
        partida = PontoscorridosPartida.find_by_id(k)
        partida.score_player1 = v
        partida.finished = true
        partida.save
      end
    end

    params[:score_player2].each do |k,v|
      if v != ""
        partida = PontoscorridosPartida.find_by_id(k)
        partida.score_player2 = v
        partida.finished = true
        partida.save
      end
    end

    @championship = Championship.find_by_id(params[:id])

    respond_to do |format|
      format.js
    end

  end

  def finalizar_campeonato

    campeonato = Championship.find_by_id(params[:id])
    campeonato.ranking
    campeonato.winner = campeonato.ranking.first.user_id
    campeonato.save

    #Recalcular o ranking geral
    %x[rake ranking:atualizar]

    redirect_to campeonato
  end

  private

    def permitted_params
      params.require(:championship).permit(:name, :game, :starts_at, :ends_at, :championship_type_id, :user_ids)
    end
end
