namespace :ranking do
  
  desc "Atualizar ranking"
  task atualizar: :environment do
    
    puts "Limpando a tabela de ranking"
    Ranking.delete_all
    
    h = Hash.new
    
    puts "Iterando pelos campeonatos"
    Championship.all.each do |campeonato|
      if ((campeonato.winner != 0) and (campeonato.winner != nil))
        #Se nao tiver no hash, incluir
        if h.has_key?(campeonato.winner) == false
          h[campeonato.winner] = 1
        else
          h[campeonato.winner] = h[campeonato.winner] + 1
        end
      end
    end
    
    puts "Iterando pelos usuarios"
    User.all.each do |usuario|
      
      #Contar numero de partidas
      partidas_p1 = PontoscorridosPartida.where(player1: usuario.id)
      partidas_p2 = PontoscorridosPartida.where(player2: usuario.id)
      
      num_partidas = partidas_p1.size + partidas_p2.size
      
      partidas_jogadas = 0
      partidas_programadas = 0
      campeonatos_vencidos = 0
      vitorias = 0
      empates = 0
      derrotas = 0
      pontos = 0
      
      if h.has_key?(usuario.id)
        campeonatos_vencidos = h[usuario.id]
      end
      
      partidas_p1.each do |partida|
        
        if partida.finished
          #Incrementar o contador de partidas jogadas
          partidas_jogadas = partidas_jogadas + 1
          
          #Metricas
          if partida.score_player1 > partida.score_player2
            vitorias = vitorias + 1
          end
        
          if partida.score_player1 == partida.score_player2
            empates = empates + 1
          end
          
          if partida.score_player1 < partida.score_player2
            derrotas = derrotas + 1
          end
          
        else
          #Partidas programadas
          partidas_programadas = partidas_programadas + 1
        end
        
      end
      
      partidas_p2.each do |partida|
        
        if partida.finished
          #Incrementar o contador de partidas jogadas
          partidas_jogadas = partidas_jogadas + 1
          
          #Metricas
          if partida.score_player2 > partida.score_player1
            vitorias = vitorias + 1
          end
        
          if partida.score_player2 == partida.score_player1
            empates = empates + 1
          end
          
          if partida.score_player2 < partida.score_player1
            derrotas = derrotas + 1
          end
          
        else
          #Partidas programadas
          partidas_programadas = partidas_programadas + 1
        end
        
      end
        
      #Fim Gerenciador de partidas
      pontos = campeonatos_vencidos*100 + partidas_jogadas*1 + vitorias*10 + empates*3
      
      #Incluir registro no ranking
      rank = Ranking.new(user_id: usuario.id, played_games: partidas_jogadas, scheduled_games: partidas_programadas, victories: vitorias, draws: empates, defeats: derrotas, points: pontos, wins: campeonatos_vencidos)
      rank.save
    end
    #Fim do loop de usuarios
    
    puts "Ordenando o ranking"
    ranking = Ranking.order(points: :desc, victories: :desc, draws: :desc, played_games: :desc, user_id: :asc)
    count = 1
    ranking.each do |rank|
      rank.position = count
      rank.save
      
      count = count + 1
    end
    
  end
  #Fim da task

end
