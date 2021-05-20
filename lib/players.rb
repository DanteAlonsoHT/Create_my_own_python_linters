class Players < Game
  attr_reader :player1, :player2

  def initialize(player1, player2)
    super
    @player1 = player1
    @player2 = player2
    @i = 0
    @j = 0
    @marker = []
    @marker2 = []
  end

  def save_marker_player1(move_selected)
    @marker[@i] = move_selected
    @i += 1
  end

  def save_marker_player2(move_selected2)
    @marker2[@j] = move_selected2
    @j += 1
  end

  def player1_marker
    @marker.permutation(3).to_a
  end

  def player2_marker
    @marker2.permutation(3).to_a
  end

  def players_finish_turn
    case @winner
    when 1
      "\t#{@player1} won the Ruby's Tic Tac Toe\t"
    when 2
      "\t#{@player2} won the Ruby's Tic Tac Toe\t"
    else
      "\tIt's a TIE"
    end
  end
end
