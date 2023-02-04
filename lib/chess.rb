require_relative './search'
require_relative './board'
class Chess
  attr_accessor :board

  include Search

  def initialize
    @board = Board.new
  end

  def move_piece
    @board.display_board
    puts 'Hello Player, which piece would you like to move?'
    move = gets.chomp
    p move
  end

  private

  def intro
    puts 'Welcome to this chess game, The rules are the basic ones of chess'
    puts 'Player1 will be the white pieces and the player2 will be the black pieces'
    puts "These are the pieces of the black player: Pawn\u265F, Knight\u265E, Bishop\u265D, Rook\u265C, Queen\u265B  and the King\u265A"
    puts "These are the pieces of the White player: Pawn\u2659, Knight\u2658, Bishop\u2657, Rook\u2656, Queen\u2655  and the King\u2654"
  end

end

new_game = Chess.new

new_game.move_piece

