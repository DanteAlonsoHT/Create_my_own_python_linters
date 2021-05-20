class Game
  def initialize(_player1, _player2)
    @array_position = 0
    @moves_used = []
    @combinations_likely_to_win = [[1, 2, 3], [2, 5, 8], [3, 6, 9], [4, 5, 6], [1, 4, 7], [1, 5, 9], [3, 5, 7],
                                   [7, 8, 9]]

    @combinations_likely_to_win.each do |values_to_win|
      @combinations_likely_to_win += [values_to_win.rotate(2)]
      @combinations_likely_to_win += [values_to_win.rotate(-2)]
    end

    @winner = 0
  end

  def start
    system 'clear'

    @game_board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  end

  def return_game_board
    @game_board
  end

  def moves_used(move_used)
    @moves_used[@array_position] = move_used
    @array_position += 1
    @moves_used = @moves_used.compact
  end

  def read_moves_used
    @moves_used
  end

  def check_moves_repeated(move_likely_repeated)
    return false if @moves_used.empty?

    @moves_used.each do |value|
      return true if value.to_i == move_likely_repeated
    end
    false
  end

  def update_board(pos_selected, new_element)
    @game_board.each do |board_row|
      (0..2).each do |board_element|
        board_row[board_element] = new_element if board_row[board_element] == pos_selected
      end
    end
  end

  def check_winner(array_selected1, array_selected2)
    array_selected1.each do |value|
      @winner = 1 if @combinations_likely_to_win.include?(value)
    end

    array_selected2.each do |value|
      @winner = 2 if @combinations_likely_to_win.include?(value)
    end
    @winner
  end

  def check_update_board(move_choiced, print_to_dashboard)
    move_repeated = check_moves_repeated(move_choiced)
    until ((1..9).include? move_choiced) && !move_repeated
      puts "\t Invalid, please select a number between 1 to 9 and don' repeat them."
      move_choiced = gets.chomp.to_i
      move_repeated = check_moves_repeated(move_choiced)
    end
    update_board(move_choiced, print_to_dashboard)
    moves_used(move_choiced)
  end
end
