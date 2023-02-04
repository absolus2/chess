
require_relative './search'

class Board

  attr_accessor :board

  def initialize
    @board = Hash[(1..8).map { |num| [num, Hash[(1..8).map { |nums| [nums, Piece.new("\u2003 ", [num, nums])] }]] }]
    @black_pieces = ["\u265A ", "\u265B ", "\u265C ", "\u265D ", "\u265E ", "\u265F"]
    @white_pieces = ["\u2654 ", "\u2655 ", "\u2656 ", "\u2657 ", "\u2658 ", "\u2659 "]
  end

  def display_board(count = 8, black = "\e[40m")
    until count.zero?

      even_line(black, count) if count.even?

      odd_line(black, count) if count.odd?

      count -= 1
    end
    print "#{black}      A      B      C      D      E      F      G      H"
  end

  private

  def base_config
    @board.each do |key, v|
      v.each_with_index do |_item, index|
        @board[key][index] = Piece.new("\u2659 ", [key, index]) if index == 2
        @board[key][index] = Piece.new("\u265F", [key, index]) if index == 7
        w_pop(key)
        b_pop(key)
      end
    end

  end

  def w_pop(key)
    @board[key][1] = Piece.new("\u2656 ",[key, 1]) if [1, 8].include?(key)
    @board[key][1] = Piece.new("\u2658 ",[key, 1]) if [2, 7].include?(key)
    @board[key][1] = Piece.new("\u2655 ",[key, 1]) if key == 5
    @board[key][1] = Piece.new("\u2657 ",[key, 1]) if [3, 6].include?(key)
    @board[key][1] = Piece.new("\u2654 ",[key, 1]) if key == 4
  end

  def b_pop(key)
    @board[key][8] = Piece.new("\u265C ", [key, 8]) if [1, 8].include?(key)
    @board[key][8] = Piece.new("\u265E ", [key, 8]) if [2, 7].include?(key)
    @board[key][8] = Piece.new("\u265B ", [key, 8]) if key == 5
    @board[key][8] = Piece.new("\u265D ", [key, 8]) if [3, 6].include?(key)
    @board[key][8] = Piece.new("\u265A ", [key, 8]) if key == 4
  end

  def odd_line(black, row)
    puts "#{row}  \e[44m  #{@board[1][row].image} \e[44m  \e[100m  #{@board[2][row].image} \e[100m  \e[44m  #{@board[3][row].image} \e[44m  \e[100m  #{@board[4][row].image} \e[100m  \e[44m  #{@board[5][row].image} \e[44m  \e[100m  #{@board[6][row].image} \e[100m  \e[44m  #{@board[7][row].image} \e[44m  \e[100m  #{@board[8][row].image} \e[100m #{black}"
  end

  def even_line(black, row)
    puts "#{row}  \e[100m  #{@board[1][row].image} \e[100m  \e[44m  #{@board[2][row].image} \e[44m  \e[100m  #{@board[3][row].image} \e[100m  \e[44m  #{@board[4][row].image} \e[44m  \e[100m  #{@board[5][row].image} \e[100m  \e[44m  #{@board[6][row].image} \e[44m  \e[100m  #{@board[7][row].image} \e[100m  \e[44m  #{@board[8][row].image} \e[44m #{black}"
  end

end

class Piece 

  attr_accessor :image, :position, :neighbors, :owner

  def initialize(image, position, neighbors = nil)
    @image = image
    @owner = add_owner
    @position = position
    @neighbors = neighbors
  end

  def print_board
    p @board
  end

  private

  def add_owner
    return 'Black' if ["\u265A ", "\u265B ", "\u265C ", "\u265D ", "\u265E ", "\u265F"].include?(@image)
    return 'White' if ["\u2654 ", "\u2655 ", "\u2656 ", "\u2657 ", "\u2658 ", "\u2659 "].include?(@image)

    nil
  end

end




