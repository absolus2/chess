require_relative './search'
# Class for the Board
class Board
  attr_accessor :board, :kings

  def initialize
    @board = Hash[(1..8).map { |num| [num, Hash[(1..8).map { |nums| [nums, Piece.new('  ', [num, nums])] }]] }]
    base_config
  end

  # return the pieces of the board base on the player value
  def get_pieces(player, array = [])
    @board.each { |_key, column| column.each { |_col, piece| array << piece if piece.owner == player && piece.owner != nil } }
    array
  end

  # return the king on the board base on the player value
  def get_king(player, king = [])
    @board.each { |_key, column| column.each { |_col, piece| king << piece if piece.my_class == King && piece.owner == player } }
    king
  end

  # method to display the board
  def display_board(count = 8, black = "\e[0m")
    until count.zero?

      even_line(black, count) if count.even?

      odd_line(black, count) if count.odd?

      count -= 1
    end
    puts "#{black}      A      B      C      D      E      F      G      H\e[0m"
  end

  private

  # method to populate the board
  def base_config
    @board.each do |key, v|
      v.each do |v_key, _item|
        white_populate(key, v_key)
        black_populate(key, v_key)
      end
    end
  end

  # method to populate the board with black pieces
  def black_populate(key, index)
    case index
    when 7
      @board[key][index] = Pawn.new("\u265F", [key, index])
    when 8
      black_populate_eigth(key, index)
      @board[key][index] = Queen.new("\u265B ", [key, index]) if key == 4
      @board[key][index] = King.new("\u265A ", [key, index]) if key == 5
    end
  end

  def black_populate_eigth(key, index)
    @board[key][index] = Rook.new("\u265C ", [key, index]) if [1, 8].include?(key)
    @board[key][index] = Knight.new("\u265E ", [key, index]) if [2, 7].include?(key)
    @board[key][index] = Bishop.new("\u265D ", [key, index]) if [3, 6].include?(key)
  end

  # method to populate the board with white pieces
  def white_populate(key, index)
    case index
    when 2
      @board[key][index] = Pawn.new("\u2659 ", [key, index]) if index == 2
    when 1
      white_populate_first(key, index)
      @board[key][index] = Queen.new("\u2655 ", [key, index]) if key == 4
      @board[key][index] = King.new("\u2654 ", [key, index]) if key == 5
    end
  end

  def white_populate_first(key, index)
    @board[key][index] = Rook.new("\u2656 ", [key, index]) if [1, 8].include?(key)
    @board[key][index] = Knight.new("\u2658 ", [key, index]) if [2, 7].include?(key)
    @board[key][index] = Bishop.new("\u2657 ", [key, index]) if [3, 6].include?(key)
  end

  # display the line if is an odd line
  def odd_line(black, row)
    puts "\e[37m#{row}\e[0m  \e[44m  #{@board[1][row].display_image} \e[44m  \e[100m  #{@board[2][row].display_image} \e[100m  \e[44m  #{@board[3][row].display_image} \e[44m  \e[100m  #{@board[4][row].display_image} \e[100m  \e[44m  #{@board[5][row].display_image} \e[44m  \e[100m  #{@board[6][row].display_image} \e[100m  \e[44m  #{@board[7][row].display_image} \e[44m  \e[100m  #{@board[8][row].display_image} \e[100m #{black}"
  end

  # display the line if is an even line
  def even_line(black, row)
    puts "\e[37m#{row}\e[0m  \e[100m  #{@board[1][row].display_image} \e[100m  \e[44m  #{@board[2][row].display_image} \e[44m  \e[100m  #{@board[3][row].display_image} \e[100m  \e[44m  #{@board[4][row].display_image} \e[44m  \e[100m  #{@board[5][row].display_image} \e[100m  \e[44m  #{@board[6][row].display_image} \e[44m  \e[100m  #{@board[7][row].display_image} \e[100m  \e[44m  #{@board[8][row].display_image} \e[44m #{black}"
  end
end
