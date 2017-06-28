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
          h[campeonato.winner] = Ranking.new(user_id: campeonato.winner, played_games: 0, scheduled_games: 0, victories: 0, draws: 0, defeats: 0, points: 100, wins: 1)
        else
          h[campeonato.winner].wins += 1
          h[campeonato.winner].points += 100
        end
      end
      
      #Pontos corridos: iterar pelas partidas
      if campeonato.championship_type_id == 1
        
        campeonato.pontoscorridos_partidas.each do |partida|
          
          id_p1 = partida.player1.user.id
          id_p2 = partida.player2.user.id
          
          if h.has_key?(id_p1) == false
            h[id_p1] = Ranking.new(user_id: id_p1, played_games: 0, scheduled_games: 0, victories: 0, draws: 0, defeats: 0, points: 0, wins: 0)
          end
          
          if h.has_key?(id_p2) == false
            h[id_p2] = Ranking.new(user_id: id_p2, played_games: 0, scheduled_games: 0, victories: 0, draws: 0, defeats: 0, points: 0, wins: 0)
          end
          
          #apenas partidas finalizadas são contadas
          if(partida.finished)
            h[id_p1].played_games += 1
            h[id_p2].played_games += 1
            h[id_p1].points += 1
            h[id_p2].points += 1
            
            #Vitoria do p1
            if partida.score_player1 > partida.score_player2
              h[id_p1].victories += 1
              h[id_p1].points += 10
              h[id_p2].defeats += 1
            end
            
            #Empate
            if partida.score_player1 == partida.score_player2
              h[id_p1].draws += 1
              h[id_p2].draws += 1
              h[id_p1].points += 3
              h[id_p2].points += 3
            end
            
            #Vitoria do P2
            if partida.score_player2 > partida.score_player1
              h[id_p2].victories += 1
              h[id_p2].points += 10
              h[id_p1].defeats += 1
            end
            
          else
            h[id_p1].scheduled_games += 1
            h[id_p2].scheduled_games += 1
          end
          
        end
        
      end #Fim campeonato pontos corridos
      
      #Chaves: iterar pelas chaves
      if campeonato.championship_type_id == 2
        
        campeonato.brackets.each do |bracket|
          
          id_p1 = bracket.player_1.user.id
          id_p2 = bracket.player_2.user.id
          
          if h.has_key?(id_p1) == false
            h[id_p1] = Ranking.new(user_id: id_p1, played_games: 0, scheduled_games: 0, victories: 0, draws: 0, defeats: 0, points: 0, wins: 0)
          end
          
          if h.has_key?(id_p2) == false
            h[id_p2] = Ranking.new(user_id: id_p2, played_games: 0, scheduled_games: 0, victories: 0, draws: 0, defeats: 0, points: 0, wins: 0)
          end
          
          if(bracket.winner != nil)
            h[id_p1].played_games += 1
            h[id_p2].played_games += 1
            h[id_p1].points += 1
            h[id_p2].points += 1
            
            #Vitoria do p1
            if bracket.winner.user.id == id_p1
              h[id_p1].victories += 1
              h[id_p1].points += 10
              h[id_p2].defeats += 1
            end
            
            #vitori
            if bracket.winner.user.id == id_p2
              h[id_p2].victories += 1
              h[id_p2].points += 10
              h[id_p1].defeats += 1
            end
            
          else
            h[id_p1].scheduled_games += 1
            h[id_p2].scheduled_games += 1
          end
          
        end
        
      end
      
    end #Fim loop campeonatos
    
    puts "Criando o ranking"
    h.each_value do |registro|
      registro.save
    end
  
    puts "Ordenando o ranking"
    ranking = Ranking.order(points: :desc, victories: :desc, draws: :desc, played_games: :desc, user_id: :asc)
    count = 1
    ranking.each do |rank|
      rank.position = count
      rank.save
      
      count += 1
    end
  
  end  
    
end
