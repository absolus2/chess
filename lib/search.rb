# Module to search the path of a piece.
module Search
  def search(target, queue = [self], first = queue[0])
    return nil if first.nil?

    # function to create a map of Parent elements and children
    to_map(first)

    # return the map if the target is the same as the first element in queue
    return show_path(target) if target == first.pos

    # add every neightbor of the actual element to the queue unless already in the checked list.
    first.posible_m.each do |item|
      queue << @my_class.new(@image, item, first.pos) unless @checked.include?(item)
      @checked << item unless @checked.include?(item)
    end
    # recursive function
    search(target, queue.drop(1))
  end

  # return the path created from the search function.
  def show_path(target, common = [target])
    @map.reverse_each { |key, value| common.unshift(key) if value.include?(common[0]) }
    common.compact.drop(1)
  end

  # create a hash of parent elements and the childrens.
  def to_map(first)
    if @map.key?(first.parent)
      @map[first.parent] << first.pos unless @map[first.parent].include?(first.pos)
    else
      @map[first.parent] = [first.pos]
    end
  end
end

# Base piece to represent an empty tile
class Piece
  attr_accessor :image, :pos, :pieces, :owner, :col, :row

  def initialize(image, pos, parent = nil)
    @image = image
    @pos = pos
    @col = pos[0]
    @row = pos[1]
    @parent = parent
    @checked = []
    @map = {}
    @owner = add_owner
    clean_moves
  end

  # set checked and map class variables to its base values(empty)
  def clear
    @checked = []
    @map = {}
  end

  # return true if the item is the opposite piece, otherwise return false.
  def opposite(item)
    return true if @owner == 'Black' && item == 'White'

    return true if @owner == 'White' && item == 'Black'

    false
  end

  # update the piece to the new variables of the tile/piece taken.
  def update(piece)
    @pos = piece.pos
    @col = piece.col
    @row = piece.row
    @checked = []
    @map = {}
    @posible_m = update_moves
    clean_moves
  end

  # if the move is legal proceed to check if the piece can move
  def verify(board, target, moves = search(target))
    return false if moves.nil?

    # if the move is legal, then proceed to check the tiles for other pieces.
    check_tiles(board, moves) if check_moves(moves)
  end

  # add colour to the image
  def display_image
    return "\e[30m#{@image}" if @owner == 'Black'

    return "\e[37m#{@image}" if @owner == 'White'

    @image
  end

  private

  # give owner depending of the image code
  def add_owner
    return 'Black' if ["\u265A ", "\u265B ", "\u265C ", "\u265D ", "\u265E ", "\u265F"].include?(@image)
    return 'White' if ["\u2654 ", "\u2655 ", "\u2656 ", "\u2657 ", "\u2658 ", "\u2659 "].include?(@image)

    nil
  end

  # clean the posible moves list.
  def clean_moves
    @posible_m&.select! { |item| item[0] >= 1 && item[1] >= 1 && item[0] <= 8 && item[1] <= 8 }
  end
end

# The rook piece
class Rook < Piece
  attr_reader :pos, :parent, :posible_m, :owner, :col, :row

  include Search

  def initialize(image, pos, parent = nil)
    super(image, pos, parent)
    @posible_m = update_moves
    @my_class = Rook
    clean_moves
  end

  def check_tiles(board, moves, last = board[moves[-1][0]][moves[-1][1]].owner)
    return true if moves.all? { |item| board[item[0]][item[1]].instance_of?(Piece) }

    opposite(last) && moves[0, moves.length - 1].all? { |item| board[item[0]][item[1]].instance_of?(Piece) }
  end

  private

  # check if the move is legal (that can be done in only 1 movement)
  def check_moves(moves)
    moves.all? { |item| item.include?(@col) || item.include?(@row) }
  end

  def update_moves
    [[@col + 1, @row], [@col - 1, @row], [@col, @row + 1], [@col, @row - 1]]
  end

end

# The bishop piece
class Bishop < Piece
  attr_reader :pos, :parent, :posible_m, :owner, :col, :row

  include Search

  def initialize(image, pos, parent = nil)
    super(image, pos, parent)
    @posible_m = update_moves
    @my_class = Bishop
    clean_moves
  end

  # check the tiles after the move is considered legal, to check for other pieces,
  def check_tiles(board, moves, last = board[moves[-1][0]][moves[-1][1]].owner)
    return true if moves.all? { |item| board[item[0]][item[1]].instance_of?(Piece) }

    opposite(last) && moves[0, moves.length - 1].all? { |item| board[item[0]][item[1]].instance_of?(Piece) }
  end

  private

  def check_moves(moves)
    # Check moves the sum of the elements from the item and the pos should be the same
    # Check moves, if the absolute value of the substration of the piece and the item is the same, the move is valid
    moves.all? { |item| item.sum == @pos.sum || (item[0] - item[1]).abs == (@col - @row).abs }
  end

  # Update the posible moves value, to what it should be.
  def update_moves
    [[@col + 1, @row + 1], [@col - 1, @row - 1], [@col - 1, @row + 1], [@col + 1, @row - 1]]
  end
