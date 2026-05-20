require 'spec_helper'

describe Board do
  let(:board) { Board.new }

  it 'creates an 8x8 grid' do
    expect(board.grid.size).to eq(8)
    expect(board.grid.all? { |row| row.size == 8 }).to eq(true)
  end

  it 'starts with nil squares before setup' do
    expect(board.grid.flatten.all?(&:nil?)).to eq(true)
  end

  context 'after setup' do
    before { board.setup }

    it 'places black and white back rank pieces' do
      expect(board.piece_at(0, 0)).to be_a(Rook)
      expect(board.piece_at(0, 0).color).to eq(:black)
      expect(board.piece_at(7, 0)).to be_a(Rook)
      expect(board.piece_at(7, 0).color).to eq(:white)
    end

    it 'places pawns on the second rank for each side' do
      expect(board.piece_at(1, 4)).to be_a(Pawn)
      expect(board.piece_at(6, 4)).to be_a(Pawn)
    end
  end

  describe '#move_piece' do
    it 'moves a piece from one square to another' do
      board.setup
      board.move_piece(6, 4, 4, 4)
      expect(board.piece_at(6, 4)).to be_nil
      expect(board.piece_at(4, 4)).to be_a(Pawn)
      expect(board.piece_at(4, 4).color).to eq(:white)
    end

    it 'raises when there is no piece at the source square' do
      expect { board.move_piece(3, 3, 4, 4) }.to raise_error('No piece to move')
    end
  end

  describe '#in_bounds?' do
    it 'returns true for squares on the board' do
      expect(board.in_bounds?(0, 0)).to eq(true)
      expect(board.in_bounds?(7, 7)).to eq(true)
    end

    it 'returns false for squares outside the board' do
      expect(board.in_bounds?(-1, 0)).to eq(false)
      expect(board.in_bounds?(8, 2)).to eq(false)
    end
  end
end
