# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# encoding: utf-8
ChampionshipType.create(title: 'Todos contra todos', description: 'Cada jogador joga com todos os outros participantes do campeonato')
ChampionshipType.create(title: 'Todos contra todos eliminatorio', description: 'Serao agendados jogos de todos contra todos, contudo, durante o campeonato, aquele jogador que acumular duas derrotas sera eliminado')