require_relative './search'
require_relative './board'
# Chess class to play the game.
class Chess
  attr_accessor :board, :board_hash

  def initialize
    @board = Board.new
    @board_hash = @board.board
    @player1 = 'White'
    @player2 = 'Black'
    @turn = 1
    @player_turn = 'White'
  end

  def play
    intro
    until @turn == 20
      puts "\n#{@board.display_board}"
      play_turn
      puts ' '
      @turn += 1
    end
  end

  def move_piece(player, movement = move_info(player), piece = movement[0], change = movement[1])
    if piece.verify(@board_hash, change.pos)
      change_piece(piece, change)
    else
      puts "Please try again, That move isn't posible!"
      movement[0].clear
      move_piece(player)
    end
  end

  def change_piece(piece, change)
    @board_hash[piece.col][piece.row] = Piece.new('  ', [piece.col, piece.row])
    @board_hash[change.col][change.row] = piece
    piece.update(change)
    @board.display_board
  end

  private

  def move_info(player, array = [])
    puts "\nWhich piece would you like to move #{player}?"
    array << get_piece(player)

    return move_info(player, array = []) if error_move(array)

    puts "\nWhere would you like to move #{array[0].image}?"
    array << get_piece(player)
    array
  end

  def error_move(array)
    if array.include?(nil) || array[0].owner.nil? || array[0].owner != @player_turn
      puts 'Not accepted move, Please try again!'
      true
    end
  end

  def get_piece(player, count = 0, letters = Hash[('a'..'h').map { |num| [num, count += 1] }])
    piece = gets.chomp.split(//)

    if piece.length <= 1 || piece[1] =~ /[A-Za-z]/
      puts 'try again, Thats not a valid tile'
      return get_piece(player)
    end

    @board.board[letters[piece[0]]][piece[1].to_i]
  end

  def play_turn(player = @turn.odd? ? 'White' : 'Black')
    @player_turn = player
    move_piece(@player_turn)
  end

  def intro
    puts 'Welcome to this chess game, The rules are the basic ones of chess'
    puts 'Player1 will be the white pieces and the player2 will be the black pieces'
  end

end

new_game = Chess.new


new_game.play
