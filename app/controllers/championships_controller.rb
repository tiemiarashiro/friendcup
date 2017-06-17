class ChampionshipsController < ApplicationController
  
  @@id_pontos_corridos = 1 #definir qual ID eh o de pontos corridos
  
  helper_method :id_pontos_corridos
  
  def id_pontos_corridos
    @@id_pontos_corridos
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
    
  end

  def new
    @championship = Championship.new
  end

  def create
    attributes = permitted_params
    attributes[:user] = current_user
    @championship = Championship.new(attributes)
      
    if(@championship.save)
      
      participantes = Array.new
      
      #Salvar os participantes
      params[:championship][:user_ids].each do |participante|
        part = Participant.new(championship_id: @championship.id, user_id: participante)
        part.save
        participantes << part
      end
      
      #Falta fazer o if do tipo de campeonato
      puts "TESTE" + @championship.championship_type_id.to_s
      puts "TESTE2" + @id_pontos_corridos.to_s
      if @championship.championship_type_id == @@id_pontos_corridos
        for i in (1..participantes.size-2)
          for j in (i+1..participantes.size-1)
            partida = PontoscorridosPartida.new(championship_id: @championship.id, player1: participantes[i].user_id, player2: participantes[j].user_id, score_player1: 0, score_player2: 0, finished: false)
            partida.save
          end
        end
      
      else
        #Implementar caso de mata-mata
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
    
  end

  private

    def permitted_params
      params.require(:championship).permit(:name, :game, :starts_at, :ends_at, :championship_type_id, :user_ids)
    end

end
