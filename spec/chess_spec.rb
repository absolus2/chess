# frozen_string_literal: true

require_relative '../lib/chess'

describe Chess do
  subject(:game) { described_class.new }

  describe 'initialize' do
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
        length = board["A"].length
        expect(length).to be(8)
      end
    end

  end


end