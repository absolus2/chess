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

  def empty?
    @owner.nil?
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
    p posible_m
  end

  private

  def update_m(board, array, moves = array.dup)
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
        if item != self && count == @column
          mov[:v] << item.pos
        elsif item != self && item.row == @row
          mov[:h] << item.pos
        end
      end
      count -= 1
    end
    update_m(board, mov[:h].reverse) + update_m(board, mov[:v])
  end

end


class Bishop < Piece

  def add_neighbors(board, posible_m = add_moves(board))
    posible_m
  end

  def add_moves(board, moves = { lu: [], ru: get_diag([@pos]).reject! { |item| item.include?(0) || item.include?(9) }})
    count = 8
    until count.zero?
      board[count].each_value { |item| moves[:lu] << item.pos if @pos.sum == item.pos.sum && item.pos != @pos }
      count -= 1
    end
    update(board, moves[:lu].reverse)
  end

  def update(board, array, checked = array.dup)
    array.each do |item|
      piece = board[item[0]][item[1]]
      update_m(item, checked, piece) unless piece.empty?
    end
    checked
  end

  def update_m(item, array, piece, opos = opposite(piece.owner))
    if piece.column < @column
      opos ? array.slice!(0, array.find_index(item)) : array.slice!(0, array.find_index(item) + 1)
    else
      opos ? array.slice!(array.find_index(item) + 1, array.length) : array.slice!(array.find_index(item), array.length)
    end
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



class BRook

  attr_accessor :image, :pos, :owner, :posible_m

  def initialize(image, owner, pos)
    @image = image
    @owner = owner
    @pos = pos
    @col = pos[0]
    @row = pos[1]
    @posible_m = get_moves
  end

  def legal_move?(board, move)
    p "pos#{@pos}, destination#{move}"
    p @posible_m[:v].sort
  end

  private

  def get_moves(array = [], count = 1)
    8.times do
      array << [@col + count, @row] && array << [@col - count, @row]
      array << [@col, @row + count] && array << [@col, @row - count]
      count += 1
    end
    clean_moves(array)
  end

  def clean_moves(array, hash = { v:[], h:[] })
    array.select! { |item| item[0] >= 1 && item[1] >= 1 && item[0] <= 8 && item[1] <= 8 }
    array.each { |item| item[0] == @col ? hash[:v] << item : hash[:h] << item }
    hash
  end

end

