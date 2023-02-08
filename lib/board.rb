
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

  attr_accessor :image, :position, :neighbors, :owner, :column, :row, :pos

  def initialize(image, position, movements = nil)
    @image = image
    @owner = add_owner
    @column = position[0]
    @row = position[1]
    @pos = [@column, @row]
    @movements = movements
  end

  def wh?
    @owner == 'White'
  end

  def bl?
    @owner == 'Black'
  end
  
  private

  def add_owner
    return 'Black' if ["\u265A ", "\u265B ", "\u265C ", "\u265D ", "\u265E ", "\u265F"].include?(@image)
    return 'White' if ["\u2654 ", "\u2655 ", "\u2656 ", "\u2657 ", "\u2658 ", "\u2659 "].include?(@image)

    nil
  end

end

class Pawn < Piece

  def add_neighbors(board)
    white_neighbors(board) if @image.include?("\u2659 ")
  end

  def white_neighbors(board, posible_m = [[@column, @row + 1], [@column, @row + 2], [@column + 1, @row + 1], [@column - 1, @row + 1] ])
    2.times { posible_m.each { |pm| posible_m.delete(pm) if check_board_wp(board, pm) } }

    posible_m.delete([@column, @row + 2]) if @row != 2

    posible_m.delete([@column, @row + 1]) && posible_m.delete([@column, @row + 2]) if board[@column][@row + 1].bl?

    posible_m
  end

  def check_board_wp(board, pm, col = pm[0], rw = pm[1])

    return true if pm.include?(0) || pm.include?(9)

    return board[col][rw].owner != 'Black' if col == @column + 1 || col == @column - 1

    false
  end

end