end

# Class for knight Piece
class Knight < Piece
  attr_reader :pos, :parent, :posible_m, :owner, :col, :row

  include Search

  def initialize(image, pos, parent = nil)
    super(image, pos, parent)
    @posible_m = update_moves
    @my_class = Knight
    clean_moves
  end

  private

  # Check to see if the destination tile is occupied, if it is check then the owner of the piece.
  def check_tiles(board, moves, col = moves[0][0], row = moves[0][1])
    return true if board[col][row].instance_of?(Piece)

    opposite(board[col][row].owner)
  end

  # check if the move is legal, We only check to see if the moves array is of length 1, since the knight can skip over pieces.
  def check_moves(moves)
    true if moves.length == 1
  end

  def update_moves
    [[@col - 1, @row + 2], [@col + 1, @row + 2], [@col - 2, @row + 1], [@col + 2, @row + 1], [@col - 2, @row - 1], [@col - 1, @row - 2], [@col + 1, @row - 2], [@col + 2, @row - 1]]
  end
end

# Class for the queen Piece
class Queen < Piece
  attr_reader :pos, :parent, :posible_m, :owner, :col, :row

  include Search

  def initialize(image, pos, parent = nil)
    super(image, pos, parent)
    @posible_m = update_moves
    @my_class = Queen
    clean_moves
  end

  private

  def check_tiles(board, moves, last = board[moves[-1][0]][moves[-1][1]].owner)
    return true if moves.all? { |item| board[item[0]][item[1]].instance_of?(Piece) }

    opposite(last) && moves[0, moves.length - 1].all? { |item| board[item[0]][item[1]].instance_of?(Piece) }
  end

  def check_moves(moves)
    return true if moves.all? { |item| item.sum == @pos.sum || (item[0] - item[1]) == (@col - @row).abs }

    return true if moves.all? { |item| item.include?(@col) || item.include?(@row) }

    false
  end

  def update_moves
    [[@col + 1, @row], [@col - 1, @row], [@col, @row + 1], [@col, @row - 1], [@col + 1, @row + 1], [@col - 1, @row - 1], [@col - 1, @row + 1], [@col + 1, @row - 1]]
  end
end

# class for the king Piece
class King < Piece
  attr_reader :pos, :parent, :posible_m, :owner, :col, :row

  include Search

  def initialize(image, pos, parent = nil)
    super(image, pos, parent)
    @posible_m = update_moves
    @my_class = King
    clean_moves
  end

  # if the move is legal proceed to check if the piece can move
  def verify(board, target, moves = search(target))
    return false if moves.nil?

    # if the move is legal, then proceed to check the tiles for other pieces.
    check_tiles(board, moves) if check_moves(moves)
  end
 
  private

  def check_tiles(board, moves, tile = moves[0])
    return true if board[tile[0]][tile[1]].instance_of?(Piece)

    opposite(board[tile[0]][tile[1]].owner)
  end

  def check_moves(moves)
    true if moves.length == 1
  end

  def update_moves
    [[@col + 1, @row], [@col - 1, @row], [@col, @row + 1], [@col, @row - 1], [@col + 1, @row + 1], [@col - 1, @row - 1], [@col + 1, @row - 1], [@col - 1, @row + 1]]
  end
end

# Class for the Pawn Piece
class Pawn < Piece
  attr_reader :pos, :parent, :posible_m, :owner, :col, :row

  include Search

  def initialize(image, pos, parent = nil)
    super(image, pos, parent)
    @posible_m = update_moves
    @my_class = Pawn
    clean_moves
  end

  private

  def check_tiles(board, moves, col = moves[0][0], row = moves[0][1])
    return true if col == @col && moves.all? { |item| board[item[0]][item[1]].instance_of?(Piece) }

    opposite(board[col][row].owner) if col != @col
  end

  def check_moves(moves)
    return true if moves.all? { |item| item[0] == @col } && moves.length <= 2

    true if moves.length == 1
  end

  # updates the moves depending on the owner of the piece.
  def update_moves
    @owner == 'Black' ? update_moves_black : update_moves_white
  end

  def update_moves_black
    [[@col, @row - 1], [@col + 1, @row - 1], [@col - 1, @row - 1]]
  end

  def update_moves_white
    [[@col, @row + 1], [@col + 1, @row + 1], [@col - 1, @row + 1]]
  end
end
