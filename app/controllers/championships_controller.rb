class ChampionshipsController < ApplicationController

  ID_PONTOS_CORRIDOS = 1 #definir qual ID eh o de pontos corridos

  helper_method :id_pontos_corridos

  def id_pontos_corridos
    ID_PONTOS_CORRIDOS
  end

  def index
    @championships = Array.new

    participam = Participant.where(user_id: current_user.id)

    participam.each do |relacao|

      if relacao.championship.user_id != current_user.id
        @championships << relacao.championship
      end

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
      participantes = Array.new

      #Salvar os participantes
      params[:championship][:user_ids].each do |participante|
        part = Participant.new(championship_id: @championship.id, user_id: participante)
        part.save
        participantes << part
      end

      if @championship.championship_type_id == ID_PONTOS_CORRIDOS
        for i in (1..participantes.size-2)
          for j in (i+1..participantes.size-1)
            partida = PontoscorridosPartida.new(championship_id: @championship.id, player1: participantes[i].user_id, player2: participantes[j].user_id, score_player1: 0, score_player2: 0, finished: false)
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
    @participants = @championship.participants
    @games_unfinished = PontoscorridosPartida.where(championship_id: @championship.id, finished: false)
    @games_finished = PontoscorridosPartida.where(championship_id: @championship.id, finished: true)
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

    ranks = Array.new

    campeonato.participants.each do |participante|
        r = Ranking.new(user_id: participante.user_id, played_games: 0, victories: 0, draws: 0, defeats: 0, points: 0)
        ranks << r
    end

    campeonato.pontoscorridos_partidas.each do |partida|

      if partida.finished == false
        redirect_to championship_path, :id => params[:id], :alert => "Não é possível encerrar o campeonato. Há partidas sem resultado"
        return
      end

      #Sim, tudo isso e pra descobrir o vencedor -> me julgue
      p1 = ranks.find {|s| s.user_id == partida.player1 }
      p2 = ranks.find {|t| t.user_id == partida.player2 }

      p1.played_games += 1
      p2.played_games += 1

      if partida.score_player1 > partida.score_player2
          p1.points += 11
          p1.victories += 1
          p2.points += 1
          p2.defeats += 1
      end

      if partida.score_player2 > partida.score_player1
          p2.points += 11
          p2.victories += 1
          p1.points += 1
          p1.defeats += 1
      end

      if partida.score_player1 == partida.score_player2
          p1.points += 4
          p1.draws += 1
          p2.points += 4
          p2.draws += 1
      end

    end

    ranks2 = ranks.sort_by {|obj| [obj.points * -1, obj.victories * -1, obj.draws * -1, obj.user_id]}

    #Setar o vencedor
    campeonato.winner = ranks2[0].user_id
    campeonato.save

    #Recalcular o ranking geral
    %x[rake ranking:atualizar]

    redirect_to championships_path
  end

  private

    def permitted_params
      params.require(:championship).permit(:name, :game, :starts_at, :ends_at, :championship_type_id, :user_ids)
    end
end
