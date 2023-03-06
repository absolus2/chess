require_relative './search'
# Class for the Board
class Board
  attr_accessor :board

  def initialize
    @board = Hash[(1..8).map { |num| [num, Hash[(1..8).map { |nums| [nums, Piece.new('  ', [num, nums])] }]] }]
    @black_pieces = ["\u265A ", "\u265B ", "\u265C ", "\u265D ", "\u265E ", "\u265F"]
    @white_pieces = ["\u2654 ", "\u2655 ", "\u2656 ", "\u2657 ", "\u2658 ", "\u2659 "]
   base_config
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
      v.each do |v_key, item|
        white_populate(key, v_key)
        black_populate(key, v_key)
      end
    end
  end

  def black_populate(key, index)
  case index
  when 7
    @board[key][index] = Pawn.new("\u265F", [key, index])
  when 8
    @board[key][index] = Rook.new("\u265C ", [key, index]) if [1, 8].include?(key)
    @board[key][index] = Knight.new("\u265E ", [key, index]) if [2, 7].include?(key)
    @board[key][index] = Bishop.new("\u265D ", [key, index]) if [3, 6].include?(key)
    @board[key][index] = Queen.new("\u265B ", [key, index]) if key == 4
    @board[key][index] = King.new("\u265A ", [key, index]) if key == 5
  end
  end

  def white_populate(key, index)
    @board[key][index] = Pawn.new("\u2659 ", [key, index]) if index == 2
    if index == 1
      @board[key][index] = Rook.new("\u2656 ", [key, index]) if [1, 8].include?(key)
      @board[key][index] = Knight.new("\u2658 ", [key, index]) if [2, 7].include?(key)
      @board[key][index] = Bishop.new("\u2657 ", [key, index]) if [3, 6].include?(key)
      @board[key][index] = Queen.new("\u2655 ", [key, index]) if key == 4
      @board[key][index] = King.new("\u2654 ", [key, index]) if key == 5
    end
  end

  def odd_line(black, row)
    puts "\e[37m#{row}\e[0m  \e[44m  #{@board[1][row].display_image} \e[44m  \e[100m  #{@board[2][row].display_image} \e[100m  \e[44m  #{@board[3][row].display_image} \e[44m  \e[100m  #{@board[4][row].display_image} \e[100m  \e[44m  #{@board[5][row].display_image} \e[44m  \e[100m  #{@board[6][row].display_image} \e[100m  \e[44m  #{@board[7][row].display_image} \e[44m  \e[100m  #{@board[8][row].display_image} \e[100m #{black}"
  end

  def even_line(black, row)
    puts "\e[37m#{row}\e[0m  \e[100m  #{@board[1][row].display_image} \e[100m  \e[44m  #{@board[2][row].display_image} \e[44m  \e[100m  #{@board[3][row].display_image} \e[100m  \e[44m  #{@board[4][row].display_image} \e[44m  \e[100m  #{@board[5][row].display_image} \e[100m  \e[44m  #{@board[6][row].display_image} \e[44m  \e[100m  #{@board[7][row].display_image} \e[100m  \e[44m  #{@board[8][row].display_image} \e[44m #{black}"
  end
end


