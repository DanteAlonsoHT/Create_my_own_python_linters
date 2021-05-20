#!/usr/bin/env ruby

require_relative '../lib/game'
require_relative '../lib/players'

system 'clear'

puts "
\t
\t░██╗░░░░░░░██╗███████╗██╗░░░░░░█████╗░░█████╗░███╗░░░███╗███████╗
\t░██║░░██╗░░██║██╔════╝██║░░░░░██╔══██╗██╔══██╗████╗░████║██╔════╝
\t░╚██╗████╗██╔╝█████╗░░██║░░░░░██║░░╚═╝██║░░██║██╔████╔██║█████╗░░
\t░░████╔═████║░██╔══╝░░██║░░░░░██║░░██╗██║░░██║██║╚██╔╝██║██╔══╝░░
\t░░╚██╔╝░╚██╔╝░███████╗███████╗╚█████╔╝╚█████╔╝██║░╚═╝░██║███████╗
\t░░░╚═╝░░░╚═╝░░╚══════╝╚══════╝░╚════╝░░╚════╝░╚═╝░░░░░╚═╝╚══════╝ \n \n"

puts "\t to an amazing game :D -> Ruby's Tic Tac Toe"
puts "\t Please, give me two names to each player \n \n"

puts 'First player name: '
player1 = gets.chomp.capitalize

while player1.empty?
  puts "\t Invalid name, try again!
  \n First player name: "
  player1 = gets.chomp.capitalize
end

puts 'Second player name: '
player2 = gets.chomp.capitalize

while player2.empty?
  puts "\t Invalid name, try again!
  \n Second player name: "
  player2 = gets.chomp.capitalize
end

game_trial = Players.new(player1, player2)

puts "\n \t #{game_trial.player1} is going to play 'X', and #{game_trial.player2} will play 'O'"
puts "\t Let's start"

sleep(1)

game_trial.start

def display_board(game_trial)
  (0..2).each do |i|
    puts "\t +---+---+---+"
    print "\t"
    (0..7).each do |j|
      print ' | ' unless j.odd?
      print game_trial.return_game_board[i][((j * 3) / 7).to_i] unless j.even?
    end
    puts i == 2 ? "\n\t +---+---+---+" : "\t"
  end
end

puts "
  \t ██╗░░░░░░█████╗░░█████╗░██████╗░██╗███╗░░██╗░██████╗░░░░░░░░░░
  \t ██║░░░░░██╔══██╗██╔══██╗██╔══██╗██║████╗░██║██╔════╝░░░░░░░░░░
  \t ██║░░░░░██║░░██║███████║██║░░██║██║██╔██╗██║██║░░██╗░░░░░░░░░░
  \t ██║░░░░░██║░░██║██╔══██║██║░░██║██║██║╚████║██║░░╚██╗░░░░░░░░░
  \t ███████╗╚█████╔╝██║░░██║██████╔╝██║██║░╚███║╚██████╔╝██╗██╗██╗
  \t ╚══════╝░╚════╝░╚═╝░░╚═╝╚═════╝░╚═╝╚═╝░░╚══╝░╚═════╝░╚═╝╚═╝╚═╝"

sleep(1)

player1_turn = lambda {
  system 'clear'

  next unless game_trial.check_winner(game_trial.player1_marker, game_trial.player2_marker).zero?

  display_board(game_trial)
  puts "\t It's #{game_trial.player1}'s turn \n"
  puts "\t Reminder: You're 'X'"
  x_selected = gets.chomp.to_i
  game_trial.check_update_board(x_selected, 'X')
  game_trial.save_marker_player1(x_selected)
  system 'clear'
  display_board(game_trial)
}

player2_turn = lambda {
  system 'clear'
  next unless game_trial.check_winner(game_trial.player1_marker, game_trial.player2_marker).zero?

  display_board(game_trial)
  puts "\t It's #{game_trial.player2}'s turn \n"
  puts "\t Reminder: You're 'O'"
  o_selected = gets.chomp.to_i
  game_trial.check_update_board(o_selected, 'O')
  game_trial.save_marker_player2(o_selected)
  system 'clear'
  display_board(game_trial)
}

until game_trial.check_winner(game_trial.player1_marker,
                              game_trial.player2_marker) != 0 || (game_trial.read_moves_used.length > 8)
  player1_turn.call
  break if game_trial.check_winner(game_trial.player1_marker,
                                   game_trial.player2_marker) != 0 || (game_trial.read_moves_used.length > 8)

  player2_turn.call
end

system 'clear'

puts "\t
  \t░██████╗░░█████╗░███╗░░░███╗███████╗  ░█████╗░██╗░░░██╗███████╗██████╗░
  \t██╔════╝░██╔══██╗████╗░████║██╔════╝  ██╔══██╗██║░░░██║██╔════╝██╔══██╗
  \t██║░░██╗░███████║██╔████╔██║█████╗░░  ██║░░██║╚██╗░██╔╝█████╗░░██████╔╝
  \t██║░░╚██╗██╔══██║██║╚██╔╝██║██╔══╝░░  ██║░░██║░╚████╔╝░██╔══╝░░██╔══██╗
  \t╚██████╔╝██║░░██║██║░╚═╝░██║███████╗  ╚█████╔╝░░╚██╔╝░░███████╗██║░░██║
  \t░╚═════╝░╚═╝░░╚═╝╚═╝░░░░░╚═╝╚══════╝  ░╚════╝░░░░╚═╝░░░╚══════╝╚═╝░░╚═╝ \n \n"

puts game_trial.players_finish_turn
