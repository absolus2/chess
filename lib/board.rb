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
    @board[key][1] = Piece.new("\u2656 ", [key, 1]) if [1, 8].include?(key)
    @board[key][1] = Piece.new("\u2658 ", [key, 1]) if [2, 7].include?(key)
    @board[key][1] = Piece.new("\u2655 ", [key, 1]) if key == 5
    @board[key][1] = Piece.new("\u2657 ", [key, 1]) if [3, 6].include?(key)
    @board[key][1] = Piece.new("\u2654 ", [key, 1]) if key == 4
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

  def opposite(item)
    return true if @owner == 'Black' && item == 'White'

    return true if @owner == 'White' && item == 'Black'
 
    false
  end

  def add_owner
    return 'Black' if ["\u265A ", "\u265B ", "\u265C ", "\u265D ", "\u265E ", "\u265F"].include?(@image)
    return 'White' if ["\u2654 ", "\u2655 ", "\u2656 ", "\u2657 ", "\u2658 ", "\u2659 "].include?(@image)

    nil
  end

  def check_tile(board, column, row, check)
    begin
      board[column][row].owner != check
    rescue => e
      true
    end
  end
end

class WhitePawn < Piece

  def add_neighbors(board, posible_m = [[@column, @row + 1], [@column, @row + 2], [@column + 1, @row + 1], [@column - 1, @row + 1] ])
    2.times { posible_m.each { |pm| posible_m.delete(pm) if check_board(board, pm) } }

    posible_m.delete([@column, @row + 2]) if @row != 2

    posible_m.delete([@column, @row + 1]) && posible_m.delete([@column, @row + 2]) if board[@column][@row + 1].bl?

    posible_m
  end

  def check_board(board, pm, col = pm[0], rw = pm[1])
    return true if pm.include?(0) || pm.include?(9)

    return board[col][rw].owner != 'Black' if col == @column + 1 || col == @column - 1

    false
  end
end

class BlackPawn < Piece

  def add_neighbors(board, posible_m = [[@column, @row - 1], [@column, @row - 2], [@column - 1, @row - 1], [@column + 1, @row - 1]])
    check_board(board, posible_m)

    posible_m.delete([@column, @row - 2]) if board[@column][@row - 2].wh?
    posible_m.delete([@column, @row - 1]) && posible_m.delete([@column, @row - 2]) if board[@column][@row - 1].wh?

    p posible_m
  end

  def check_board(board, posible_m)
    posible_m.reject! do |item|
      [@row - 2].include?(item[0]) if @row != 7

      check_tile(board, item[0], item[1], 'White') if [0, 9, @column + 1, @column - 1].include?(item[0])
    end
  end

end

class Rook < Piece

  def add_neighbors(board, posible_m = add_moves(board))
    p posible_m[:h] + posible_m[:v]
  end

  private

  def update_m(board, array, moves = array)
    array.each do |item|
      piece = board[item[0]][item[1]].owner
      update(moves, item, piece) unless piece.nil?
    end
    moves
  end

  def update(array, item, piece, opos = opposite(piece))
    if item.sum < @pos.sum
      opos ? array.slice!(0, array.find_index(item)) : array.slice!(0, array.find_index(item) + 1)
    else
      opos ? array.slice!(array.find_index(item) + 1, array.length) : array.slice!(array.find_index(item), array.length)
    end
  end

  def add_moves(board, mov = { v: [], h: [] }, count = 8)
    until count.zero?
      board[count].each_value do |item|
        mov[:v] << item.pos if item != self && count == @column
        mov[:h] << item.pos if item != self && item.row == @row
      end
      count -= 1
    end
    mov[:h] = update_m(board, mov[:h].reverse)
    mov[:v] = update_m(board, mov[:v])
    mov
  end

end


class Bishop < Piece

  def add_neighbors(board, posible_m = add_moves(board))
    posible_m
  end

  def update(board, moves)
    p moves
  end


  def add_moves(board, moves = { lu: [], ru: get_diag([@pos]).reject! { |item| item.include?(0) || item.include?(9) }})
    count = 8
    until count.zero?
      board[count].each_value { |item| moves[:lu] << item.pos if @pos.sum == item.pos.sum && item.pos != @pos }
      count -= 1
    end
    update(board, moves[:lu].reverse)
  end

  private

  def get_diag(base, start = base[0])
    8.times do
      first = base.first
      last = base.last
      base.unshift [first[0] - 1, first[1] - 1] unless first.include?(0)
      base.push [last[0] + 1, last[1] + 1] unless last.include?(9)
    end
    base.reject! { |item| item == start }
  end

end



