require_relative './search'
require_relative './board'
require_relative './saves'
# Chess class to play the game.
class Chess
  attr_accessor :board, :board_hash, :turn, :player_turn, :player, :last_move_piece, :moves

  include Saving

  def initialize
    @board = Board.new
    @board_hash = @board.board
    @turn = 1
    @player_turn = 'White'
    @player = @turn.odd? ? 'White' : 'Black'
    @last_move_piece = nil
    @moves = []
    save_base
  end

  # "Main" function.
  def play(_int = intro)
    until check_mate(@player)
      @player = @turn.odd? ? 'White' : 'Black'
      puts "\n#{@board.display_board}"
      break if play_turn == 'draw'

      @turn += 1
    end
  end

  # Check function puts out a message about a king being attacked!
  def check(player, attacked = ply_opo(player), pieces = @board.get_pieces(player), king = @board.get_king(attacked)[0])
    return unless pieces.any? { |piece| piece.verify(@board_hash, king.pos) }

    puts "\e[31mWatch out! The king of #{attacked} is attacked!\e[0m"
    true
  end

  # checkmate, Check if the king cannot escape an attack if so, the game is over.
  def check_mate(player, opo = ply_opo(player), king = @board.get_king(opo)[0], pieces = @board.get_pieces(opo))
    if check_conditions(player, king, pieces)
      puts "\e[32mCheckMate player #{player} Wins this Match!\e[0m"
      return true
    end
    false
  end

  # checkmate conditions.
  def check_conditions(player, king, pieces)
    return unless check(player) && king_escape(king) && block_king_attack(pieces)

    @last_move_piece.pathway(@board_hash, king.pos).each do |move|
      return false if pieces.any? { |piece| piece.verify(@board_hash, move) }
    end
  end

  def move_piece(player, movement = move_info(player), piece = movement[0], change = movement[1])
    return 'draw' if movement.include?('draw')

    if piece.verify(@board_hash, change.pos)
      change_piece(piece, change)
    else
      puts "Please try again, That move isn't posible!"
      move_piece(player)
    end
  end

  def change_piece(piece, change, target = change.pos)
    piece = check_pawn_promotion(piece, target)
    @moves << [piece.pos, change.pos]
    @board_hash[piece.col][piece.row] = Piece.new('  ', [piece.col, piece.row])
    @board_hash[change.col][change.row] = piece
    piece.update(change)
    @last_move_piece = piece
  end

  private

  # Check if the king can escape an attack by movement alone
  def king_escape(king)
    king.posible_m.none? { |move| king.verify(@board_hash, move) }
  end

  # Check if any other piece can block the king from being attack.
  def block_king_attack(pieces)
    pieces.none? { |piece| piece.verify(@board_hash,@last_move_piece.pos) }
  end

  # return the opposite of player
  def ply_opo(player)
    player == 'White' ? 'Black' : 'White'
  end

  # get infor about the moves of the pieces in the board.
  def move_info(player, array = [])
    puts "\nWhich piece would you like to move #{player}?"
    array << get_piece(player)

    return 'draw' if array.include?('draw')
    return move_info(player, array = []) if error_move(array)

    puts "\nWhere would you like to move \e[46m#{array[0].display_image}\e[0m?"
    array << get_piece(player)
  end

  # Error when the the move is not accepetd, either by being invalid or out of reach.
  def error_move(array)
    return unless array.include?(nil) || array[0].owner.nil? || array[0].owner != @player_turn

    puts 'Not accepted move, Please try again!'
    true
  end

  # return the piece base on player input if invalid repeat until valid.
  def get_piece(player, count = 0, letters = Hash[('a'..'h').map { |num| [num, count += 1] }])
    piece = gets.chomp.split(//)

    save_game if piece.join == 'save'

    if check_piece(piece)

      reset_game if piece.join == 'reset'

      return 'draw' if piece.join == 'draw'

      puts 'Invalid move, Try again!'
      return get_piece(player)
    end

    @board.board[letters[piece[0]]][piece[1].to_i]
  end

  # return if the piece to move is not a valid one.
  def check_piece(piece)
    return true if piece.length <= 1 || piece[1] =~ /[A-Za-z]/ || piece.length > 2 || piece.all? { |i| i.is_a? Integer }
  end

  # puts message about the game being over, after a player call a draw.
  def draw_game_over
    puts "player #{@player_turn} has draw the game, congratulations player#{ply_opo(@player_turn)} You WIN!!"
  end

  # check if pawn is in for a promotion if so, change the piece.
  def check_pawn_promotion(piece, target)
    return piece.check_promotion(piece, target) if piece.my_class == Pawn

    piece
  end

  # play turn, divided between white and black player, with the odd player being the white.
  def play_turn(player = @turn.odd? ? 'White' : 'Black')
    @player_turn = player
    return unless move_piece(@player_turn) == 'draw'

    puts "Player #{player} has called draw, player #{ply_opo(player)} wins the game"
    'draw'
  end

  # put method for the intro to the game
  def intro
    puts 'Welcome to this chess game, The rules are the basic ones of chess'
    puts 'Player1 will be the white pieces and the player2 will be the black pieces'
    puts "\e[33mIf you would like to draw at any point in the game type \e[34m'draw'\e[33mThe game would end at that moment.\e[0m"
    puts "\e[32mYou can save the game at any time typing \e[34m'save'\e[32m onto the console!\e[0m"
    puts "\e[90mand last but not least!, You can reset the game typing \e[34m'reset'\e[90m onto the console!\e[0m"
    puts 'Good luck! Have fun!'
    check_loads
  end
end

Chess.new.play
