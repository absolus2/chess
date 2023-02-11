require_relative './search'
require_relative './board'
class Chess
  attr_accessor :board

  def initialize
    @board = Board.new
    @player1 = 'White'
    @player2 = 'Black'
    @turn = 1
    @player_turn = 'White'
  end

  def play
    until @turn == 12
      puts "\n#{@board.display_board}"
      play_turn
      p @player_turn
      @turn += 1
    end
  end

  def move_piece
    @board.display_board
    puts "\nWhich piece would you like to move? #{@player1} player"
    move = get_move
    check_empty(move) ? move_piece : piece_info(@board.board[move[0]][move[1]])
  end

  def piece_info(piece)
    puts "\nwhere would you like to move #{piece.image}"
    p piece
    next_m = get_move
    moves = piece.add_neighbors(@board.board)
    p moves.include?(next_m)
  end

  private

  def check_empty(move)
    @board.board[move[0]][move[1]].owner.nil?
  end

  def get_move(count = 0, letters = Hash[('a'..'h').map { |letter| [letter, count += 1] }])
    move = gets.chomp.split(//)
    cl = letters[move[0]]
    rw = move[1].to_i
    [cl, rw]
  end

  def play_turn(player = @turn.odd? ? 'White' : 'Black')
    @player_turn = player
    move_piece(@player_turn)
  end

  def intro
    puts 'Welcome to this chess game, The rules are the basic ones of chess'
    puts 'Player1 will be the white pieces and the player2 will be the black pieces'
    puts "These are the pieces of the black player: Pawn\u265F, Knight\u265E, Bishop\u265D, Rook\u265C, Queen\u265B  and the King\u265A"
    puts "These are the pieces of the White player: Pawn\u2659, Knight\u2658, Bishop\u2657, Rook\u2656, Queen\u2655  and the King\u2654"
  end

end

new_game = Chess.new

new_game.board.board[4][4] = WhiteRook.new("\u2656 ", [4, 4])

new_game.move_piece
