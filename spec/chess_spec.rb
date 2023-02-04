# frozen_string_literal: true

require_relative '../lib/chess'

describe Chess do
  subject(:game) { described_class.new }

  describe '#initialize' do
    context 'when the game initialize' do
      it 'creates a board' do
        board = game.instance_variable_get(:@board)
        expect(board).to be_a(Hash)
      end

      it 'the board hash a length of 8 columns ' do
        board = game.instance_variable_get(:@board)
        length = board.length
        expect(length).to eq(8)
      end

      it 'the board has row of length 8' do
        board = game.instance_variable_get(:@board)
        length = board[1].length
        expect(length).to be(8)
      end
    end

  end

  describe '#base_config' do
    context 'when loading a new game' do
      it 'populates the board with the pieces for a normal game' do
        board = game.instance_variable_get(:@board)
        expect(board).to be(game.instance_variable_get(:@board))
      end
    end
  end



  describe '#display' do
    # output method of the board
  end
  
  describe '#intro' do
    # output the introduction of the game
  end

  describe '#move_piece' do
    context 'when selecting a piece' do
      it 'output a message about selecting a piece' do
        expect(game).to receive(:puts).with('You pick')
        game.move_piece
      end

      it 'changes the piece from a position to another' do

      end
    end
  end

  describe '#get_piece' do
    context 'when selecting piece' do
      it ' '
    end
  end

end