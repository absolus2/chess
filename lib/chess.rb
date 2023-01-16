class Chess

  attr_reader :board

  def initialize 
    @board = Hash[('A'..'H').map { |num| [num, (1..8).to_a ] }] 
  end

  
end 

game = Chess.new

